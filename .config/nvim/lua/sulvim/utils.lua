utils = {};

utils.get_home = function()
    return string.match(debug.getinfo(2, "S").source, "(/%w+/%w+/)")
end

utils.get_file = function(l)
	return string.sub(debug.getinfo(l or 2, "S").source, 2);
end

utils.get_parent = function(file_path)
	return string.match(file_path, "(.*/)");
end

local current_file = utils.get_file();
local parent_folder = utils.get_parent(current_file);
local folder_name = string.match(parent_folder, "(%w*)/$");

utils.get_parent_folder = function(l)
	local file = utils.get_file(l or 3);
	local parent = utils.get_parent(file);
	return parent;
end

utils.relative_require = function(relative_module, l)
	local p_folder = utils.get_parent_folder(l);
	local relative_path = string.match(p_folder, string.format("%s/(.*)", folder_name));
	local module = string.format("%s.%s", folder_name, string.gsub(relative_path, "/", ".") .. relative_module);
	return require(module);
end

utils.get_files = function(folder)
	if (string.sub(folder, #folder) ~= "/") then
		folder = folder .. "/"
	end

	return vim.split(vim.fn.glob(folder .. "*"), "\n");
end

local keymap_set = vim.keymap.set
utils.load_mappings = function(mappings, additions)
    for mode, maps in pairs(mappings) do
        for i, map in pairs(maps) do
            for i2, v2 in pairs(additions or {}) do
                map[i2] = v2
            end
            keymap_set(mode, unpack(map));
        end
    end
end

local linear_search = function(t, v)
    for i, v2 in pairs(t) do
        if (v == v2) then
            return i;
        end
    end
    return nil;
end

utils.load_modules = function(folder, matcher, blacklist, file_keynames)
    local modules = {};
    local module_files = utils.get_files(folder);
    local folder_name = string.match(folder, "(%w*)/$");

    for i, module_file in pairs(module_files) do
        local file_name = string.match(module_file, matcher);
        if (file_name and linear_search(blacklist, file_name) == nil) then
            local module = utils.relative_require(string.format("%s.%s", folder_name, file_name), 4);
			modules[file_keynames and file_name or #modules + 1] = module
        end
    end

    return modules;
end

utils.write_t = function(t1, t2, no_overwrite)
    for i, v in pairs(t2) do
        if (not (no_overwrite and t1[i])) then
            t1[i] = v
        end
    end
end

utils.load_commands = function(commands)
	for i, command in pairs(commands) do
		vim.api.nvim_create_user_command(unpack(command))
	end
end

utils.ends_with = function(string, suffix)
	return string.sub(string, -#suffix) == suffix
end

return utils;
