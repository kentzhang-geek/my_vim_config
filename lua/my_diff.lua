--! @file my_diff.lua
--! @brief Module implementing helper functions and mapping initializations for Neovim's built-in diff mode.

--! @brief Jumps to the next diff change block and centers the screen.
--! @return void
function nextDiff()
	vim.cmd("normal! ]czz")
end

--! @brief Jumps to the previous diff change block and centers the screen.
--! @return void
function prevDiff()
	vim.cmd("normal! [czz")
end

--! @brief Checks if the cursor is currently in the left window of a diff split.
--! @return boolean True if in the left window (window 1), false otherwise.
function IsInLeftSide()
	-- return true if cursor is in left side
	return vim.fn.winnr() == 1
end

--! @brief Pushes differences from left window to right window (diffput) or pulls from left (diffget) depending on the active side.
--! @return void
function DiffL2R()
	if IsInLeftSide() then
		vim.cmd("diffput")
	else 
		vim.cmd("diffget")
	end
end

--! @brief Pulls differences from right window to left window (diffget) or pushes from right (diffput) depending on the active side.
--! @return void
function DiffR2L()
	if IsInLeftSide() then
		vim.cmd("diffget")
	else 
		vim.cmd("diffput")
	end
end

--! @brief Pushes/pulls differences for the current line only from left to right.
--! @return void
function DiffL2R1()
	if IsInLeftSide() then
		vim.cmd(".diffput")
	else 
		vim.cmd(".diffget")
	end
end

--! @brief Pulls/pushes differences for the current line only from right to left.
--! @return void
function DiffR2L1()
	if IsInLeftSide() then
		vim.cmd(".diffget")
	else 
		vim.cmd(".diffput")
	end
end

-- Setup diff-mode specific keymaps if diff mode is active
if vim.opt.diff:get() then
	tag_faster()
	vim.api.nvim_set_keymap('n', '<M-Down>', ':lua nextDiff()<CR>', {noremap = true, silent = true})
	vim.api.nvim_set_keymap('n', '<M-Up>', ':lua prevDiff()<CR>', {noremap = true, silent = true})
	vim.keymap.set("n", '<M-Left>', function() DiffR2L() end) 
	vim.keymap.set("n", '<M-Right>', function() DiffL2R() end)
	vim.keymap.set("n", '<M-S-Left>', function() DiffR2L1() end)
	vim.keymap.set("n", '<M-S-Right>', function() DiffL2R1() end)
	vim.api.nvim_set_keymap('n', '<M-j>', ':lua nextDiff()<CR>', {noremap = true, silent = true})
	vim.api.nvim_set_keymap('n', '<M-k>', ':lua prevDiff()<CR>', {noremap = true, silent = true})
	vim.keymap.set("n", '<M-h>', function() DiffR2L() end)
	vim.keymap.set("n", '<M-l>', function() DiffL2R() end)
	vim.keymap.set("n", '<M-S-h>', function() DiffR2L1() end)
	vim.keymap.set("n", '<M-S-l>', function() DiffL2R1() end)
	vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', {noremap = true, silent = true})
end
