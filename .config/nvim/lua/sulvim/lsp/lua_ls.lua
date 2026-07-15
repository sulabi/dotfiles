local lua_ls = {
	name = "lua_ls",
	enabled = true,
	config = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = {
			".luarc.json",
			".luarc.jsonc",
			".luacheckrc",

			".stylua.toml",
			"stylua.toml",
			"selene.toml",

			"selene.yml",
			".git",
		},
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				completion = {
					callSnippet = "Replace",
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						vim.fn.expand("$VIMRUNTIME/lua"),
						vim.fn.stdpath("config") .. "/lua",
					},
				},
			},
		},
	},
}

return lua_ls
