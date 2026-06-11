--! @file my_utils.lua
--! @brief Module providing generic utilities, buffers management, and external tooling integrations for Neovim.

--! @brief Checks if JetBrainsMono Nerd Font is installed on Windows or macOS. If not, prompts and attempts to install it.
--! @return void
function CheckAndInstallNerdFont()
	local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'
	local is_mac = vim.loop.os_uname().sysname == 'Darwin'
	local found = false

	if is_windows then
		local handle = io.popen('reg query "HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts" /s 2>nul | findstr /i "JetBrainsMono.*Nerd"')
		if handle then
			local result = handle:read('*a')
			handle:close()
			found = result and result ~= ""
		end
	else
		local handle = io.popen('fc-list : family 2>/dev/null | grep -i "JetBrainsMono Nerd"')
		if handle then
			local result = handle:read('*a')
			handle:close()
			found = result and result ~= ""
		end
	end

	if found then
		vim.notify("JetBrainsMono Nerd Font is already installed.", vim.log.levels.INFO)
		return
	end

	local install_cmd
	if is_windows then
		install_cmd = 'winget install DEVCOM.JetBrainsMonoNerdFont --accept-source-agreements --accept-package-agreements'
	elseif is_mac then
		install_cmd = 'brew install --cask font-jetbrains-mono-nerd-font'
	else
		install_cmd = 'echo "Please install JetBrainsMono Nerd Font manually"'
	end
	vim.notify("Installing JetBrainsMono Nerd Font...", vim.log.levels.WARN)
	vim.fn.system(install_cmd)
	if vim.v.shell_error == 0 then
		vim.notify("JetBrainsMono Nerd Font installed successfully. Restart to apply.", vim.log.levels.INFO)
	else
		vim.notify("Failed to install. Run manually:\n" .. install_cmd, vim.log.levels.ERROR)
	end
end

--! @brief Retrieves the paths of all active, valid, and loaded buffer files.
--! @return table A list of active buffer file paths with backslashes replaced by forward slashes.
function GetAllBuffers()
	local buffers = vim.api.nvim_list_bufs()
	local filenames = {}
	for _, buf in ipairs(buffers) do
		-- Only add valid and normal buffers (no buftype)
		if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buftype') == '' and vim.api.nvim_buf_get_name(buf) ~= '' then
			-- file name should convert '\' to '/' in Windows
			local fname = vim.api.nvim_buf_get_name(buf):gsub('\\', '/')
			table.insert(filenames, fname)
		end
	end
	return filenames
end

--! @brief Closes buffers whose files have been deleted on the filesystem.
--! @return void
function CloseDeletedBuffers()
	local buffers = vim.api.nvim_list_bufs()
	local closed_count = 0
	for _, buf in ipairs(buffers) do
		if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') then
			local filename = vim.api.nvim_buf_get_name(buf)
			if filename ~= "" and vim.fn.filereadable(filename) == 0 then
				-- Check if it's a special buffer (like term://, fugitive://) which might not appear 'readable' on disk
				-- Simple check: if it looks like a path and doesn't exist.
				-- Use buftype check
				if vim.api.nvim_buf_get_option(buf, 'buftype') == "" then
					print("Closing deleted buffer: " .. filename)
					vim.api.nvim_buf_delete(buf, { force = false }) -- Safe delete by default
					closed_count = closed_count + 1
				end
			end
		end
	end
	print("Closed " .. closed_count .. " deleted buffers.")
end

--! @brief Deletes temporary Neovim ShaDa files from the Neovim data path.
--! @return void
function CleanShadaTmpFiles()
	local shada_path = vim.fn.stdpath('data') .. '/shada'
	local files = vim.fn.glob(shada_path .. '/main.shada.tmp.*', false, true)
	local deleted_count = 0
	for _, file in ipairs(files) do
		os.remove(file)
		deleted_count = deleted_count + 1
	end
	print("Deleted " .. deleted_count .. " temporary shada files from " .. shada_path)
end

--! @brief Copies the absolute path of the current buffer to the system clipboard (+ register).
--! @return void
function CopyAbsolutePath()
	local filename = vim.fn.expand('%:p')
	vim.fn.setreg('+', filename)
end

--! @brief Shows key bindings in a Telescope selector loaded from keybindings.json.
--! @return void
function ShowKeyBindings()
	local keybindings_json = vim_home_path .. 'keybindings.json'
	local f = io.open(keybindings_json, "r")
	if f then
		local content = f:read('*a')
		f:close()
		local ok, data = pcall(vim.json.decode, content)
		if ok and data and data.keybindings then
			vim.ui.select(data.keybindings, { prompt = "Key Bindings" }, function(_) end)
		else
			vim.notify("Failed to parse keybindings.json", vim.log.levels.ERROR)
		end
	else
		vim.notify("Keybindings file not found: " .. keybindings_json, vim.log.levels.ERROR)
	end
end

--! @brief Reads and displays helpful tips stored in the tips.json file.
--! @return void
function ShowTips()
	-- read a json file
	local tips_json = vim_home_path .. 'tips.json'
	local f = io.open(tips_json, "r")
	if f then
		local content = f:read('*a')
		f:close()
		local ok, data = pcall(vim.json.decode, content)
		if ok and data and data.tips then
			vim.ui.select(data.tips, { prompt = "Tips" }, function(_) end)
		end
	else
		print("Tips file not found: " .. tips_json)
	end
end

--! @brief Prompts the user to customize the root path, changes the current directory, and opens telescope file browser.
--! @param file_path string The default root directory path.
--! @return void
function FileBrowser(file_path)
	vim.ui.input({
		prompt = 'Enter root path',
		default = file_path,
	}, function(root)
		if root then
			vim.cmd('cd ' .. root)
			vim.cmd('Telescope file_browser')
		end
	end)
end

--! @brief Prompts the user for a commit message and runs git commit command.
--! @param filename string Unused argument representing the file context.
--! @return void
function GitCommit(filename)
	vim.ui.input({ prompt = 'Git Commit Msg: ', default = "" }, function(input)
		if input then
			vim.cmd('!git commit -m \"' .. input .. '\"')
		end
	end)
end

--! @brief Opens the Telescope bookmarks list interface.
--! @return void
function bmlist()
	vim.cmd(':Telescope bookmarks list')
end

--! @brief Selects another open buffer and launches Neovim (or Neovide if available) in diff mode in a new Windows shell window.
--! @return void
function DiffWithBuffer()
	local buffers = GetAllBuffers()
	local current_file = vim.fn.expand('%:p'):gsub('\\', '/')
	
	vim.ui.select(buffers, {
		prompt = 'Select buffer to diff with:',
	}, function(selected_file)
		if selected_file then
			if current_file == "" or selected_file == "" then
				print("Cannot diff: one of the buffers has no file path.")
				return
			end
			
			local cmd = "nvim"
			local args = "-d"
			
			if vim.fn.executable("neovide") == 1 then
				cmd = "neovide"
				args = "-- -O -d"
			end
			
			local exec_cmd = string.format('cmd /c start "Diff" %s %s "%s" "%s"', cmd, args, current_file, selected_file)
			print("Executing: " .. exec_cmd)
			os.execute(exec_cmd)
		end
	end)
end
