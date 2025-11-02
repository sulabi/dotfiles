local todo = {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},

	keys = {
		{ "<leader>tc", function() Snacks.picker.todo_comments() end, { desc = "All Comments" } },
		{ "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" } },
		{ "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" } },
	},
}

return todo
