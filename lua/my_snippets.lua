--! @file my_snippets.lua
--! @brief Module for managing custom input snippets for the Avante plugin, including addition, deletion, and menus.

--! @brief Formats a Lua table into a pretty printed JSON string.
--! @param tbl table The table to format.
--! @return string The pretty printed JSON.
local function PrettyPrintJson(tbl)
	local lines = {}
	table.insert(lines, "{")
	local first_key = true
	local sorted_keys = {}
	for k, _ in pairs(tbl) do
		table.insert(sorted_keys, k)
	end
	table.sort(sorted_keys)
	for _, key in ipairs(sorted_keys) do
		local val = tbl[key]
		if not first_key then
			lines[#lines] = lines[#lines] .. ","
		end
		first_key = false
		table.insert(lines, string.format("\t%q: {", key))
		table.insert(lines, string.format("\t\t%q: %q,", "prefix", val.prefix or ""))
		local body_lines = {}
		local raw_body = val.body or { "" }
		if type(raw_body) == "string" then
			raw_body = { raw_body }
		end
		for _, b_line in ipairs(raw_body) do
			table.insert(body_lines, string.format("\t\t\t%q", b_line))
		end
		table.insert(lines, string.format("\t\t%q: [", "body"))
		if #body_lines > 0 then
			table.insert(lines, table.concat(body_lines, ",\n"))
		else
			table.insert(lines, "\t\t\t\"\"")
		end
		table.insert(lines, string.format("\t\t],"))
		table.insert(lines, string.format("\t\t%q: %q", "description", val.description or ""))
		table.insert(lines, "\t}")
	end
	table.insert(lines, "}")
	return table.concat(lines, "\n")
end

--! @brief Opens the Avante input snippets file and ensures it exists.
--! @return string The path to the AvanteInput.json file.
local function EnsureSnippetsFile()
	local s_dir = vim.fn.stdpath('config') .. path_spliter .. 'snippets'
	local s_file = s_dir .. path_spliter .. 'AvanteInput.json'
	if vim.fn.isdirectory(s_dir) == 0 then
		vim.fn.mkdir(s_dir, "p")
	end
	if vim.fn.filereadable(s_file) == 0 then
		local f = io.open(s_file, "w")
		if f then
			f:write("{}")
			f:close()
		end
	end
	return s_file
end

--! @brief Reads and decodes the snippets JSON file.
--! @param file_path string The path to the json file.
--! @return table The decoded JSON table.
local function ReadSnippets(file_path)
	local f = io.open(file_path, "r")
	if not f then return {} end
	local content = f:read("*a")
	f:close()
	if content == "" or content == "{}" then return {} end
	local ok, decoded = pcall(vim.json.decode, content)
	if ok and decoded then
		return decoded
	else
		return {}
	end
end

--! @brief Encodes and writes the snippets table back to the JSON file.
--! @param file_path string The path to the json file.
--! @param data table The snippets table to write.
--! @return void
local function WriteSnippets(file_path, data)
	local f = io.open(file_path, "w")
	if f then
		f:write(PrettyPrintJson(data))
		f:close()
	end
end

--! @brief Prompts user to add a new empty snippet template to AvanteInput.json.
--! @return void
function AddAvanteSnippet()
	local s_file = EnsureSnippetsFile()
	vim.ui.input({ prompt = 'Enter snippet name (e.g. Code Summary): ' }, function(name)
		if not name or name:match("^%s*$") then return end
		local data = ReadSnippets(s_file)
		if data[name] then
			print("Snippet '" .. name .. "' already exists!")
			return
		end
		data[name] = {
			prefix = "",
			body = { "" },
			description = ""
		}
		WriteSnippets(s_file, data)
		vim.cmd('edit ' .. s_file)
		vim.fn.search(name)
	end)
end

--! @brief Prompts user to select and delete a snippet from AvanteInput.json.
--! @return void
function DeleteAvanteSnippet()
	local s_file = EnsureSnippetsFile()
	local data = ReadSnippets(s_file)
	local keys = {}
	for k, _ in pairs(data) do
		table.insert(keys, k)
	end
	if #keys == 0 then
		print("No snippets found to delete.")
		return
	end
	table.sort(keys)
	vim.ui.select(keys, {
		prompt = 'Select snippet to delete: ',
	}, function(sel)
		if sel then
			data[sel] = nil
			WriteSnippets(s_file, data)
			print("Snippet '" .. sel .. "' deleted successfully.")
		end
	end)
end

--! @brief Shows the snippets management menu.
--! @return void
function AvanteSnippetMenu()
	local s_file = EnsureSnippetsFile()
	vim.ui.select({
		'add snippet',
		'delete snippet',
		'edit snippets file'
	}, {
		prompt = 'Avante Snippets Manager',
	}, function(sel)
		if sel == 'add snippet' then
			AddAvanteSnippet()
		elseif sel == 'delete snippet' then
			DeleteAvanteSnippet()
		elseif sel == 'edit snippets file' then
			vim.cmd('edit ' .. s_file)
		end
	end)
end
