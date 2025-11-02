local conform = {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
		formatters = {
			prettier = {
				append_args = { "--use-tabs", "--tab-width", "4" },
			},
			stylua = { append_args = { "--indent-width", "4", "--collapse-simple-statement", "Always", "--quote-style", "AutoPreferDouble" } },
		},
	},

	keys = {
		{
			"<leader>fm",
			function()
				require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
			end,
			"Format file or selection",
		},
	}
}

return conform
