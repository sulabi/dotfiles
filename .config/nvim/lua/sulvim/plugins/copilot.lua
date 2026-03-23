return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			debug = false, -- Enable debugging
			-- See Configuration section for rest
		},
		keys = {
			-- Quick chat with Copilot
			{
				"<leader>ccq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
					end
				end,
				desc = "CopilotChat - Quick chat",
			},
			-- Open chat window
			{
				"<leader>ccc",
				function() require("CopilotChat").open() end,
				desc = "CopilotChat - Open chat",
				mode = { "n", "v" },
			},
			-- Close chat window
			{
				"<leader>ccx",
				function() require("CopilotChat").close() end,
				desc = "CopilotChat - Close chat",
			},
			-- Reset chat
			{
				"<leader>ccr",
				function() require("CopilotChat").reset() end,
				desc = "CopilotChat - Reset chat",
			},
			-- Ask about selection
			{
				"<leader>cce",
				function()
					local input = vim.fn.input("Ask Copilot: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
					end
				end,
				desc = "CopilotChat - Explain selection",
				mode = "v",
			},
			-- Ask about current buffer
			{
				"<leader>ccb",
				function()
					local input = vim.fn.input("Ask about buffer: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
					end
				end,
				desc = "CopilotChat - Ask about buffer",
			},
			-- Predefined prompts
			{
				"<leader>ccp",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
				end,
				desc = "CopilotChat - Prompt actions",
				mode = { "n", "v" },
			},
			-- Code related commands
			{
				"<leader>ccd",
				function() require("CopilotChat").ask("/Explain", { selection = require("CopilotChat.select").visual }) end,
				desc = "CopilotChat - Explain code",
				mode = "v",
			},
			{
				"<leader>ccf",
				function() require("CopilotChat").ask("/Fix", { selection = require("CopilotChat.select").visual }) end,
				desc = "CopilotChat - Fix code",

				mode = "v",
			},
			{
				"<leader>cco",
				function()
					require("CopilotChat").ask("/Optimize", { selection = require("CopilotChat.select").visual })
				end,
				desc = "CopilotChat - Optimize code",
				mode = "v",
			},
			{
				"<leader>cct",
				function() require("CopilotChat").ask("/Tests", { selection = require("CopilotChat.select").visual }) end,
				desc = "CopilotChat - Generate tests",
				mode = "v",
			},
			-- Inline chat
			{
				"<leader>cci",
				function()
					local input = vim.fn.input("Inline Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, {
							selection = require("CopilotChat.select").visual,
							window = {
								layout = "float",
								relative = "cursor",
								width = 1,
								height = 0.4,
								row = 1,
							},
						})
					end
				end,
				desc = "CopilotChat - Inline chat",
				mode = { "n", "v" },
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")

			-- Custom configuration
			opts.prompts = {
				Explain = {
					prompt = "/COPILOT_EXPLAIN Write an explanation for the selected code as paragraphs of text.",
				},
				Review = {
					prompt = "/COPILOT_REVIEW Review the selected code.",
					callback = function(response, source)
						-- Custom callback for review
					end,
				},
				Fix = {
					prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
				},
				Optimize = {
					prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
				},
				Docs = {
					prompt = "/COPILOT_GENERATE Please add documentation comments to the selected code.",
				},
				Tests = {
					prompt = "/COPILOT_GENERATE Please generate tests for my code.",
				},
				FixDiagnostic = {
					prompt = "Please assist with the following diagnostic issue in file:",
					selection = select.diagnostics,
				},
				Commit = {
					prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
					selection = select.gitdiff,
				},
				CommitStaged = {
					prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
					selection = function(source) return select.gitdiff(source, true) end,
				},
			}

			opts.window = {
				layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
				width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
				height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
				-- Options below only apply to floating windows
				relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
				border = "rounded", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
				row = nil, -- row position of the window, default is centered
				col = nil, -- column position of the window, default is centered
				title = "Copilot Chat", -- title of chat window
				footer = nil, -- footer of chat window
				zindex = 1, -- determines if window is on top or below other floating windows
			}

			chat.setup(opts)

			-- Auto-show chat on insert enter (optional)
			-- vim.api.nvim_create_autocmd("InsertEnter", {
			--   callback = function()
			--     if vim.bo.filetype == "copilot-chat" then
			--       vim.cmd("startinsert")
			--     end
			--   end,
			-- })
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		enabled = not not vim.g.ai_cmp,
		opts = {
			suggestion = {
				enabled = not not vim.g.ai_cmp,
				auto_trigger = true,
				hide_during_completion = not vim.g.ai_cmp,
				keymap = {
					accept = false, -- handled by nvim-cmp / blink.cmp
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
		keys = {
			{
				"<leader>ct",
				function()
					local copilot_status = require("copilot.client").is_disabled()
					if copilot_status then
						require("copilot.command").enable()
						vim.notify("Copilot enabled", vim.log.levels.INFO)
					else
						require("copilot.command").disable()
						vim.notify("Copilot disabled", vim.log.levels.WARN)
					end
				end,
				desc = "Toggle Copilot",
			},
			{
				"<leader>cs",
				function()
					local status = require("copilot.client").is_disabled() and "disabled" or "enabled"
					vim.notify("Copilot is " .. tostring(vim.g.ai_cmp) .. status, vim.log.levels.INFO)
				end,
				desc = "Copilot Status",
			},
		},
	},
}
