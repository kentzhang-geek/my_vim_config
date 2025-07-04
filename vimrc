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
set encoding=UTF-8


" 设置Leader键
let mapleader = ','

" move easy
nnoremap <leader>k <c-u>
nnoremap <leader>j <c-d>
inoremap <leader>k <c-o><c-u>
inoremap <leader>j <c-o><c-d>
nnoremap <A-Up> #
nnoremap <A-Down> *
nnoremap <C-p> #
nnoremap <C-n> *

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
Plug 'laher/fuzzymenu.vim'
Plug 'frazrepo/vim-rainbow'
Plug 'scrooloose/nerdcommenter'
Plug 'lervag/vimtex'
Plug 'tonsky/firacode'
Plug 'easymotion/vim-easymotion'
" Plug 'vim-denops/denops.vim'	" no deno for now
Plug 'altercation/solarized'
Plug 'tpope/vim-fugitive'
Plug 'altercation/vim-colors-solarized'
Plug 'tikhomirov/vim-glsl'
Plug 'beyondmarc/hlsl.vim'
Plug 'azabiong/vim-highlighter'
Plug 'mattesgroeger/vim-bookmarks'
Plug 'github/copilot.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'junegunn/vim-easy-align'
call plug#end()

" for easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)<C-X>

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nnoremap <leader>ea vip<Plug>(EasyAlign)<C-X>

" for cpp highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_member_function_highlight = 1
let g:cpp_posix_standard = 0

" for deoplete
let g:deoplete#enable_at_startup = 1

" for startify
let g:startify_bookmarks = [ '~/vimfiles/vimrc', '~/vimfiles/ideavimrc' ]
let g:startify_skiplist = ['^\\\\*', '://']	" no remote server file

" for deno version check
" let g:denops_disable_version_check=1

" configs for NERDTree
nnoremap <leader>nt :NERDTree<CR>
inoremap <leader>nt <esc>:NERDTree<CR>

" configs for fzf
let g:fzf_preview_window = 'right:50%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }
nnoremap <leader>f :FZF<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>gf :GFiles<CR>
nnoremap <leader>m :Fzm<CR>
nnoremap <leader>mm :Commands<CR>

inoremap <leader>f  <esc>:FZF<CR>
inoremap <leader>l  <esc>:BLines<CR>
inoremap <leader>gf <esc>:GFiles<CR>
inoremap <leader>m  <esc>:Fzm<CR>
inoremap <leader>mm <esc>:Commands<CR>

" usage for nerd commenter
" [count]<leader>c<space> |NERDCommenterToggle|

" usage for easy motion:
" <leader>s
let g:EasyMotion_smartcase = 1
" this is for n characters search
nnoremap <Leader>s <Plug>(easymotion-sn)
inoremap <leader>s <esc><Plug>(easymotion-sn)
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
let g:bookmark_auto_close = 1
let g:bookmark_show_toggle_warning = 0
nnoremap <Leader>bb <Plug>BookmarkToggle
nnoremap <Leader>ba <Plug>BookmarkAnnotate
nnoremap <Leader>bs <Plug>BookmarkShowAll
inoremap <Leader>bb <esc><Plug>BookmarkToggle
inoremap <Leader>ba <esc><Plug>BookmarkAnnotate
inoremap <Leader>bs <esc><Plug>BookmarkShowAll


" Code Link
function! CodeLink()
	let lnum=line('.')
	let fname=expand('%:p')
	let lk = "codelink://" . fname . ":" . lnum
	echom lk
	call setreg('+', lk)
endfunction
nnoremap <leader>url :call CodeLink()<CR>

" for quick perforce reference
function! CopyAbsolutePath()
	let fname=expand('%:p')
	call setreg('+', fname)
endfunction
nnoremap <leader>pt :call CopyAbsolutePath()<CR>

" cscope config file C:\cscope_db\cs.conf, create if not exist
set cscopetag cscopeverbose
let cs_config = "C:\\cscope_db\\cs.conf"
if filereadable(cs_config)
else
	echom "cs_config not exists, create it"
	execute '!python ' . $HOME . '\\vimfiles\\cscope_tools.py -init'
endif

" cscope update command, will call the python script
" on windows or Linux
func! CscopeCmds(id, result)
	if has('win32')
		if a:result == 5
			execute '!python ' . $HOME . '\\vimfiles\\cscope_tools.py -update'
		elseif a:result == 7
			execute '!python ' . $HOME . '\\vimfiles\\cscope_tools.py -mkroot'
		elseif a:result == 3
			:cs add C:\\cscope_db\\cscope.out
		elseif a:result == 6
			execute '!python ' . $HOME . '\\vimfiles\\cscope_tools.py -chroot'
		elseif a:result == 4
			execute '!python ' . $HOME . '\\vimfiles\\cscope_tools.py -files'
		elseif a:result == 1
			:cs find s <cword>
		elseif a:result == 2
			:cs find t <cword>
		endif
	else
		" TODO
	endif
endfunc

func! CsPopup()
	call popup_menu([
				\ 'lookup symbol',
				\ 'lookup text',
				\ 'load', 
				\ 'select types',
				\ 'update',
				\ 'choose root',
				\ 'make as root', 
				\ ], 
				\ #{ title: "Cscope operations", callback: 'CscopeCmds', line: 25, col: 40, 
				\ highlight: 'Question', border: [], close: 'click',  padding: [1,1,0,1]} )
endfunc
nnoremap <leader>mm :call CsPopup()<CR>
nnoremap <leader>db :call CsPopup()<CR>

" add start tag
func! AddStartTag()
	let line_content = "// FIFA_BEGIN | DIVERGENCE | kenzhang | " . strftime("%Y-%m-%d")  . " | Reason: TODO"
	call append(line('.'), line_content)
	return 
endfunc
nnoremap <leader>ts :call AddStartTag()<CR>

" add end tag
func! AddEndTag()
	let line_content = "// FIFA_END"
	call append(line('.'), line_content)
	return 
endfunc
nnoremap <leader>te :call AddEndTag()<CR>
