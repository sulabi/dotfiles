local trailspace = {
	"nvim-mini/mini.trailspace", version = false,
	opts = {
		only_in_normal_buffers = false
	},

	keys = {
		{ "<leader>tw", function() MiniTrailspace.trim() end, desc = "Trims Whitespace" },
		{ "<leader>tl", function() MiniTrailspace.trim_last_lines() end, desc = "Trims Last Lines" },
	}
}

return trailspace
