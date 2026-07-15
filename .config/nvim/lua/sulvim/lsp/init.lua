local utils = require(main .. ".utils")

local parent_folder = utils.get_parent_folder()
local modules = utils.load_modules(parent_folder, ".*/(.*).lua", { "init" }, true)

local lsp_statuses = {}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

for fname, module in pairs(modules) do
	local ok, err = module.ok, module.err

	local config = module.module

	local load_time = 0
	if ok then
		local time_now = os.clock()
		ok, err = pcall(function()
			config.config.capabilities = capabilities
			vim.lsp.config(config.name, config.config)
			vim.lsp.enable(config.name)
		end)
		load_time = os.clock() - time_now
	end

	lsp_statuses[fname] = {
		ok = ok,
		error = err,
		load_time = load_time,
		module = config,
	}
end

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,

	float = {
		border = "rounded",
	},
})

return lsp_statuses
