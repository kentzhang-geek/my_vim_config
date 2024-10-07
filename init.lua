local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- set leader key
vim.g.mapleader = ','

-- no editor config
vim.g.editorconfig = false

-- Highlighter
vim.cmd([[
" default key mappings
let HiSet   = '<M-f>'
let HiErase = '<M-e>'
let HiClear = '<space>c'
let HiFind  = '<space>f'

" directory to store highlight files
" let HiKeywords = '~/.vim/after/vim-highlighter'
]])

-- configs
vim.cmd([[
set backspace=indent,eol,start
set autoread
set ignorecase
]])

-- path configs
local path_spliter = '\\'
if not (vim.loop.os_uname().sysname == 'Windows_NT') then
    path_spliter = '/'
end
local sessions_path = vim.fn.expand('$HOME') .. path_spliter .. 'vim_sessions'
local bookmarks_path = vim.fn.expand('$HOME') .. path_spliter .. 'vim_bookmarks'

-- check bookmark directory
if vim.fn.isdirectory(bookmarks_path) == 0 then
    vim.fn.mkdir(bookmarks_path)
end

-- check session directory
if vim.fn.isdirectory(sessions_path) == 0 then
    vim.fn.mkdir(sessions_path)
end

require('lazy').setup({
    {
        'folke/tokyonight.nvim',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    -- For NVim completion
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'tpope/vim-commentary',

    'scrooloose/nerdtree',

    'vim-airline/vim-airline',
    'vim-airline/vim-airline-themes',
    -- {
    -- 'phaazon/hop.nvim', -- instead of easymotion, it's faster
    -- config = function()
    --     require'hop'.setup()
    -- end,
    -- },
    -- 'easymotion/vim-easymotion',
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump({
                labels = "asdfghjklqwertyuiopzxcvbnm",
                search = { forward = true, wrap = true, multi_window = true, mode="search"},
                label = {uppercase = false, after = false, before = true},
            }) end, desc = "Flash" },
        },
    },
    'rust-lang/rust.vim',
    {
        'junegunn/fzf',
        build = function ()
            vim.cmd(':call fzf#install()')
        end
    },
    'junegunn/fzf.vim',
    'github/copilot.vim',
    'junegunn/vim-easy-align',
    'frazrepo/vim-rainbow',
    {
        'gelguy/wilder.nvim',
        config = function()
            -- config goes here
            local wilder = require('wilder')
            wilder.setup({
                modes = { ':', '/', '?', '!' },
            })
            wilder.set_option('renderer', wilder.popupmenu_renderer(
            wilder.popupmenu_palette_theme({
                -- 'single', 'double', 'rounded' or 'solid'
                -- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
                border = 'rounded',
                max_height = '75%',      -- max height of the palette
                min_height = 0,          -- set to the same as 'max_height' for a fixed height window
                prompt_position = 'top', -- 'top' or 'bottom' to set the location of the prompt
                reverse = 0,             -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
            })
            ))
        end,
    },
    {
        'akinsho/bufferline.nvim',
        config = function() 
            require('bufferline').setup(
            {
                options = {
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                    show_tab_indicators = true,
                    separator_style = 'thin',
                    always_show_bufferline = true,
                }
            }
            )
        end,
    },
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                -- config
                theme = 'hyper',
                config = {
                    week_header = {
                        enable = true,
                    },
                    packages = { enable = true }, -- show how many plugins neovim loaded
                    project = { enable = true, limit = 8, icon = 'your icon', label = ''},
                    mru = { limit = 10, icon = 'your icon', label = '', },
                    footer = {}, -- footer
                    shortcut = {
                        { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
                        {
                            icon = ' ',
                            icon_hl = '@variable',
                            desc = 'Files',
                            group = 'Label',
                            action = 'FZF',
                            key = 'f',
                        },
                        {
                            desc = 'Exit',
                            group = 'Label',
                            action = 'q',
                            key = 'q',
                        },
                        -- {
                        --   desc = ' Apps',
                        --   group = 'DiagnosticHint',
                        --   action = 'Telescope app',
                        --   key = 'a',
                        -- },
                    },
                },
            }
        end,
        dependencies = { {'nvim-tree/nvim-web-devicons'}}
    },
    { 'stevearc/dressing.nvim' },
    -- 'mattesgroeger/vim-bookmarks',
    'azabiong/vim-highlighter',
    'tikhomirov/vim-glsl',
    'beyondmarc/hlsl.vim',

    -- LSP
    'neovim/nvim-lspconfig',
    {
        'williamboman/mason.nvim',
        config = function ()
            require("mason").
            setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "->",
                        package_uninstalled = "x"
                    }
                }
            })
        end
    },
    'williamboman/mason-lspconfig.nvim',
    'nvim-lua/plenary.nvim',
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                              , branch = '0.1.x',
        dependencies = { 
            'nvim-lua/plenary.nvim',
            { 
                "nvim-telescope/telescope-live-grep-args.nvim" ,
                -- This will not install any breaking changes.
                -- For major updates, this must be adjusted manually.
                version = "^1.0.0",
            },
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
    },
    {
        'kentzhang-geek/bookmarks.nvim', -- after = "telescope.nvim",
        event = "VimEnter",
        config = function()
            require('bookmarks').setup{
                save_file = bookmarks_path .. path_spliter .. "default.bookmarks", -- bookmarks save file path
                keywords =  {
                    ["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
                    ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
                    ["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
                    ["@n"] = " ", -- mark annotation startswith @n ,signs this icon as `Note`
                },
            }
        end
    },
    {
        'neoclide/coc.nvim', branch = 'release',
    },
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'petertriho/nvim-scrollbar',
    'norcalli/nvim-colorizer.lua',
    -- 'dstein64/nvim-scrollview',
    'wfxr/minimap.vim', -- minimap
})

