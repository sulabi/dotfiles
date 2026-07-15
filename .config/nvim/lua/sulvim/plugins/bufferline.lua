local bufferline = {
	{ "https://github.com/akinsho/bufferline.nvim" },

	opts = {
		options = {
			always_show_bufferline = true,
			custom_filter = function() return true end,
		},
	},
}

return bufferline
