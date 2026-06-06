--! @file my_tag.lua
--! @brief Module implementing faster change tracking tags (BEGIN/END comments) for various programming language syntaxes.

--! @brief Inserts a change tag (BEGIN or END comment block) at the specified line number with correct indentation.
--! @param lnum number The line number where the tag should be appended.
--! @param isBegin boolean Whether it is a BEGIN tag (true) or an END tag (false).
--! @param line_indent number The number of spaces to indent the tag.
--! @return void
function applyChangeTag(lnum, isBegin, line_indent)
	local t = ''
	local cfg = load_config() -- load cfg every calls
	local filetype = vim.bo.filetype

	for i = 0, line_indent - 1 do
		t = t .. ' '
	end

	local tag_head = cfg.tag_head or "NONE"
	local begin_tag = ''
	local end_tag = ''

	if filetype == 'lua' or filetype == 'python' then
		begin_tag = "# " .. tag_head .. "_BEGIN | " .. cfg.Tag_type .. " | " .. cfg.User_name .. " | " .. os.date('%Y-%m-%d') .. " | " .. cfg.Tag_reason
		end_tag = "# " .. tag_head .. "_END"
	elseif filetype == 'xml' then
		begin_tag = "<!-- " .. tag_head .. "_BEGIN | " .. cfg.Tag_type .. " | " .. cfg.User_name .. " | " .. os.date('%Y-%m-%d') .. " | " .. cfg.Tag_reason .. " -->"
		end_tag = "<!-- " .. tag_head .. "_END -->"
	elseif filetype == 'c' or filetype == 'javascript' then -- Add other c-style languages here
		begin_tag = "// " .. tag_head .. "_BEGIN | " .. cfg.Tag_type .. " | " .. cfg.User_name .. " | " .. os.date('%Y-%m-%d') .. " | " .. cfg.Tag_reason
		end_tag = "// " .. tag_head .. "_END"
	else -- default to generic comment style
		begin_tag = "// " .. tag_head .. "_BEGIN | " .. cfg.Tag_type .. " | " .. cfg.User_name .. " | " .. os.date('%Y-%m-%d') .. " | " .. cfg.Tag_reason
		end_tag = "// " .. tag_head .. "_END"
	end

	if isBegin then
		t = t .. begin_tag
		vim.fn.append(lnum - 1, {t})
	else
		t = t .. end_tag
		vim.fn.append(lnum, {t})
	end
end

--! @brief Wrapper function to insert tag at current line with proper indentation.
--! @param isBegin boolean Whether to insert a BEGIN tag (true) or an END tag (false).
--! @return void
function tagWrapper(isBegin)
	local linenum = vim.fn.line('.')
	local line_indent = vim.fn.indent(linenum)
	applyChangeTag(linenum, isBegin, line_indent)
end

--! @brief Binds key mappings for faster change tagging in normal mode.
--! @return void
function tag_faster()
	vim.keymap.set("n", '<M-a>', function() tagWrapper(true) end) -- show marked file list in quickfix window
	vim.keymap.set("n", '<M-b>', function() tagWrapper(false) end) -- show marked file list in quickfix window
end