vim.cmd([[
let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1
]])

-- for airline statusline
vim.cmd([[
let g:airline_section_c = '%F'
]])

-- coc for Frostbite
vim.g.coc_global_extensions = {'coc-clangd'}

vim.opt.encoding   = 'utf-8'
vim.opt.nu         = true
vim.opt.autoindent = true
vim.opt.cindent    = true
vim.opt.tabstop    = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab  = true
vim.bo.softtabstop = 4
vim.o.softtabstop  = 4
vim.o.hlsearch     = false
vim.o.expandtab    = true
vim.o.cursorline   = true
vim.opt.swapfile   = false

if vim.fn.has('gui_running') then
    vim.cmd('set guioptions+=c')
end
vim.cmd('set clipboard+=unnamedplus')

-- scrollbar -> this one seems better
require('colorizer').setup()
local colors = require("tokyonight.colors").setup()

require("scrollbar").setup({
    handle = {
        color = colors.blue0,
    },
    marks = {
        Search = { color = colors.orange },
        Error = { color = colors.error },
        Warn = { color = colors.warning },
        Info = { color = colors.info },
        Hint = { color = colors.hint },
        Misc = { color = colors.purple },
    }
})

-- move easy
local nimode = {'n', 'i'}
local nivmode = {'n', 'i', 'v'}
local nleader = '<leader>'
local ileader = '<M-,>'

vim.keymap.set(nimode, '<M-Up>', '#')
vim.keymap.set(nimode, '<M-Down>', '*')
vim.keymap.set('n', '<c-p>', '#')
vim.keymap.set('n', '<c-n>', '*')

vim.keymap.set('n', nleader .. 'k', '<c-u>')
vim.keymap.set('n', nleader .. 'j', '<c-d>')
vim.keymap.set('n', ileader .. 'k', '<c-u>')
vim.keymap.set('n', ileader .. 'j', '<c-d>')

-- paste easy
vim.keymap.set('c', '<S-Insert>', '<C-R>+')
vim.keymap.set('n', '<S-Insert>', '<C-R>+')
vim.keymap.set('i', '<S-Insert>', '<C-R>+')

-- save easy
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':bd<CR>')
vim.keymap.set('n', '<leader>x', ':q<CR>')

-- configs for NERDTree
vim.keymap.set('n', nleader .. 'nt', ':NERDTree<CR>')
vim.keymap.set('i', ileader .. 'nt', '<esc>:NERDTree<CR>')

-- configs for fzf
vim.g.fzf_preview_window = 'right:50%'
vim.g.fzf_layout = { window = { width = 0.9, height = 0.6  }  }
vim.keymap.set('n', nleader .. 'f', ':FZF<CR>')
-- for old fuzzy.vim
-- vim.keymap.set('n', nleader .. 'l', ':BLines<CR>')
-- vim.keymap.set('n', nleader .. 'gf', ':GFiles<CR>')
-- vim.keymap.set('n', nleader .. 'm', ':Fzm<CR>')
-- vim.keymap.set('n', nleader .. 'mm', ':Commands<CR>')

