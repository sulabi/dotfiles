local function rojo_project()
  return vim.fs.root(0, function(name)
    return name:match(".+%.project%.json$")
  end)
end

local is_rojo = rojo_project() ~= nil

return {
	"lopi-py/luau-lsp.nvim",

	dependencies = {"nvim-lua/plenary.nvim"},

	opts = {
		platform = {
			type = "roblox"
		},

		sourcemap = {
			enabled = is_rojo,
			autogenerate = is_rojo,
			rojo_project_file = "default.project.json",
			sourcemap_file = "sourcemap.json",
		},

		completion = {
			imports = {
				enabled = true,
			}
		},

		fflags = {
			-- enable_new_solver = true,
			-- sync = true
		}
	},

	config = function(_, opts)
		local definition_files = vim.fn.glob("src/*.d.luau", true, true)

		opts.types = {
			definition_files = definition_files
		}

		return require("luau-lsp").setup(opts)
	end
}
