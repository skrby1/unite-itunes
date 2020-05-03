# unite-itunes
  unite-itunes is a unite source that list up 
  name of songs, albums and artists
  in order to plays tracks in OSX "Music" App.

Limitation
-----
  this plugin is only fot OSX Catalina.

Requirements
-----
- [Unite](https://github.com/Shougo/unite.vim)

Install
-----

NeoBundle (write in your ~/.vimrc)

    NeoBundle "skrby1/unite-itunes"

In "Music" App

    1. Make Smart Playlist named "Unite"

    2. Choose [Edit Rules...] using context menu of Smart Playlist "Unite"

    3. Set rules to [Comments] [contains] "Unite"

    4. Push [OK] button.

    5. Set sort order of this smart playlist to [Track Number].

In your ~/.vimrc (Customize the key bindings as you like)

    autocmd FileType unite call s:unite_my_settings()
    function! s:unite_my_settings()
      let l:unite = unite#get_current_unite()
      if l:unite.buffer_name ==# 'itunes'
        nnoremap <silent><buffer><expr> <C-t> unite#do_action('enter_track')
        inoremap <silent><buffer><expr> <C-t> unite#do_action('enter_track')
        nnoremap <silent><buffer><expr> <C-s> unite#do_action('play_s')
        inoremap <silent><buf ui><expr> <C-s> unite#do_action('play_s')
      elseif l:unite.buffer_name ==# 'itunes_tracks'
        nnoremap <silent><buffer><expr> <BS>  unite#do_action('back')
        nnoremap <silent><buffer><expr> <C-s> unite#do_action('play_s')
        inoremap <silent><buffer><expr> <C-s> unite#do_action('play_s')
        nnoremap <silent><buffer><expr> <C-q> unite#do_action('play_a')
        inoremap <silent><buffer><expr> <C-q> unite#do_action('play_a')
      endif
    endfunction

Usage
-----

    :Unite -buffer-name=itunes itunes

      This lists up playlists.
      select one and press [return] or choose action [play],
      Then play a playlist selected by you.

      If you choose action [enter_track] ora press keybind attached
      [enter_track] that you wrote in .vimrc, Then another itunes_tracks list
      that contained tracks in a playlist selected by you is displayed.

      If you choose action [play_s] or press keybind attached [play_s], Then
      plays playlist selected by you in shuffle.


    :Unite -buffer-name=itunes itunes:!

      This plays a stopping track or stops a playing track.
      This behaves toggle.


    :Unite -buffer-name=itunes itunes:n:[NAME_OF_ARTIST]

      This list up tracks whose artist name is [NAME_OF_ARTIST].
      Select one and press [return] or choose action [play],
      Then it play a track.

      If you choose action [play_a] ot press keybind attached [play_a] that
      you wrote in ~/.vimrc,
      Then it plays the album that contains track selected by you.

      If you choose action [play_s] ot press keybind attached [play_s] that
      you wrote in ~/.vimrc,
      Then it plays the a;bum that contains track selected by you in shuffle.

      If you want insert [Space] in [NAMW_OF_ARTIST], Then you can use [_](under bar).
      Upper case or Lower case is ignored.
      [NAME_OF_ARTIST] does not have to enter complete words.

      ex) :Unite -buffer-name=itunes itunes:n:Aphex_twin


    :Unite -buffer-name=itunes itunes:a:[NAME_OF_ALBUM]

      This list up tracks whose album name is [NAME_OF_ALBUM].
      Behavior is same for [NAME_OF_ARTIST].

      ex) :Unite -buffer-name=itunes itunes:a:selected_ambient


    :Unite -buffer-name=itunes itunes:t:[TITLE_OF_SING]

      This list up tracks whose title of song is [TITLE_OF_SONG].
      Behavior is same for [NAME_OF_ARTIST].

      ex) :Unite -buffer-name=itunes itunes:t:come_to_daddy


    :Unite -buffer-name=itunes itunes:y:[YEAR_OF_RELEASE]

      This list up tracks whose year of release is [YEAR_OF_RELEASE].
      Behavior is same for [NAME_OF_ARTIST].

      ex) :Unite -buffer-name=itunes itunes:y:1978


    :Unite -buffer-name=itunes itunes:< or >:[MINIMUM_TIME]-[MAXIMUM_TIME]

      This list up tracks whose playing time is between [MINIMUM_TIME] and
      [MAXIMUM_TIME].
      Behavior is same for [NAME_OF_ARTIST].

      ex1) :Unite -buffer-name=itunes itunes:<:1.5-3.0
      This example lists up 90 ~ 180 sec songs.
      ex2) :Unite -buffer-name=itunes itunes:>:0-0.2
      This example lists up 0 ~ 12 sec songs.


Detailed usage
-----
[Please refer to this link](http://skrby1.com/?p=125)

License
----
MIT
