let s:save_cpo = &cpo
set cpo&vim

let s:unite_itunes = {
  \ 'name' : 'itunes',
  \ 'action_table' : {
  \   'play' : {
  \     'description' : 'plays current playlist'
  \   },
  \   'play_s' : {
  \     'description' : 'plays shuffle'
  \ },
  \   'enter_track' : {
  \     'description' : 'enter list of tracks of current playlist'
  \   },
  \ },
  \ 'hooks' : {},
  \ 'default_action' : 'play',
  \}
let s:songs = []

let s:uifilter = {'name': 'convert_my_track'}

function! s:uifilter.filter(candidates, context)
  let format = "%*S - %-9s"
  for candidate in a:candidates
    let pl = candidate.source__pl
    let candidate.word = printf(format, -1 * (float2nr(winwidth(0) * 0.8)), pl.name, pl.dur)
  endfor
  return a:candidates
endfunction

call unite#define_filter(s:uifilter)
unlet s:uifilter

function! unite#sources#itunes#toggle() abort
  call system('osascript -e ''tell app "Music" to playpause'' &')
endfunction

function! s:unite_itunes.action_table.play.func(candidate)
  let l:v1 = substitute(a:candidate.action__play_name, "'", "'\"'\"'", 'g')
  call system('osascript -e ''tell app "Music" to play playlist "'.l:v1.'"'' &')
  redraw! | echo 'Play playlist "'. l:v1. '"'
endfunction

function! s:unite_itunes.action_table.play_s.func(candidate)
  call system('osascript -e ''tell app "Music" to set shuffle enabled to true''')
  let l:v1 = substitute(a:candidate.action__play_name, "'", "'\"'\"'", 'g')
  call system('osascript -e ''tell app "Music" to play playlist "'.l:v1.'"'' &')
  redraw! | echo 'Play playlist "'. l:v1. '" by shuffle'
endfunction
function! s:play_s(context)
  echo a:context
  "call system('osascript -e ''tell app "Music" to set shuffle enabled to true''')
  "let l:v1 = substitute(a:candidate.action__play_name, "'", "'\"'\"'", 'g')
  "call system('osascript -e ''tell app "Music" to play playlist "'.l:v1.'"'' &')
  "redraw! | echo 'Play playlist "'. l:v1. '" by shuffle'
endfunction

function! s:unite_itunes.action_table.enter_track.func(candidate)
  exe "Unite -buffer-name=tracks tracks:". escape(a:candidate.action__play_name, ' :')
endfunction

let s:filepath = expand("<sfile>:p:h:h")
function! s:unite_itunes.hooks.on_init(args, context)
  call system('osascript '. s:filepath . '/ps_check.applescript')
  if len(a:args) != 0
    if a:args[0] == '!'
      call unite#sources#itunes#toggle()
    elseif a:args[0] == 'a' || a:args[0] == 'n' || a:args[0] == 'y' || a:args[0] == 't' || a:args[0] == '>' || a:args[0] == '<'
      exe "Unite -buffer-name=tracks tracks:". join(a:args, ":")
    endif
  endif
endfunction

function! s:unite_itunes.gather_candidates(args, context) abort
  let s:songs = []
  let l:sys = 'osascript '. s:filepath . '/for_unite.applescript'. ' | perl -pe "s/\r/\n/g"'
  for l:playlists in split(system(l:sys), "\n")
    let l:v = split(l:playlists, "\t")
    call add(s:songs, {
    \ "name": l:v[0],
    \ "dur":  l:v[1],
    \ })
  endfor
  return map(copy(s:songs), '{
  \ "word": v:val.name,
  \ "source": "itunes",
  \ "action__play_name": v:val.name,
  \ "source__pl": v:val,
  \ }')
endfunction

call unite#custom_source('itunes', 'converters', 'convert_my_track')

"autocmd FileType denite call s:itunes_my_settings()
"call denite#custom#action("source/unite", "play_s", function('s:play_s'))
"call denite#custom#action("source/unite", "enter_track", function('s:enter_track'))
"function! s:itunes_my_settings() abort
  "if denite#get_status('buffer_name') ==# 'itunes'
"    nnoremap <silent><buffer><expr> s denite#do_map('do_action', 'play_s')
    "nnoremap <silent><buffer><expr> t denite#do_map('do_action', 'enter_track')
  "endif
"endfunction

function! unite#sources#itunes#define()
  return s:unite_itunes
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
