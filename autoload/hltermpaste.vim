" hltermpaste.vim - highlight pasted text in a terminal.
" Maintainer: https://github.com/ayosec/
" License: Apache-2.0

if exists("g:autoloaded_hltermpaste")
  finish
endif
let g:autoloaded_hltermpaste = 1

" start_paste() {{{
"
" Initialize state to track pasted text
function hltermpaste#start_paste()
  let b:hltermpaste_initial_pos = getpos(".")
  let b:hltermpaste_cancel_timer = timer_start(g:hltermpaste_timeout, function("s:cancelhighlight"))
endfunction
" }}}

" finish_paste() {{{
"
" Highlight the pasted text.
function hltermpaste#finish_paste()
  if !exists("b:hltermpaste_initial_pos")
    return
  endif

  let initial_pos = b:hltermpaste_initial_pos
  call s:cancelhighlight()
  call s:highlightregion(initial_pos, getpos("."))
endfunction
" }}}

" s:cancelhighlight() {{{
function s:cancelhighlight(...)
  if exists("b:hltermpaste_cancel_timer")
    call timer_stop(b:hltermpaste_cancel_timer)
    unlet b:hltermpaste_initial_pos
    unlet b:hltermpaste_cancel_timer
  endif
endfunction
" }}}

" s:highlightregion() {{{
"
" Highlight the text between initial_pos and end_pos. After the time specified
" in g:hltermpaste_timeout the highlight is removed.
function s:highlightregion(initial_pos, end_pos)
  let first_line = a:initial_pos[1]
  let last_line = a:end_pos[1]

  let highlight_ids = []
  let highlight_positions = []

  let l:line = first_line
  while l:line <= last_line
    " matchaddpos() is limited to 8 positions. If the pasted text needs more
    " than that, we need to make multiple calls to matchaddpos().
    if len(highlight_positions) == 8
      let id = matchaddpos(g:hltermpaste_match_group, highlight_positions)
      call add(highlight_ids, id)
      let highlight_positions = []
    endif

    let position = [l:line]

    " For both first and last lines we need to compute how many bytes are from
    " the pasted text.

    if l:line == first_line
      call extend(position, [a:initial_pos[2], &columns])
    endif

    if l:line == last_line
      if len(position) == 1
        call extend(position, [1, 0])
      endif

      let position[2] = a:end_pos[2] - position[1]
    endif

    call add(highlight_positions, position)
    let l:line += 1
  endwhile

  let id = matchaddpos(g:hltermpaste_match_group, highlight_positions)
  call add(highlight_ids, id)

  " Register a timer to remove the highlights.

  function! RemoveHighlights(...) closure
    for id in highlight_ids
      call matchdelete(id)
    endfor
  endfunction

  call timer_start(g:hltermpaste_timeout, funcref("RemoveHighlights"))

  " Store the highlight positions for the HighlightTermPasteVisual command.
  let b:hltermpaste_last_region = [b:changedtick, a:initial_pos, a:end_pos]
endfunction
" }}}

" HighlightTermPasteVisual command {{{
function <SID>VisualLastRegion()
  if !exists("b:hltermpaste_last_region")
    return
  endif

  if b:hltermpaste_last_region[0] != b:changedtick
    return
  endif

  call setpos("'<", b:hltermpaste_last_region[1])
  call setpos("'>", b:hltermpaste_last_region[2])
  normal gv
endfunction

command! -nargs=0 HighlightTermPasteVisual call <SID>VisualLastRegion()
" }}}

" vim: ts=8 sw=2 sts=2 noet fdm=marker
