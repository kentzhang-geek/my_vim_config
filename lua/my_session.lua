--! @file my_session.lua
--! @brief Module for managing Neovim session saving, loading, and menu actions.

--! @brief Variable holding the name of the last active or loaded session.
session_name = ""

--! @brief Prompts the user to save the current Neovim session.
--! @return void
function SaveSession()
	vim.ui.input({ prompt = 'Enter session name: ', default = session_name }, function(input)
		if input then
			session_name = input
			vim.cmd('mksession! ' .. sessions_path .. path_spliter .. input)
		end
	end)
end

--! @brief Prompts the user to select and load a saved Neovim session, then forces loading all buffers for blink.cmp indexing.
--! @return void
function LoadSession()
	-- Got file list under sessions_path, output a list
	local files = {}
	local handle = io.popen('dir /b /a-d ' .. sessions_path)
	if handle then
		for file in handle:lines() do
			table.insert(files, file)
		end
		handle:close()
	end
	
	vim.ui.select(files, {
		prompt = 'select a session to load',
	}, function(sel)
		if sel then
			session_name = sel
			vim.cmd('source ' .. sessions_path .. path_spliter .. sel)
			-- Force load all buffers to ensure they are indexed by blink.cmp
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) and not vim.api.nvim_buf_is_loaded(buf) then
					vim.fn.bufload(buf)
				end
			end
		end
	end)
end

--! @brief Shows the session tools menu allowing the user to save, load, or browse session files in file explorer.
--! @return void
function SessionMenu()
	vim.ui.select({ 
		'save',
		'load',
		'show session files'
	}, {
		prompt = 'session tools',
	}, function(sel)
		if sel == 'save' then
			SaveSession()
		elseif sel == 'load' then
			LoadSession()
		elseif sel == 'show session files' then
			os.execute('explorer \"' .. sessions_path .. '\"')
		end
	end)
end
