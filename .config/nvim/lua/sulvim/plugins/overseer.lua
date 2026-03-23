local tasks = {
	{
		name = "Build FA",
		builder = function()
			return {
				cwd = "fates_builder",
				cmd = { "./target/release/buildfa", "--build", "--get-types" },
				components = { "default" },
			}
		end,
	},

	{
		name = "Build FA (copy)",
		builder = function()
			return {
				cwd = "fates_builder",
				cmd = { "./target/release/buildfa", "--build", "--get-types", "--copy" },
				components = { "default" },
			}
		end,
	},
}

local overseer = {
	"stevearc/overseer.nvim",
	opts = {
		strategy = "toggleterm",
	},

	keys = {
		{ "<leader>ot", "<cmd>OverseerRun<CR>", "Run Overseer Tasks" },
		{ "<leader>ol", "<cmd>OverseerRestartLast<CR>", "Restart Overseer Task" },
	},

	config = function(_, opts)
		local overseer = require("overseer")

		for _, task in pairs(tasks) do
			overseer.register_template(task)
		end

		vim.api.nvim_create_user_command("OverseerRestartLast", function()
			local recent_tasks = overseer.list_tasks({ recent_first = true })
			if vim.tbl_isempty(recent_tasks) then
				vim.notify("No tasks found", vim.log.levels.WARN)
			else
				overseer.run_action(recent_tasks[1], "restart")
			end
		end, {})

		return overseer.setup(opts)
	end,
}

return overseer
