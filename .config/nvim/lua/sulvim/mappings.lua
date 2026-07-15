local mappings = {}
local opts = { noremap = true, silent = true }

mappings.i = {}
mappings.n = {}
mappings.x = {}
mappings.v = {}
mappings.s = {}

local function map(mode, ...)
	if type(mode) == "table" then
		for _, _mode in pairs(mode) do
			table.insert(mappings[_mode], { ... })
		end
	else
		table.insert(mappings[mode], { ... })
	end
end

map({ "i", "v" }, "jk", "<ESC>", {})

map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

map("n", "<C-S-Up>", "<cmd>resize +5<CR>", opts)
map("n", "<C-S-Down>", "<cmd>resize -5<CR>", opts)
map("n", "<C-S-Left>", "<cmd>vertical resize -5<CR>", opts)
map("n", "<C-S-Right>", "<cmd>vertical resize +5<CR>", opts)

map("n", "<leader>sv", "<C-W>v", { desc = "Split Window Horizontal" })
map("n", "<leader>sh", "<C-W>s", { desc = "Split Window Vertical" })
map("n", "<leader>wq", "<C-W>c", { desc = "Delete Window" })

map("n", "<leader>rss", function()
	vim.cmd("mksession! session.vim")
	vim.cmd("restart source session.vim | call delete('session.vim')")
end, {})

do
	local a = { "<leader>d", [["_d]], { desc = "Delete without yanking" } }
	map("n", unpack(a))
	map("v", unpack(a))
end

map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map("n", "<A-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })

map("n", "<C-c>", ":%y+<CR>", opts)

map("n", "<c-u>", "<c-u>zz", { desc = "Move up in buffer with cursor centered" })
map("n", "<c-d>", "<c-d>zz", { desc = "Move down in buffer with cursor centered" })

map("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle undotree" })

map("v", "p", '"_dP', opts)

map("v", ">", ">gv", { desc = "Indent and keep selection" })
map("v", "<", "<gv", { desc = "Unindent and keep selection" })

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show code diagnostics" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

map("n", "<leader>td", function()
	local current_state = vim.diagnostic.config().virtual_text

	vim.diagnostic.config({
		virtual_text = not current_state,
	})
end, { desc = "Toggle same-line inline diagnostics" })

return mappings
