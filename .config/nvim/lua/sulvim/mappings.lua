local mappings = {}

mappings.i = {}
mappings.n = {}
mappings.t = {}

table.insert(mappings.i, { "jk", "<ESC>", {} })
table.insert(mappings.t, { "JK", "<C-\\><C-n>", {} })
table.insert(mappings.t, { "<A-'>", "<cmd>ToggleTerm<CR>", {} })

return mappings
