" hltermpaste.vim - highlight pasted text in a terminal.
" Maintainer: https://github.com/ayosec/
" License: Apache-2.0

if exists("g:loaded_hltermpaste")
  finish
endif
let g:loaded_hltermpaste = 1

" Configuration {{{

" Time, in milliseconds, to keep the highlight on the pasted text.
if !exists("g:hltermpaste_timeout")
  let g:hltermpaste_timeout = 500
endif

" Highlight group for pasted text.
if !exists("g:hltermpaste_match_group")
  let g:hltermpaste_match_group = "IncSearch"
endif
" }}}

" autocommands {{{
augroup HighlightTermPaste
  autocmd!
  au OptionSet paste call <SID>PasteHandler()
augroup END
" }}}

" <SID>PasteHandler() {{{
"
" Invoked when the &paste value is modified.
"
" The highlight is cancelled if it exceeds more than g:hltermpaste_timeout.
function <SID>PasteHandler()
  let current_mode = mode()
  if current_mode != "n" && current_mode != "i"
    return
  endif

  if v:option_new == 1
    call hltermpaste#start_paste()
  else
    call hltermpaste#finish_paste()
  endif
endfunction
" }}}

" vim: ts=8 sw=2 sts=2 noet fdm=marker
