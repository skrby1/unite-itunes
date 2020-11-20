let s:save_cpo = &cpo
set cpo&vim

let s:unite_itunes = {
  \ 'name': 'tracks',
  \ 'is_listed' : 0,
  \ 'action_table' : {
  \   'play' : {
  \     'description' : 'plays current track'
  \   },
  \   'play_s' : {
  \     'description' : 'plays shuffle current album'
  \   },
  \   'play_a' : {
  \     'description' : 'plays current album'
  \   },
  \   'back' : {
  \     'description' : 'back Unite itunes'
  \   },
  \ },
  \ 'default_action' : 'play',
  \ }
let s:songs = []
let s:artist = 0

let s:uifilter = {'name': 'converter_my_track'}

function! s:Sort1(i1, i2)
  let id1 = a:i1.source__track.id
  let id2 = a:i2.source__track.id
  "let t1 = str2nr(a:i1.source__track.tkno)
  "let t2 = str2nr(a:i2.source__track.tkno)
  let n1 = a:i1.source__track.artist
  let n2 = a:i2.source__track.artist
  let a1 = a:i1.source__track.album
  let a2 = a:i2.source__track.album
  return a1 > a2 ? 1 : (a1 == a2 ? (n1 > n2 ? 1 : (n1 == n2 ? (id1 > id2 ? 1 : -1) : -1)) : -1)
endfunction

function! s:uifilter.filter(candidates, context)
  let format = "%*.*S - %*.*S - %*.*S"
  let l:f1 = float2nr(winwidth(0) * 0.365)
  let l:f2 = float2nr(winwidth(0) * 0.345)
  let l:f3 = float2nr(winwidth(0) * 0.205)
  if s:artist
    let l:sorted = sort(a:candidates, "<SID>Sort1")
  else
    let l:sorted = a:candidates
  endif
  for candidate in l:sorted
    let track = candidate.source__track
    let candidate.word = printf(format, -1 * l:f1, l:f1, track.name, -1 * l:f2, l:f2, track.album, -1 * l:f3, l:f3, track.artist)
  endfor
  return l:sorted
endfunction

call unite#define_filter(s:uifilter)
unlet s:uifilter

function! s:unite_itunes.action_table.play.func(candidate)
  let l:v1 = substitute(a:candidate.action__play_name, "'", "'\"'\"'", 'g')
  let l:v1 = substitute(l:v1, '^\[[sS]] ', '', '')
  let l:v2 = substitute(a:candidate.action__play_plname, "'", "'\"'\"'", 'g')
  let l:v3 = a:candidate.action__play_id
  if !s:artist
    let l:v1 = l:v1 . '" of playlist "' . l:v2
    call system('osascript -e ''tell app "Music" to play track id '.l:v3.' of playlist "'.l:v2.'"'' &')
  else
    call system('osascript -e ''tell app "Music" to play track id '.l:v3.''' &')
  endif
  let l:v1 = substitute(l:v1, "'\"'\"'", "'", '')
  redraw! | echo 'Play track "'. l:v1. '"'
endfunction

let s:filepath = expand("<sfile>:p:h:h")
function! s:unite_itunes.action_table.play_s.func(candidate)
  let l:v1 = substitute(a:candidate.action__play_album, "'", "'\"'\"'", 'g')
  let l:v2 = a:candidate.action__play_artist
  let l:v3 = a:candidate.action__play_id
  "if a:candidate.action__play_name[0:2] != '[s]'
  call system('osascript -e ''tell app "Music" to set shuffle enabled to true''')
  call system('osascript '. s:filepath . '/for_unite3.applescript'. " '". l:v1. "' '". l:v2. "' '". l:v3. "'")
  let l:v1 = substitute(l:v1, "'\"'\"'", "'", 'g')
  redraw! | echo 'Play album "'. l:v1. '" by shuffle'
  "else
    "exe 'UniteResume tracks'
    "redraw! | echo "Sorry, Can't play shared track as album!"
  "endif
endfunction

function! s:unite_itunes.action_table.play_a.func(candidate)
  let l:v1 = substitute(a:candidate.action__play_album, "'", "'\"'\"'", 'g')
  let l:v2 = a:candidate.action__play_artist
  let l:v3 = a:candidate.action__play_id
  call system('osascript '. s:filepath . '/for_unite3.applescript'. " '". l:v1. "' '". l:v2. "' '". l:v3. "'")
  let l:v1 = substitute(l:v1, "'\"'\"'", "'", 'g')
  redraw! | echo 'Play album "'. l:v1. '"'
endfunction

function! s:unite_itunes.action_table.back.func(candidate)
  if s:artist
    exe 'UniteClose'
  else
    exe 'Unite -buffer-name=itunes itunes'
  endif
endfunction

function! s:unite_itunes.gather_candidates(args, context) abort
  let s:songs = []
  let s:artist = 0
  let s:pl = a:args[0]
  if len(a:args) > 1
    let s:artist = 1
  endif
  let l:sys = "osascript ". s:filepath . '/for_unite2.applescript'. " '". join(a:args, "|"). "' | perl -pe 's/\r/\n/g'"
  for l:playlists in split(system(l:sys), "\n")
    let l:v = split(l:playlists, "\t")
    call add(s:songs, {
    \ "name":   l:v[0],
    \ "album":  l:v[1],
    \ "artist": l:v[2],
    \ "tkno":   l:v[3],
    \ "id":     l:v[4],
    \ "argv":   l:v[5],
    \ })
  endfor
  return map(copy(s:songs), '{
  \ "word": v:val.name,
  \ "source": "tracks",
  \ "action__play_name": v:val.name,
  \ "action__play_album": v:val.album,
  \ "action__play_artist": v:val.artist,
  \ "action__play_id": v:val.id,
  \ "action__play_plname": v:val.argv,
  \ "source__track": v:val,
  \ }')
endfunction

call unite#custom_source('tracks', 'converters', 'converter_my_track')

function! unite#sources#tracks#define()
  return s:unite_itunes
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