-- for vim-commentary
-- for visual mode, only 'gc' will work
vim.keymap.set('n', nleader .. '/', '<Plug>CommentaryLine')
vim.keymap.set('i', ileader .. '/', '<Plug>CommentaryLine')
vim.keymap.set(nimode, '<C-/>', '<Plug>CommentaryLine')

-- for easy align
-- Start interactive EasyAlign in visual mode (e.g. vipga)
vim.keymap.set('v', 'ga', '<Plug>(EasyAlign)<C-X>')

-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
vim.keymap.set('n', nleader .. 'ea', 'vip<Plug>(EasyAlign)<C-X>')

-- For Hop
-- vim.keymap.set('n', nleader .. 's', ':HopAnywhere<CR>')
-- For easymotion
-- vim.g.EasyMotion_smartcase = 1
-- vim.keymap.set('n', nleader .. 's', '<Plug>(easymotion-sn)')
-- vim.keymap.set('i', ileader .. 's', '<Plug>(easymotion-sn)')

-- For Copilot
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
local Plug_opts = {silent = true, noremap = false}
vim.keymap.set(nimode, '<M-\\>', '<Plug>(copilot-suggest)', Plug_opts)
vim.keymap.set(nimode, '<M-r>', '<Plug>(copilot-suggest)', Plug_opts)
vim.keymap.set(nimode, '<M-n>', '<Plug>(copilot-next)', Plug_opts)
vim.keymap.set(nimode, '<M-p>', '<Plug>(copilot-prev)', Plug_opts)
vim.keymap.set(nimode, '<M-x>', 'copilot#Accept()', opts)
vim.cmd(':Copilot disable')

-- For basic completion
vim.keymap.set('i', '<Tab>', 'coc#pum#confirm()', opts)
vim.keymap.set('i', '<M-e>', 'coc#pum#visible() ? coc#pum#next(1) : "<M-e>"', opts)
vim.keymap.set('i', '<S-Tab>', 'coc#pum#visible() ? coc#pum#prev(1) : "<S-Tab>"', opts)

-- Telescope extensions
local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- For bookmark
local bm = require "bookmarks"
telescope.load_extension('bookmarks')
local map = vim.keymap.set
function bmlist()
    vim.cmd(':Telescope bookmarks list')
end
map("n", nleader .. "bb", bm.bookmark_toggle) -- add or remove bookmark at current line
map("n", nleader .. "ba", bm.bookmark_ann) -- add or edit mark annotation at current line
map("n", nleader .. "bs", function() bmlist() end) -- show marked file list in quickfix window
map("i", ileader .. "bb", bm.bookmark_toggle) -- add or remove bookmark at current line
map("i", ileader .. "ba", bm.bookmark_ann) -- add or edit mark annotation at current line
map("i", ileader .. "bs", function() bmlist() end) -- show marked file list in quickfix window

-- For Telescope
vim.keymap.set('n', nleader .. 'ts', ':Telescope<CR>')
telescope.load_extension("ui-select")
telescope.load_extension "file_browser"
telescope.setup{
    defaults = {
        layout_strategy='vertical',
        layout_config = {
            vertical = { width = 0.8 },
            -- other layout configuration here
        },
        -- other defaults configuration here
    }
}

-- Bookmark -> Deprecated
-- vim.cmd('highlight BookmarkSign ctermbg=NONE ctermfg=160')
-- vim.cmd('highlight BookmarkLine ctermbg=194 ctermfg=NONE')
-- vim.g.bookmark_sign = '♥'
-- vim.g.bookmark_highlight_lines = 1
-- vim.g.bookmark_auto_close = 1
-- vim.g.bookmark_show_toggle_warning = 0
-- vim.keymap.set('n', nleader .. 'bb', '<Plug>BookmarkToggle')
-- vim.keymap.set('n', nleader .. 'ba', '<Plug>BookmarkAnnotate')
-- vim.keymap.set('n', nleader .. 'bs', '<Plug>BookmarkShowAll')
-- vim.keymap.set('i', ileader .. 'bb', '<Plug>BookmarkToggle')
-- vim.keymap.set('i', ileader .. 'ba', '<Plug>BookmarkAnnotate')
-- vim.keymap.set('i', ileader .. 'bs', '<Plug>BookmarkShowAll')

function newCodeLinkByFileLnum(filename, lnum)
    local lk = 'codelink://' .. filename .. ':' .. lnum
    return lk
