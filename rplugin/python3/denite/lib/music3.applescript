on run argv
  tell application "Music"
    stop
    (*
    if not (exists user playlist "Vim-test") then
      make user playlist with properties {name:"Vim-test"}
      if exists (user playlist "Vim" whose smart is true) then
        activate
        display dialog "Please delete a smart playlist \"Vim\"" & return & "Don't forget delete comment \"Vim\" of tracks" & return & " in smart playlist \"Vim\""
      end if
    else
      delete tracks of user playlist "Vim-test"
    end if
    *)
    if not exists playlist "Vim" then
      --make playlist with properties {name:"Vim", special kind:"none"}
      activate
      display dialog "Make smartplaylist named 'Vim'" & return & return & "Rule is..." & return & "[Comments] [contains] [Vim]"
    else
      --delete tracks of playlist "Vim"
      set v_it to playlist "Vim"
      set v_plt to (count tracks of v_it)
      if exists tracks of v_it then
        repeat with h from 0 to (v_plt - 1)
          set v_words to comment of track (v_plt - h) of v_it
          set v_comment to do shell script "echo '" & v_words & "' | perl -pe 's/Vim//'"
          set (comment of track (v_plt - h) of v_it) to v_comment
          delay 0.1
        end repeat
      end if
    end if
    if (compilation of track id (item 3 of argv as integer)) is true then
      set l_album to tracks whose (album is item 1 of argv)
    else
      set l_album to tracks whose (album is item 1 of argv) and (artist contains item 2 of argv)
    end if
    set l_album_t to {}
    set l_idx to {}
    repeat with i in l_album
      set l_idx to l_idx & track number of i
      set l_album_t to l_album_t & ""
    end repeat
    set v_cnt to 1
    repeat with j in l_idx
      --set item j of l_album_t to location of (item v_cnt of l_album)
      set item (contents of j) of l_album_t to (item v_cnt of l_album)
      set v_cnt to v_cnt + 1
    end repeat
    --add l_album_t to playlist "Vim-test"
    repeat with k in l_album_t
      set comment of k to (comment of k) & "Vim"
      delay 0.3
    end repeat
    delay 2.0
    play playlist "Vim"
  end tell
end run
