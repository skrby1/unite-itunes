on run argv
  tell application "Music"
    stop
    set v_plt to 0
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
          delay 0.20
        end repeat
      end if
    end if
    if (compilation of track id (item 3 of argv as integer)) is true then
      set l_album to tracks whose (album is item 1 of argv)
    else
      set l_album to tracks whose (album is item 1 of argv) and (artist contains item 2 of argv)
    end if
    set l_album_t to {}
    set l_idx to {0}
    set l_dn to {1}
    set v_tn to 0
    set v_cdn to 1
    repeat with i in l_album
      set v_dn to disc number of i
      if (v_dn is not v_cdn) and (v_dn is not in l_dn) then
        set l_dn to l_dn & v_dn
        set v_cdn to v_dn
        set v_cnt to v_dn - 1
        set v_an to album of i
        set v_tn to 0
        if item 1 of l_idx is not 0 then
          repeat (v_cdn - 1) times
            set l_tmp to (tracks whose album is v_an and disc number is v_cnt)
            set v_tn to v_tn + (track count of item 1 of l_tmp)
            set v_cnt to v_cnt - 1
          end repeat
        end if
      end if
      if item 1 of l_idx is 0 then
        set item 1 of l_idx to ((track number of i) + v_tn)
      else
        set l_idx to l_idx & ((track number of i) + v_tn)
      end if
      set l_album_t to l_album_t & ""
    end repeat
    set v_cnt to 1
    repeat with j in l_idx
      --set item j of l_album_t to location of (item v_cnt of l_album)
      set item (contents of j) of l_album_t to (item v_cnt of l_album)
      --set item v_cnt of l_album_t to (item v_cnt of l_album)
      set v_cnt to v_cnt + 1
    end repeat
    --add l_album_t to playlist "Vim-test"
    repeat with k in l_album_t
      set comment of k to (comment of k) & "Vim"
      delay 0.30
    end repeat
    delay (v_plt * 0.20) + ((count items of l_album_t) * 0.30) + 0.30
    reveal track 1 of playlist "Vim"
    play playlist "Vim"
  end tell
end run
