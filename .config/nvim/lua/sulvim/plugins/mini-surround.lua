local mini_surround = {
	{ "https://github.com/nvim-mini/mini.surround" },

	opts = {
		mappings = {
			add = "sa",
			delete = "sd",
			find = "sf",
			find_left = "sF",
			highlight = "sh",
			replace = "sr",

			suffix_last = "l",
			suffix_next = "n",
		},
	},
}

return mini_surround
