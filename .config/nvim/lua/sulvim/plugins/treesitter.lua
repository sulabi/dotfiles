local treesitter = {
	{ { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "master" } },
	-- build = ":TSUpdate",

	opts = {
		ensure_installed = {
			"regex",
			"vim",
			"html",
			"css",
			"javascript",
			"json",
			"toml",
			"markdown",
			"c",
			"bash",
			"lua",
			"luau",
			"luau",
			"tsx",
			"typescript",
			"dockerfile",
		},

		sync_install = true,
		auto_install = true,

		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},

		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				scope_incremental = "<C-space>",
			},
		},
		additional_vim_regex_highlighting = false,
	},

	config = function(Treesitter, opts)
		Treesitter.install(opts.ensure_installed)
		Treesitter.setup(opts)
	end,

	autocmds = {
		{
			event = "FileType",
			pattern = { "<filetype>" },
			callback = function(args) vim.treesitter.start() end,
		},
	},
}

return treesitter
