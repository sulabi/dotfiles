local minifiles = {
	{ "nvim-mini/mini.files" },
	opts = {

		windows = {
			preview = true,
			width_focus = 30,
			width_preview = 30,
		},
		options = {
			-- Whether to use for editing directories
			-- Disabled by default in LazyVim because neo-tree is used for that
			permanent_delete = false,
			use_as_default_explorer = false,
		},
	},
	keys = {
		{
			"<leader>n",
			function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end,
			desc = "Open mini.files (Directory of Current File)",
		},
		{
			"<leader>N",
			function() require("mini.files").open(vim.uv.cwd(), true) end,
			desc = "Open mini.files (cwd)",
		},
	},
	config = function(_, opts) require("mini.files").setup(opts) end,
	autocmds = {},
}

local show_dotfiles = true
local filter_show = function(fs_entry) return true end
local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end

local toggle_dotfiles = function()
	show_dotfiles = not show_dotfiles
	local new_filter = show_dotfiles and filter_show or filter_hide
	require("mini.files").refresh({ content = { filter = new_filter } })
end

local map_split = function(buf_id, lhs, direction, close_on_file)
	local rhs = function()
		local new_target_window
		local cur_target_window = require("mini.files").get_explorer_state().target_window
		if cur_target_window ~= nil then
			vim.api.nvim_win_call(cur_target_window, function()
				vim.cmd("belowright " .. direction .. " split")
				new_target_window = vim.api.nvim_get_current_win()
			end)

			require("mini.files").set_target_window(new_target_window)
			require("mini.files").go_in({ close_on_file = close_on_file })
		end
	end

	local desc = "Open in " .. direction .. " split"
	if close_on_file then desc = desc .. " and close" end
	vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

local files_set_cwd = function()
	local cur_entry_path = MiniFiles.get_fs_entry().path
	local cur_directory = vim.fs.dirname(cur_entry_path)
	if cur_directory ~= nil then vim.fn.chdir(cur_directory) end
end

table.insert(minifiles.autocmds, {
	event = "User",

	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local buf_id = args.data.buf_id

		vim.keymap.set(
			"n",
			"g.",
			toggle_dotfiles,
			{ buffer = buf_id, desc = "Toggle hidden files" }
		)

		vim.keymap.set(
			"n",
			"gc",
			files_set_cwd,
			{ buffer = args.data.buf_id, desc = "Set cwd" }
		)
	end,
})

table.insert(minifiles.autocmds, {
	event = "User",
	pattern = "MiniFilesActionRename",
	callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
})

table.insert(minifiles.autocmds, {
	event = "User",
	pattern = { "MiniFilesActionCreate", "MiniFilesActionDelete" },
	callback = function()
		if MiniFiles.get_explorer_state() then MiniFiles.refresh() end
	end,
})
table.insert(
	minifiles.autocmds,
	{ event = "FileType", pattern = "mini.files", callback = function() vim.opt_local.buflisted = false end }
)

return minifiles
