--! @file my_config.lua
--! @brief Module for loading and repairing Neovim configurations.

-- Global paths used across configuration files
path_spliter = '\\'
if not (vim.loop.os_uname().sysname == 'Windows_NT') then
	path_spliter = '/'
end

config_file_path = vim.fn.expand('$HOME') .. path_spliter .. '.config' .. path_spliter .. 'nvim' .. path_spliter
config_file = config_file_path .. 'project_config.json'

--! @brief Repairs the project_config.json file by merging missing default configuration keys.
--! @return void
function RepairConfigJson()
	local default_config = {
		Tag_reason      = "new feature",
		Tag_type        = "feature",
		User_name       = "user name",
		Clang_Index     = "",
		avante_provider = "copilot",
		avante_model    = "",
		tag_head        = "NONE",
		suggestion_key  = "",
		ollama_model    = ""
	}
	if vim.fn.isdirectory(config_file_path) == 0 then
		vim.fn.mkdir(config_file_path)
	end
	local existing = {}
	if vim.fn.filereadable(config_file) == 1 then
		local content = io.open(config_file, "r"):read('*a')
		local ok, parsed = pcall(vim.json.decode, content)
		if ok and parsed then
			existing = parsed
		end
	end
	-- merge: keep existing values, add missing keys from default
	for k, v in pairs(default_config) do
		if existing[k] == nil then
			existing[k] = v
		end
	end
	existing.suggestion_provider = nil
	local f = io.open(config_file, "w")
	if f then
		f:write(vim.fn.json_encode(existing))
		f:close()
	end
	print("Config repaired: " .. config_file)
	vim.cmd('edit ' .. config_file)
end

--! @brief Loads the project configuration from project_config.json. If it does not exist, a default is created.
--! @return table The loaded configuration table containing Tag_reason, Tag_type, User_name, Clang_Index, tag_head, avante_provider, suggestion_key, ollama_model.
function load_config()
	local Tag_reason      = ""
	local Tag_type        = ""
	local User_name       = ""
	local avante_provider = ""
	local avante_model    = ""
	local Tag_head        = "NONE"
	local suggestion_key  = ""
	local ollama_model    = ""
	if vim.loop.os_uname().sysname == 'Windows_NT' then
		-- detect and create config file
		if vim.fn.isdirectory(config_file_path) == 0 then
			vim.fn.mkdir(config_file_path)
		end
		if vim.fn.filereadable(config_file) == 0 then
			local default_config = {
				Tag_reason      = "new feature",
				Tag_type        = "feature",
				User_name       = "usere name",
				Clang_Index     = "",
				avante_provider = "copilot",
				avante_model    = "",
				tag_head        = "NONE",
				suggestion_key  = "",
				ollama_model    = ""
			}
			local f = io.open(config_file, "w")
			if f then
				f:write(vim.fn.json_encode(default_config))
				f:close()
			end
		end
		local f = io.open(config_file, "r")
		if f then
			local content = f:read('*a')
			f:close()
			local ok, project_config = pcall(vim.json.decode, content)
			if ok and project_config then
				Tag_reason      = project_config.Tag_reason
				Tag_type        = project_config.Tag_type
				User_name       = project_config.User_name
				Clang_Index     = project_config.Clang_Index
				avante_provider = project_config.avante_provider
				avante_model    = project_config.avante_model or ""
				Tag_head        = project_config.tag_head
				suggestion_key  = project_config.suggestion_key or ""
				ollama_model    = project_config.ollama_model or ""
			end
		end
	end
	return {
		Tag_reason      = Tag_reason,
		Tag_type        = Tag_type,
		User_name       = User_name,
		Clang_Index     = Clang_Index,
		tag_head        = Tag_head,
		avante_provider = avante_provider,
		avante_model    = avante_model,
		suggestion_key  = suggestion_key,
		ollama_model    = ollama_model
	}
end
