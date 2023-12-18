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
