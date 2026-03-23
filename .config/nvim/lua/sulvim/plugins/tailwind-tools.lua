local tools = {
	-- "luckasRanarison/tailwind-tools.nvim",
	"garrett-hopper/tailwind-tools.nvim", -- fix for lsp break
	branch = "vim-lsp-api",
	name = "tailwind-tools",
	build = ":UpdateRemotePlugins",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {}, -- your configuration
}

return tools
