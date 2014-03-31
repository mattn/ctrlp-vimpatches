if exists('g:loaded_ctrlp_vimpatches') && g:loaded_ctrlp_vimpatches
  finish
endif
let g:loaded_ctrlp_vimpatches = 1

let s:vimpatches_var = {
\  'init':   'ctrlp#vimpatches#init()',
\  'exit':   'ctrlp#vimpatches#exit()',
\  'accept': 'ctrlp#vimpatches#accept',
\  'lname':  'vimpatches',
\  'sname':  'vimpatches',
\  'type':   'path',
\  'sort':   0,
\  'nolim':   1,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:vimpatches_var)
else
  let g:ctrlp_ext_vars = [s:vimpatches_var]
endif

function! ctrlp#vimpatches#init()
  let res = webapi#http#get("http://vim-jp.herokuapp.com/patches/json?count=2000")
	let g:hoge = res
  let s:list = webapi#json#decode(res.content)
  return map(copy(s:list), 'v:val.title . " " . v:val.description')
endfunc

function! ctrlp#vimpatches#accept(mode, str)
  let link = filter(copy(s:list), 'stridx(a:str, v:val.title . " ")')[0]["link"]
  call ctrlp#exit()
  redraw!
  try
		call openbrowser#open(link)
  finally
  endtry
endfunction

function! ctrlp#vimpatches#exit()
  if exists('s:list')
    unlet! s:list
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#vimpatches#id()
  return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
