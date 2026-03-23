local conform = {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			luau = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			javascript = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettier" },
			jsonc = { "prettier" },
		},
		formatters = {
			prettier = {
				append_args = { "--use-tabs", "--tab-width", "4" },
			},
			stylua = {
				append_args = {
					"--indent-width",
					"4",
					"--collapse-simple-statement",
					"Always",
					"--quote-style",
					"AutoPreferDouble",
				},
			},
		},
	},

	keys = {
		{
			"<leader>fm",
			function()
				local conform = require("conform")
				local mode = vim.fn.mode()

				if mode == "v" or mode == "V" or mode == "\22" then
					local start_pos = vim.fn.getpos("'<")
					local end_pos = vim.fn.getpos("'>")

					conform.format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 1000,
						range = {
							start = { start_pos[2], start_pos[3] },
							["end"] = { end_pos[2], end_pos[3] },
						},
					})
				else
					conform.format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 1000,
					})
				end
			end,
			mode = { "n", "v" },
			desc = "Format file or selection",
		},
	},
}

return conform
