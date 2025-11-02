local bufferline = {
	"akinsho/bufferline.nvim", version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",

	opts = {
		options = {
			always_show_bufferline = true,
			custom_filter = function() return true end
		}
	}
}

return bufferline
