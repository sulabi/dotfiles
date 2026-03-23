local commands = {}

table.insert(commands, { "ReloadConfig", function()
	print("reloading nvim")

	print("reloaded")
end, {} })

return commands
