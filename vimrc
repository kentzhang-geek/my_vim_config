colorscheme gruvbox

set nobackup
set tabstop=4 
set softtabstop=4 
set shiftwidth=4 
set noexpandtab 
set nu
set autoindent 
set cindent

"vim字体大小
set guifont=Courier_New:h12:cANSI

set nocompatible " be iMproved
set backspace=2 " be iMproved


" 设置Leader键
let mapleader = ","


" 使用GUI界面时的设置
if  has("gui_running")
	set guioptions+=c        " 使用字符提示框
	set cursorline           " 突出显示当前行
endif

" My Plugins
call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'rust-lang/rust.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'frazrepo/vim-rainbow'
Plug 'scrooloose/nerdcommenter'
Plug 'lervag/vimtex'
call plug#end()

" configs for NERDTree
nnoremap <leader>nt :NERDTree<CR>
