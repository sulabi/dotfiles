local utils = require(main .. ".utils")

local globals = utils.relative_require("globals", nil, true)
utils.write_t(vim.g, globals)

local mappings = utils.relative_require("mappings", nil, true)
utils.load_mappings(mappings)

local opts = utils.relative_require("opts", nil, true)
utils.write_t(vim.opt, opts)

utils.relative_require("plugins")
utils.relative_require("autocmds")
utils.relative_require("lsp")

local argv = vim.fn.argv()
if vim.fn.argc(-1) == 1 and vim.fn.isdirectory(argv[1]) == 1 then vim.cmd.cd(argv[1]) end

require("vim._core.ui2").enable()

-- todo:
-- everything is modular so the viewer can access everything -> return more info from each plugin / conf
-- maybe lazyload some plugins as idk whats up with vim.pack
-- finish autocmds
-- polish plugn handler
