set helplang=cn
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
set guifont=Monospace\ 16

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
" call plug#begin()
" Plug 'scrooloose/nerdtree',
" call plug#end()

