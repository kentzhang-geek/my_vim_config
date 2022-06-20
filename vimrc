colorscheme gruvbox

set nobackup
set tabstop=4 
set softtabstop=4 
set shiftwidth=4 
set noexpandtab 
set nu
set autoindent 
set cindent
set nocompatible " be iMproved
set backspace=2 " be iMproved


" 设置Leader键
let mapleader = ","

" save easy
nnoremap <leader>w :w<CR>


" 使用GUI界面时的设置
if  has("gui_running")
	set guioptions+=c        " 使用字符提示框
	set cursorline           " 突出显示当前行
endif

" My Plugins
call plug#begin()
Plug 'scrooloose/nerdtree'
if  has("gui_running")
	Plug 'bling/vim-airline'
endif
Plug 'rust-lang/rust.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'frazrepo/vim-rainbow'
Plug 'scrooloose/nerdcommenter'
Plug 'lervag/vimtex'
Plug 'tonsky/firacode'
Plug 'easymotion/vim-easymotion'
call plug#end()

" configs for NERDTree
nnoremap <leader>nt :NERDTree<CR>

" configs for fzf
let g:fzf_preview_window = 'right:50%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }
nnoremap <leader>f :FZF<CR>

" usage for nerd commenter
" [count]<leader>c<space> |NERDCommenterToggle|

" usage for easy motion:
" <leader><leader>s
let g:EasyMotion_smartcase = 1
" Now, all you need to remember is s and JK motions bindings, and it's good enough to boost your cursor speed!


"vim字体大小
set guifont=Consolas:h16
