local treesitter = {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",

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

	config = function(_, opts)
		return require("nvim-treesitter.configs").setup(opts)
	end
}

return treesitter