end

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

function CodeLink()
    local line = vim.fn.line('.')
    local filename = vim.fn.expand('%:p')
    local lk = newCodeLinkByFileLnum(filename, line)
    vim.fn.setreg('+', lk)
end
vim.keymap.set('n', nleader .. 'url', function() CodeLink() end)
vim.keymap.set('n', '<M-c>', function() CodeLink() end)
vim.keymap.set('i', '<M-c>', function() CodeLink() end)
vim.keymap.set('n', '<M-g>', function() GotoCodeLink() end)

function CopyAbsolutePath()
    local filename = vim.fn.expand('%:p')
    vim.fn.setreg('+', filename)
end
vim.keymap.set('n', nleader .. 'pt', function() CopyAbsolutePath() end)

-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.clangd.setup{}

local session_name = ""

function SaveSession() 
    vim.ui.input({ prompt = 'Enter session name: ', default=session_name }, function(input)
        if input then
            session_name = input
            vim.cmd('mksession! ' .. sessions_path .. path_spliter .. input)
        end
    end)
end

function LoadSession()
    -- Got file list under sessions_path, output a list
    local files = {}
    for file in io.popen('dir /b /a-d ' .. sessions_path):lines() do
        table.insert(files, file)
    end
    vim.ui.select(files,
    {
        prompt = 'select a session to load',
    }, function(sel)
        if sel then
            session_name = sel
            vim.cmd('source ' .. sessions_path .. path_spliter .. sel)
        end
    end)
end

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

function GotoCodeLink()
     vim.ui.input({ prompt = 'Enter CodeLink: ', default=vim.fn.getreg('+') }, function(input)
         if input then
             JumpToFileAndLine(input)
         end
     end)
end

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

function FileBrowser()
    vim.ui.input({
        prompt='Enter root path',
        default='C:\\',
    }, function(root) 
        if root then
            vim.cmd('cd ' .. root)
            vim.cmd('Telescope file_browser')
        end
    end)
end

local Tag_reason = ""
local Tag_type = ""
local User_name = ""
if not vim.fn.has('linux') then
-- TODO -> a lua config reader
local project_config_file = 'C:\\cscope_db\\project_config.json'
local project_config = vim.json.decode(io.open(project_config_file, "r"):read('*a'))
Tag_reason = project_config.Tag_reason
Tag_type = project_config.Tag_type
User_name = project_config.User_name
end

function FIFA_Tag(lnum, isBegin, line_indent)
    local t = ''
    for i = 0, line_indent - 1 do
        t = t .. ' '
    end
    -- Only support c-style for now
    if isBegin then
        t = t .. '// FIFA_BEGIN | ' .. Tag_type .. ' | ' .. User_name .. ' | ' .. os.date('%Y-%m-%d') .. ' | ' .. Tag_reason
        vim.fn.append(lnum - 1, {t})
    else 
        t = t .. '// FIFA_END'
        vim.fn.append(lnum, {t})
    end
end

function FIFA_Tag_Wraper(isBegin)
    local linenum = vim.fn.line('.')
    local line_indent = vim.fn.indent(linenum)
    FIFA_Tag(linenum, isBegin, line_indent)
end

function FIFA_tag_faster()
    vim.keymap.set("n", '<M-a>', function() FIFA_Tag_Wraper(true) end) -- show marked file list in quickfix window
    vim.keymap.set("n", '<M-b>', function() FIFA_Tag_Wraper(false) end) -- show marked file list in quickfix window
end

