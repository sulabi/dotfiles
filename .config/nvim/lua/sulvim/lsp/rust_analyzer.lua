local rust_analyzer = {
	name = "rust_analyzer",
	config = {
		root_markers = {
			"Cargo.toml",
			"rust-project.json",
			".git",
		},
		settings = {
			["rust-analyzer"] = {
				cargo = {
					allFeatures = true,
				},
				checkOnSave = {
					command = "clippy",
				},
				procMacro = {
					enable = true,
				},
			},
		},
	},
}

return rust_analyzer
