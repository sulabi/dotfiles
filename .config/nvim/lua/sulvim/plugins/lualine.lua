local lualine = {
	{ "nvim-lualine/lualine.nvim" },

	opts = {
		theme = "pywal",
		sections = {
			lualine_x = { "overseer" },
		},
		globalstatus = true
	},
}

return lualine