-- Utilities shortcuts
function UtilityMenu() 
    local word = vim.fn.expand('<cword>')
    local file_path = vim.fn.expand('%:p:h')
    local filename = vim.fn.expand('%:p')
    local linenum = vim.fn.line('.')
    local line_indent = vim.fn.indent(linenum)
    vim.ui.select({ 
        'lookup word',
        'remove duplicate lines without sort',
        'remove duplicate lines with sort',
        'show bookmark files',
        'json beautify current line',
        'session submenu',
        'file browser',
        'live grep',
        'fuzzy lines',
        'fifa begin',
        'fifa end',
        'fifa tag config',
        'fifa tag faster',
        'cd to file',
        'p4 edit',
        'codelink tools',
        'minimap',
        'qgrep search',
        'qgrep files',
    }, {
        prompt = 'Utilities',
    }, function(sel)
        local NEOHOME = vim.fn.expand('$HOME') .. '\\Appdata\\Local\\nvim\\'
        if sel == 'lookup word' then
            vim.cmd('QgrepSearch ' .. word)
        elseif sel == 'remove duplicate lines without sort' then
            vim.cmd('g/^\\(.*\\)$\\n\\1/d')
        elseif sel == 'remove duplicate lines with sort' then
            vim.cmd('sort u')
        elseif sel == 'show bookmark files' then
            os.execute('explorer \"' .. bookmarks_path .. '\"')
        elseif sel == 'json beautify current line' then
            vim.cmd('%!jq .')
        elseif sel == 'session submenu' then
            SessionMenu()
        elseif sel == 'file browser' then
            FileBrowser()
        elseif sel == 'live grep' then
            require("telescope").extensions.live_grep_args.live_grep_args()
        elseif sel == 'fuzzy lines' then
            vim.cmd('Lines')
        elseif sel == 'fifa tag faster' then
            FIFA_tag_faster()
        elseif sel == 'fifa begin' then
            FIFA_Tag(linenum, true, line_indent)
        elseif sel == 'fifa end' then
            FIFA_Tag(linenum, false, line_indent)
        elseif sel == 'cd to file' then
            vim.cmd('cd ' .. file_path)
        elseif sel == 'p4 edit' then
            vim.cmd('cd ' .. file_path)
            vim.cmd('!p4 edit ' .. filename)
        elseif sel == 'codelink tools' then
            CodeLinkMenu(filename, linenum)
        elseif sel == 'minimap' then
            vim.cmd('MinimapToggle')
        elseif sel == 'qgrep search' then
            vim.cmd('QgrepSearch')
        elseif sel == 'qgrep files' then
            vim.cmd('QgrepFiles')
        end
    end)
end
vim.keymap.set('n', nleader .. 'mm', function() UtilityMenu() end)

-- for tab indenting
local opts = { noremap = true, silent = true }
vim.keymap.set("n",    "<Tab>",         ">>",  opts)
vim.keymap.set("n",    "<S-Tab>",       "<<",  opts)
vim.keymap.set("v",    "<Tab>",         ">gv", opts)
vim.keymap.set("v",    "<S-Tab>",       "<gv", opts)

-- for C-BS
vim.keymap.set("i", "<C-BS>", "<C-W>")

-- switch between tabs
vim.keymap.set('n', '<C-Tab>', ':bnext<CR>')
vim.keymap.set('n', '<C-Pagedown>', ':bnext<CR>')
vim.keymap.set('n', '<C-Pageup>', ':bprevious<CR>')

function nextDiff()
    vim.cmd("normal! ]c")
end

function prevDiff()
    vim.cmd("normal! [c")
end

-- Which side in VimDiff
function IsInLeftSide()
    -- return true if cursor is in left side
    return vim.fn.winnr() == 1
end

-- left to right
function DiffL2R()
    if IsInLeftSide() then
        vim.cmd("diffput")
    else 
        vim.cmd("diffget")
    end
end

-- right to left
function DiffR2L()
    if IsInLeftSide() then
        vim.cmd("diffget")
    else 
        vim.cmd("diffput")
    end
end

-- select current line
local function select_current_line()
    local line = vim.api.nvim_win_get_cursor(0)[1] -- Get the current line number
    vim.api.nvim_exec("normal! " .. line .. "GV" .. line .. "G", false)
end

-- left to right just 1 line
function DiffL2R1()
    if IsInLeftSide() then
        vim.cmd(".diffput")
    else 
        vim.cmd(".diffget")
    end
end

-- right to left just 1 line
function DiffR2L1()
    if IsInLeftSide() then
        vim.cmd(".diffget")
    else 
        vim.cmd(".diffput")
    end
end

-- for diff mode
if vim.opt.diff:get() then
    FIFA_tag_faster()
    vim.api.nvim_set_keymap('n', '<M-Down>', ':lua nextDiff()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<M-Up>', ':lua prevDiff()<CR>', {noremap = true, silent = true})
    vim.keymap.set("n", '<M-Left>', function() DiffR2L() end) 
    vim.keymap.set("n", '<M-Right>', function() DiffL2R() end)
    vim.keymap.set("n", '<M-S-Left>', function() DiffR2L1() end)
    vim.keymap.set("n", '<M-S-Right>', function() DiffL2R1() end)
    vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', {noremap = true, silent = true})
end
