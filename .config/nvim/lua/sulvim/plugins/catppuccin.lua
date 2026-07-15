local catppuccin = {
	{ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } },

	config = function(_, opts) vim.cmd.colorscheme("catppuccin-nvim") end,
}

return catppuccin
