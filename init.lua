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
-- For NVim cmp
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
'easymotion/vim-easymotion',
'rust-lang/rust.vim',
{
    'junegunn/fzf',
    build = function ()
        vim.cmd(':call fzf#install()')
    end
},
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
'mattesgroeger/vim-bookmarks',
'azabiong/vim-highlighter',
'tikhomirov/vim-glsl',
'beyondmarc/hlsl.vim',
})


-- basic configs
vim.opt.encoding='utf-8'
vim.opt.nu=true
vim.opt.autoindent=true
vim.opt.cindent=true
vim.o.shiftwidth=4
vim.o.softtabstop=4
vim.o.hlsearch=false
vim.o.expandtab=true
vim.o.cursorline=true
if vim.fn.has('gui_running') then
    vim.cmd('set guioptions+=c')
end
vim.cmd('set clipboard+=unnamedplus')

-- set leader key
vim.g.mapleader = ','

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

-- save easy
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')

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
vim.g.EasyMotion_smartcase = 1
vim.keymap.set('n', nleader .. 's', '<Plug>(easymotion-sn)')
vim.keymap.set('i', ileader .. 's', '<Plug>(easymotion-sn)')


-- For Copilot
vim.keymap.set(nimode, '<A-\\>', '<Plug>(copilot-suggest)')
vim.keymap.set(nimode, '<A-n>', '<Plug>(copilot-next)')
vim.keymap.set(nimode, '<A-p>', '<Plug>(copilot-prev)')

-- Bookmark
vim.cmd('highlight BookmarkSign ctermbg=NONE ctermfg=160')
vim.cmd('highlight BookmarkLine ctermbg=194 ctermfg=NONE')
vim.g.bookmark_sign = '♥'
vim.g.bookmark_highlight_lines = 1
vim.g.bookmark_auto_close = 1
vim.g.bookmark_show_toggle_warning = 0
vim.keymap.set('n', nleader .. 'bb', '<Plug>BookmarkToggle')
vim.keymap.set('n', nleader .. 'ba', '<Plug>BookmarkAnnotate')
vim.keymap.set('n', nleader .. 'bs', '<Plug>BookmarkShowAll')
vim.keymap.set('i', ileader .. 'bb', '<Plug>BookmarkToggle')
vim.keymap.set('i', ileader .. 'ba', '<Plug>BookmarkAnnotate')
vim.keymap.set('i', ileader .. 'bs', '<Plug>BookmarkShowAll')

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

