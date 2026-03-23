local utils = require(main .. ".utils")

local lazy = utils.relative_require("plugins.lazy")

local parent_folder = utils.get_parent_folder()
local plugins = utils.load_modules(parent_folder, ".*/(.*).lua", { "init", "lazy" })

require("lazy").setup(plugins)			




