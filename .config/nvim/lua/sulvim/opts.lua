local opts = {}

opts.number = true
opts.relativenumber = true
opts.cursorline = true
opts.wrap = false
opts.scrolloff = 10
opts.sidescrolloff = 8
opts.synmaxcol = 300
opts.updatetime = 300
opts.redrawtime = 10000
opts.maxmempattern = 20000

-- Indentation
opts.tabstop = 4
opts.softtabstop = 4
opts.shiftwidth = 4
opts.smartindent = true
opts.autoindent = true

-- Search settings
opts.ignorecase = true
opts.smartcase = true
opts.incsearch = true

-- Visual settings
opts.termguicolors = true
opts.colorcolumn = "0"
opts.showmatch = true
opts.signcolumn = "yes"
opts.matchtime = 2
opts.cmdheight = 1
opts.completeopt = "menu,menuone,noselect"
opts.conceallevel = 2
opts.confirm = true
opts.concealcursor = ""
opts.ruler = false

-- File handling
opts.backup = false
opts.writebackup = false
opts.swapfile = false
opts.undofile = true
opts.undolevels = 10000
opts.undodir = vim.fn.stdpath("data") .. "/undo"
opts.autoread = true

-- Behaviour settings
opts.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opts.encoding = "UTF-8"

opts.splitbelow = true
opts.splitright = true
opts.splitkeep = "screen"

opts.inccommand = "split"
opts.shortmess = "cF"
opts.list = true
opts.laststatus = 3

-- Create the directory for undo history safely
local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then vim.fn.mkdir(undodir, "p") end

-- Filetype detection rules
vim.filetype.add({
	extension = {
		env = "dotenv",
	},
	filename = {
		[".env"] = "dotenv",
		["env"] = "dotenv",
	},
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc",
		["%.env%.[%w_.-]+"] = "dotenv",
	},
})

return opts
