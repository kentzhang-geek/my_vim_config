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
inoremap <leader><leader>k <c-o><c-u>
inoremap <leader><leader>j <c-o><c-d>

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
Plug 'junegunn/fzf.vim'
Plug 'laher/fuzzymenu.vim'
Plug 'frazrepo/vim-rainbow'
Plug 'scrooloose/nerdcommenter'
Plug 'lervag/vimtex'
Plug 'tonsky/firacode'
Plug 'easymotion/vim-easymotion'
Plug 'vim-denops/denops.vim'
Plug 'altercation/solarized'
Plug 'tpope/vim-fugitive'
Plug 'altercation/vim-colors-solarized'
Plug 'tikhomirov/vim-glsl'
Plug 'beyondmarc/hlsl.vim'
Plug 'azabiong/vim-highlighter'
Plug 'mattesgroeger/vim-bookmarks'
call plug#end()

" for deoplete
let g:deoplete#enable_at_startup = 1

" configs for NERDTree
nnoremap <leader>nt :NERDTree<CR>
inoremap <leader><leader>nt <esc>:NERDTree<CR>

" configs for fzf
let g:fzf_preview_window = 'right:50%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }
nnoremap <leader>f :FZF<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>gf :GFiles<CR>
nnoremap <leader>m :Fzm<CR>
nnoremap <leader>mm :Commands<CR>

inoremap <leader><leader>f  <esc>:FZF<CR>
inoremap <leader><leader>l  <esc>:BLines<CR>
inoremap <leader><leader>gf <esc>:GFiles<CR>
inoremap <leader><leader>m  <esc>:Fzm<CR>
inoremap <leader><leader>mm <esc>:Commands<CR>

" usage for nerd commenter
" [count]<leader>c<space> |NERDCommenterToggle|

" usage for easy motion:
" <leader><leader>s
let g:EasyMotion_smartcase = 1
" this is for n characters search
nnoremap <Leader>s <Plug>(easymotion-sn)
inoremap <Leader><leader>s <esc><Plug>(easymotion-sn)
" Now, all you need to remember is s and JK motions bindings, and it's good enough to boost your cursor speed!

"vim字体大小
" - font type and size setting.
if has('win32')
    set clipboard=unnamed
    set guifont=Consolas:h16   " Win32.
elseif has('gui_macvim')
    set clipboard=unnamed
    set guifont=Monaco:h16     " OSX.
else
    set clipboard=unnamedplus
    set guifont=Monospace\16  " Linux.
endif
colorscheme solarized
set background=dark
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

" Highlighter
let HiSet   = '<space>s'           " normal, visual
let HiErase = '<space>e'           " normal, visual
let HiClear = '<space>c'          " normal
let HiFind  = '<space>f'          " normal, visual

" Bookmark
highlight BookmarkSign ctermbg=NONE ctermfg=160
highlight BookmarkLine ctermbg=194 ctermfg=NONE
let g:bookmark_sign = '♥'
let g:bookmark_highlight_lines = 1
nnoremap <Leader>bb <Plug>BookmarkToggle
nnoremap <Leader>ba <Plug>BookmarkAnnotate
nnoremap <Leader>bs <Plug>BookmarkShowAll
inoremap <Leader><leader>bb <esc><Plug>BookmarkToggle
inoremap <Leader><leader>ba <esc><Plug>BookmarkAnnotate
inoremap <Leader><leader>bs <esc><Plug>BookmarkShowAll
