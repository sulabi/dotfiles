local utils = require(main .. ".utils")

local mappings = utils.relative_require("mappings")
utils.load_mappings(mappings)

local opts = utils.relative_require("opts")
utils.write_t(vim.opt, opts)

local globals = utils.relative_require("globals")
utils.write_t(vim.g, globals)

local commands = utils.relative_require("commands")
utils.load_commands(commands)
    vim.opt_local.syntax = "off"
    vim.opt_local.indentexpr = ""
    vim.opt_local.foldmethod = "manual"
utils.relative_require("plugins")

local argv = vim.fn.argv()
local isdirectory = vim.fn.isdirectory(argv[1]) == 1

if vim.fn.argc(-1) == 0 or isdirectory then
	if isdirectory then
		vim.cmd("cd " .. argv[1])
	end
end
