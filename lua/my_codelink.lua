--! @file my_codelink.lua
--! @brief Module implementing codelink:// custom protocol generation, parsing, and navigation.

--! @brief Formats a file path and line number into a codelink URI string.
--! @param filename string The absolute file path.
--! @param lnum number The line number.
--! @return string The formatted codelink URI.
function newCodeLinkByFileLnum(filename, lnum)
	local lk = 'codelink://' .. filename .. ':' .. lnum
	return lk
end

--! @brief Parses a codelink URI and opens the target file at the specified line number.
--! @param link string The codelink URI.
--! @return void
function JumpToFileAndLine(link)
	-- Removing the 'codelink://' prefix and splitting the string by ':'
	local path_and_line = string.sub(link, 12)
	local split_result = {}
	
	-- Split the path and line number by the last colon
	for match in (path_and_line..":"):gmatch("(.-)"..":") do
		table.insert(split_result, match)
	end

	local file_path = table.concat(split_result, ":", 1, #split_result - 1)
	local line_number = tonumber(split_result[#split_result])

	-- Using Neovim API to open the file
	vim.cmd('edit ' .. file_path)

	-- Jumping to the specific line
	if line_number then
		vim.api.nvim_win_set_cursor(0, {line_number, 0})
	end
end

--! @brief Generates a codelink URI for the current cursor location and copies it to the system clipboard (+ register).
--! @return void
function CodeLink()
	local line = vim.fn.line('.')
	local filename = vim.fn.expand('%:p')
	local lk = newCodeLinkByFileLnum(filename, line)
	vim.fn.setreg('+', lk)
end

--! @brief Prompts the user to enter a codelink URI, then jumps to it. Default input is retrieved from the clipboard.
--! @return void
function GotoCodeLink()
	vim.ui.input({ prompt = 'Enter CodeLink: ', default = vim.fn.getreg('+') }, function(input)
		if input then
			JumpToFileAndLine(input)
		end
	end)
end

--! @brief Displays a menu to choose between jumping to a codelink or generating a new one for the current file and line.
--! @param filename string The file path.
--! @param lnum number The line number.
--! @return void
function CodeLinkMenu(filename, lnum)
	vim.ui.select({ 
		'goto',
		'generate',
	}, {
		prompt = 'CodeLinkMenu',
	}, function(sel)
		if sel == 'goto' then
			GotoCodeLink()
		elseif sel == 'generate' then
			vim.fn.setreg('+', newCodeLinkByFileLnum(filename, lnum))
		end
	end)
end
