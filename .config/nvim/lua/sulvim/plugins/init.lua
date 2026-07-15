local utils = require(main .. ".utils")

local parent_folder = utils.get_parent_folder()
local plugins = utils.load_modules(parent_folder, ".*/(.*).lua", { "init" }, true)

local modules = {}

local function handle_url(url)
	local github = "https://github.com/"
	if not utils.starts_with(url, github) then
		return github .. url
	else
		return url
	end

	error("invalid url")
end

local function load_plugin(fname, plugin)
	if not plugin or type(plugin) ~= "table" or type(plugin[1]) ~= "table" then
		error(string.format("Invalid plugin spec filename: '%s'", fname))
	else
		local plugin_urls = plugin[1]

		local first_url, first_name
		for i = 1, #plugin_urls do
			local plugin_url = plugin_urls[i]
			local handled, name
			if type(plugin_url) == "table" then
				handled, name = handle_url(plugin_url.src), plugin_url.name
				plugin_url.src = handled
				plugin_urls[i] = plugin_url
			elseif type(plugin_url) == "string" then
				handled = handle_url(plugin_url)
				plugin_urls[i] = handle_url(plugin_url)
			end

			if i == 1 then
				first_url, first_name = handled, name
			end
		end

		vim.pack.add(plugin_urls) -- i will sort lazy loading later

		local mappings = plugin.keys

		if mappings then
			if type(mappings) ~= "table" then error("mappings must be a table") end

			utils.load_mappings({ n = mappings })
		end

		plugin.url = first_url

		if first_url then
			local splitted = vim.split(first_url, "/")
			local pkg = splitted[#splitted]
			local cleaned_pkg = first_name or string.gsub(pkg, "%.nvim$", "")

			local opts = plugin.opts or {}
			local resolved = type(opts) == "function" and opts() or opts
			local ok, module = pcall(require, cleaned_pkg)
			if not ok then module = nil end

			local config = plugin.config
			if config and type(config) == "function" then
				config(module, resolved)
			elseif type(resolved) == "table" and module and type(module.setup) == "function" then
				module.setup(resolved)
			elseif not ok then
				error(string.format("module '%s' does not exist, maybe specify a name", cleaned_pkg))
			end

			plugin.loaded_module = module

			local autocmds = plugin.autocmds
			if autocmds and type(autocmds) == "table" then utils.load_autocmds(autocmds, cleaned_pkg) end

			local build = plugin.build

			if build then
				vim.schedule(function()
					local ok, result
					if type(build) == "string" and string.sub(build, 1, 1) == ":" then
						vim.cmd(string.sub(build, 2))
					elseif type(build) == "string" then
						vim.fn.system(build)
					elseif type(build) == "function" then
						build()
					end
				end)
			end
		end
	end
end

local plugin_statuses = {}

for fname, plugin in pairs(plugins) do
	local ok, err = plugin.ok, plugin.err

	local load_time = 0
	if ok then
		local time_now = os.clock()
		ok, err = pcall(load_plugin, fname, plugin.module)
		load_time = os.clock() - time_now
	end

	plugin_statuses[fname] = {
		ok = ok,
		error = err,
		load_time = load_time,
		url = plugin.url,
		updated = false,
		loaded_module = plugin.loaded_module,
	}
end

local failed = vim.tbl_filter(function(s) return not s.ok end, plugin_statuses)
local amount_failed = vim.tbl_count(failed)
if amount_failed > 0 then
	vim.notify(
		string.format("[PLUGINS] %d plugin(s) failed to load. Run :PluginErrors to see details.", amount_failed),
		vim.log.levels.WARN
	)
end

vim.api.nvim_create_user_command("PluginErrors", function()
	local entries = {}
	for name, status in pairs(plugin_statuses) do
		if not status.ok then table.insert(entries, {
			name = name,
			error = status.error,
			text = name,
		}) end
	end

	if #entries == 0 then
		vim.notify("No plugin errors!", vim.log.levels.INFO)
		return
	end

	local ok, snacks = pcall(require, "snacks")

	if not ok then
		for name, status in pairs(plugin_statuses) do
			print(string.format("[P_ERR][%s]: %s", name, status.error))
		end
		return
	end

	snacks.picker.pick({
		title = "Plugin Errors",
		items = entries,
		format = function(item) return { { item.text } } end,
		win = {
			preview = {
				wo = { wrap = true },
			},
		},
		preview = function(ctx)
			ctx.preview:reset()
			ctx.preview:set_title(ctx.item.name or "Error")
			ctx.preview:set_lines(vim.split(ctx.item.error or "", "\n"))
		end,
		confirm = function(picker, item)
			picker:close()
			local lines = vim.split(item.error, "\n")

			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = math.floor(vim.o.columns * 0.8),
				height = math.min(#lines + 2, math.floor(vim.o.lines * 0.8)),
				row = math.floor(vim.o.lines * 0.1),
				col = math.floor(vim.o.columns * 0.1),
				style = "minimal",
				border = "rounded",
				title = string.format(" %s ", item.name),
				title_pos = "center",
			})

			vim.keymap.set("n", "q", "<CMD>close | PluginErrors<CR>", { buffer = buf, silent = true })
			vim.keymap.set("n", "<esc>", "<CMD>close | PluginErrors<CR>", { buffer = buf, silent = true })
		end,
	})
end, {})

vim.api.nvim_create_user_command("PluginInfo", function()
	local entries = {}
	for name, status in pairs(plugin_statuses) do
		table.insert(entries, {
			name = name,
			text = string.format("%s, %.2fms", name, status.load_time),
			status = status,
		})
	end

	table.sort(entries, function(a, b) return not a.status.ok and b.status.ok end)

	require("snacks").picker.pick({
		title = "Plugin Info",
		items = entries,

		format = function(item)
			local icon = item.status.ok and "" or ""

			return {
				{ icon .. " " },
				{ item.text },
			}
		end,

		preview = function(ctx)
			local status = ctx.item.status
			local lines = vim.split(
				string.format(
					"Plugin: %s\n\nStatus: %s\nLoad time: %.2fms",
					ctx.item.name,
					status.ok and "Loaded" or "Failed",
					status.load_time
				),
				"\n"
			)

			if status.error then table.insert(lines, string.format("Error: %s", status.error)) end

			ctx.preview:set_lines(lines)
			ctx.preview:set_title(ctx.item.name)
		end,
	})
end, {})
