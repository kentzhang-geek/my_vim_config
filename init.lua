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

-- Highlighter
vim.cmd([[
" default key mappings
let HiSet   = '<space>s'
let HiErase = '<space>e'
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
local sessions_path = vim.fn.expand('$HOME') .. '\\vim_sessions'
local bookmarks_path = vim.fn.expand('$HOME') .. '\\vim_bookmarks'

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
        'nvim-treesitter/nvim-treesitter',  -- a better syntax highlighter
        build = function ()
            vim.cmd(':TSUpdate')
        end
    },
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
                save_file = bookmarks_path .. "\\default.bookmarks", -- bookmarks save file path
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
    {
        "dhananjaylatkar/cscope_maps.nvim",
        dependencies = {
            "folke/which-key.nvim", -- optional [for whichkey hints]
            "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
            "nvim-tree/nvim-web-devicons", -- optional [for devicons in telescope or fzf]
        },
        opts = {
            -- USE EMPTY FOR DEFAULT OPTIONS
            -- DEFAULTS ARE LISTED BELOW

            -- maps related defaults
            disable_maps = true, -- "true" disables default keymaps
            skip_input_prompt = false, -- "true" doesn't ask for input
            prefix = "<leader>cs", -- prefix to trigger maps

            -- cscope related defaults
            cscope = {
                -- location of cscope db file
                db_file = "C:/cscope_db/cscope.out",
                -- cscope executable
                exec = "cscope", -- "cscope" or "gtags-cscope"
                -- choose your fav picker
                picker = "telescope", -- "telescope", "fzf-lua" or "quickfix"
                -- size of quickfix window
                qf_window_size = 5, -- any positive integer
                -- position of quickfix window
                qf_window_pos = "bottom", -- "bottom", "right", "left" or "top"
                -- "true" does not open picker for single result, just JUMP
                skip_picker_for_single_result = false, -- "false" or "true"
                -- these args are directly passed to "cscope -f <db_file> <args>"
                db_build_cmd_args = { "-bqkv" },
                -- statusline indicator, default is cscope executable
                statusline_indicator = nil,
            }
        },
    },
    'nvim-telescope/telescope-ui-select.nvim',
    'Shatur/neovim-session-manager',    -- session manager
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },
    'petertriho/nvim-scrollbar',
    'norcalli/nvim-colorizer.lua',
    -- 'dstein64/nvim-scrollview',
})

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
local ileader = '<A-,>'

vim.keymap.set(nimode, '<A-Up>', '#')
vim.keymap.set(nimode, '<A-Down>', '*')
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
vim.keymap.set(nimode, '<M-c>', 'copilot#Accept()', opts)
vim.cmd(':Copilot disable')

-- For basic completion
vim.keymap.set('i', '<Tab>', 'coc#pum#confirm()', opts)
vim.keymap.set('i', '<A-e>', 'coc#pum#visible() ? coc#pum#next(1) : "<A-e>"', opts)
vim.keymap.set('i', '<S-Tab>', 'coc#pum#visible() ? coc#pum#prev(1) : "<S-Tab>"', opts)

-- For bookmark
local bm = require "bookmarks"
require('telescope').load_extension('bookmarks')
local map = vim.keymap.set
function bmlist()
    vim.cmd(':Telescope bookmarks list')
end
map("n", nleader .. "bb", bm.bookmark_toggle) -- add or remove bookmark at current line
map("n", nleader .. "ba", bm.bookmark_ann) -- add or edit mark annotation at current line
map("n", nleader .. "bc", bm.bookmark_clean) -- clean all marks in local buffer
map("n", nleader .. "bn", bm.bookmark_next) -- jump to next mark in local buffer
map("n", nleader .. "bp", bm.bookmark_prev) -- jump to previous mark in local buffer
map("n", nleader .. "bs", function() bmlist() end) -- show marked file list in quickfix window
map("i", ileader .. "bb", bm.bookmark_toggle) -- add or remove bookmark at current line
map("i", ileader .. "ba", bm.bookmark_ann) -- add or edit mark annotation at current line
map("i", ileader .. "bc", bm.bookmark_clean) -- clean all marks in local buffer
map("i", ileader .. "bn", bm.bookmark_next) -- jump to next mark in local buffer
map("i", ileader .. "bp", bm.bookmark_prev) -- jump to previous mark in local buffer
map("i", ileader .. "bs", function() bmlist() end) -- show marked file list in quickfix window

-- Bookmark
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

function CodeLink()
    local line = vim.fn.line('.')
    local filename = vim.fn.expand('%:p')
    local lk = 'codelink://' .. filename .. ':' .. line
    vim.fn.setreg('+', lk)
end
vim.keymap.set('n', nleader .. 'url', function() CodeLink() end)

function CopyAbsolutePath()
    local filename = vim.fn.expand('%:p')
    vim.fn.setreg('+', filename)
end
vim.keymap.set('n', nleader .. 'pt', function() CopyAbsolutePath() end)

