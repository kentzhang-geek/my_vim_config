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
require('lazy').setup({
  {
    "folke/tokyonight.nvim",
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
{
    'phaazon/hop.nvim', -- instead of easymotion
    config = function()
        require'hop'.setup()
    end,
},
'rust-lang/rust.vim',
{
    'junegunn/fzf',
    build = function ()
        vim.cmd(':call fzf#install()')
    end
},
'github/copilot.vim',
'junegunn/vim-easy-align',
})


-- basic configs
vim.opt.encoding='utf-8'
vim.opt.nu=true
vim.opt.autoindent=true
vim.opt.cindent=true
vim.o.shiftwidth=4
vim.o.softtabstop=4
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
vim.keymap.set('n', nleader .. 'l', ':BLines<CR>')
vim.keymap.set('n', nleader .. 'gf', ':GFiles<CR>')
vim.keymap.set('n', nleader .. 'm', ':Fzm<CR>')
vim.keymap.set('n', nleader .. 'mm', ':Commands<CR>')
