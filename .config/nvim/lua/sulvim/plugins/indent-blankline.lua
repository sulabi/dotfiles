local indent_blackline = {
	{ "lukas-reineke/indent-blankline.nvim" },

	config = function()
		require("ibl").setup({})
	end
}

return indent_blackline