-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.clangd.setup{}

function SessionMenu()
    vim.ui.select({ 
        'save',
        'load',
        'show session files'
    }, {
        prompt = 'Utilities',
    }, function(sel)
        local NEOHOME = vim.fn.expand('$HOME') .. '\\Appdata\\Local\\nvim\\'
        if sel == 'save' then
            vim.cmd('SessionManager save_current_session')
        elseif sel == 'load' then
            vim.cmd('SessionManager load_session')
        elseif sel == 'show session files' then
            os.execute('explorer \"' .. sessions_path .. '\"')
        end
    end)
end

function CscopeSubmenu()
    vim.ui.select({ 
        'select types',
        'update',
        'choose root',
        'make as root', 
    }, {
        prompt = 'Cscope Utilities',
    }, function(sel)
        local NEOHOME = vim.fn.expand('$HOME') .. '\\Appdata\\Local\\nvim\\'
        if sel == 'select types' then
            os.execute('python ' .. NEOHOME .. 'cscope_tools.py -files')
        elseif sel == 'update' then
            os.execute('python ' .. NEOHOME .. 'cscope_tools.py -update')
        elseif sel == 'choose root' then
            os.execute('python ' .. NEOHOME .. 'cscope_tools.py -chroot')
        elseif sel == 'make as root' then
            os.execute('python ' .. NEOHOME .. 'cscope_tools.py -mkroot')
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

-- TODO -> a lua config reader
local project_config_file = 'C:\\cscope_db\\project_config.json'
local project_config = vim.json.decode(io.open(project_config_file, "r"):read('*a'))
local Tag_reason = project_config.Tag_reason
local Tag_type = project_config.Tag_type
local User_name = project_config.User_name

function FIFA_Tag(lnum, isBegin, line_indent)
    local t = ''
    for i = 0, line_indent - 1 do
        t = t .. ' '
    end
    -- Only support c-style for now
    if isBegin then
        t = t .. '// FIFA_BEGIN | ' .. Tag_type .. ' | ' .. User_name .. ' | ' .. os.date('%Y-%m-%d') .. ' | ' .. Tag_reason
    else 
        t = t .. '// FIFA_END'
    end
    vim.fn.append(lnum, {t})
end

-- Utilities shortcuts
function UtilityMenu() 
    local word = vim.fn.expand('<cword>')
    local linenum = vim.fn.line('.')
    local line_indent = vim.fn.indent(linenum)
    vim.ui.select({ 
        'lookup symbol',
        'lookup text',
        'cscope_db',
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
    }, {
        prompt = 'Utilities',
    }, function(sel)
        local NEOHOME = vim.fn.expand('$HOME') .. '\\Appdata\\Local\\nvim\\'
        if sel == 'lookup symbol' then
            vim.cmd('Cscope find s ' .. word)
        elseif sel == 'lookup text' then
            vim.cmd('Cscope find t ' .. word)
        elseif sel == 'cscope_db' then
            CscopeSubmenu()
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
        elseif sel == 'fifa begin' then
            FIFA_Tag(linenum, true, line_indent)
        elseif sel == 'fifa end' then
            FIFA_Tag(linenum, false, line_indent)
        end
    end)
end
vim.keymap.set('n', nleader .. 'mm', function() UtilityMenu() end)

-- execute vim script to provide menu functions
vim.cmd('source ~/Appdata/Local/nvim/neo_mm.vim')

-- for tab indenting
local opts = { noremap = true, silent = true }
vim.keymap.set("n",    "<Tab>",         ">>",  opts)
vim.keymap.set("n",    "<S-Tab>",       "<<",  opts)
vim.keymap.set("v",    "<Tab>",         ">gv", opts)
vim.keymap.set("v",    "<S-Tab>",       "<gv", opts)

-- for C-BS
vim.keymap.set("i", "<C-BS>", "<C-W>")

-- for mession manager
local Path = require('plenary.path')
local config = require('session_manager.config')
require('session_manager').setup({
  sessions_dir = Path:new(sessions_path), -- The directory where the session files will be saved.
  autoload_mode = config.AutoloadMode.Disabled, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  autosave_last_session = true, -- Automatically save last session on exit and on session switch.
  autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
  autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
  autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
    'gitcommit',
    'gitrebase',
  },
  autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
  autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
  max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
})

-- For Telescope
vim.keymap.set('n', nleader .. 'ts', ':Telescope<CR>')
require("telescope").load_extension("ui-select")
require("telescope").load_extension "file_browser"
require('telescope').setup{
    defaults = {
        layout_strategy='vertical',
        layout_config = {
            vertical = { width = 0.8 },
            -- other layout configuration here
        },
        -- other defaults configuration here
    },
}

-- switch between tabs
vim.keymap.set('n', '<C-Tab>', ':bnext<CR>')
vim.keymap.set('n', '<C-Pagedown>', ':bnext<CR>')
vim.keymap.set('n', '<C-Pageup>', ':bprevious<CR>')
