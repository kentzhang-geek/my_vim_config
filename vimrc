
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

" move easy
nnoremap <leader>k <c-u>
nnoremap <leader>j <c-d>

" save easy
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>


" 使用GUI界面时的设置
if  has("gui_running")
	set guioptions+=c        " 使用字符提示框
	set cursorline           " 突出显示当前行
endif

" My Plugins
call plug#begin()
Plug 'scrooloose/nerdtree'
if  has("gui_running")
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
endif
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
Plug 'mhinz/vim-startify'
Plug 'rust-lang/rust.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'frazrepo/vim-rainbow'
Plug 'scrooloose/nerdcommenter'
Plug 'lervag/vimtex'
Plug 'tonsky/firacode'
Plug 'easymotion/vim-easymotion'
Plug 'vim-denops/denops.vim'
Plug 'altercation/solarized'
Plug 'tpope/vim-fugitive'
Plug 'altercation/vim-colors-solarized'
call plug#end()

" for deoplete
let g:deoplete#enable_at_startup = 1

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
" this is for n characters search
nmap <Leader>s <Plug>(easymotion-sn)
" Now, all you need to remember is s and JK motions bindings, and it's good enough to boost your cursor speed!

"vim字体大小
set guifont=Consolas:h16
colorscheme solarized
set background=dark
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
