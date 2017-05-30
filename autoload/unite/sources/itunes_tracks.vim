let s:save_cpo = &cpo
set cpo&vim

let s:unite_itunes = {
  \ 'name': 'itunes_tracks',
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
  let t1 = str2nr(a:i1.source__track.tkno)
  let t2 = str2nr(a:i2.source__track.tkno)
  let a1 = a:i1.source__track.album
  let a2 = a:i2.source__track.album
  return a1 > a2 ? 1 : (a1 == a2 ? (t1 > t2 ? 1 : -1) : -1)
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
  if s:artist
    let l:v1 = substitute(a:candidate.action__play_name, "'", "'\"'\"'", 'g')
    let l:v1 = l:v1[4:]
  else
    let l:v1 = substitute(a:candidate.action__play_name, "'", "'\"'\"'", 'g')
    let l:v2 = substitute(a:candidate.action__play_plname, "'", "'\"'\"'", 'g')
    let l:v1 = l:v1[4:] . '" of playlist "' . l:v2
  endif
    call system('osascript -e ''tell app "iTunes" to play track "'.l:v1.'"'' &')
  redraw! | echo 'Play track "'. l:v1. '"'
endfunction

function! s:unite_itunes.action_table.play_s.func(candidate)
  let l:v1 = substitute(a:candidate.action__play_album, "'", "'\"'\"'", 'g')
  if a:candidate.action__play_name[0:2] != '[s]'
    call system('osascript -e ''tell app "iTunes" to set shuffle enabled to true''')
    call system('osascript '. expand("~/.vim/bundle/unite-itunes/autoload/unite/for_unite3.applescript"). " '". l:v1. "'")
    redraw! | echo 'Play album "'. l:v1. '" by shuffle'
  else
    exe 'UniteResume itunes_tracks'
    redraw! | echo "Sorry, Can't play shared track by album!"
  endif
endfunction

function! s:unite_itunes.action_table.play_a.func(candidate)
  let l:v1 = substitute(a:candidate.action__play_album, "'", "'\"'\"'", 'g')
  if a:candidate.action__play_name[0:2] != '[s]'
    call system('osascript '. expand("~/.vim/bundle/unite-itunes/autoload/unite/for_unite3.applescript"). " '". l:v1. "'")
    redraw! | echo 'Play album "'. l:v1. '"'
  else
    exe 'UniteResume itunes_tracks'
    redraw! | echo "Sorry, Can't play shared track by album!"
  endif
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
  let l:sys = "osascript ". expand("~/.vim/bundle/unite-itunes/autoload/unite/for_unite2.applescript"). " '". join(a:args, "|"). "' | perl -pe 's/\r/\n/g'"
  for l:playlists in split(system(l:sys), "\n")
    let l:v = split(l:playlists, "\t")
    call add(s:songs, {
    \ "name":   l:v[0],
    \ "album":  l:v[1],
    \ "artist": l:v[2],
    \ "tkno":   l:v[3],
    \ "argv":   l:v[4],
    \ })
  endfor
  return map(copy(s:songs), '{
  \ "word": v:val.name,
  \ "source": "itunes_tracks",
  \ "action__play_name": v:val.name,
  \ "action__play_album": v:val.album,
  \ "action__play_plname": v:val.argv,
  \ "source__track": v:val,
  \ }')
endfunction

call unite#custom_source('itunes_tracks', 'converters', 'converter_my_track')

function! unite#sources#itunes_tracks#define()
  return s:unite_itunes
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

