on run argv
  tell application "Music"
    stop
    set v_plt to 0
    if not (exists playlist "Unite") then
      --make playlist with properties {name:"Unite", special kind:"none"}
      activate
      display dialog "Make smartplaylist named 'Unite'" & return & return & "Rule is..." & return & "[Comments] [contains] [Unite]"
    else
      --delete tracks of playlist "Unite"
      set v_it to playlist "Unite"
      set v_plt to (count tracks of v_it)
      if exists tracks of v_it then
        repeat with h from 0 to (v_plt - 1)
          set v_words to comment of track (v_plt - h) of v_it
          set v_comment to do shell script "echo '" & v_words & "' | perl -pe 's/Unite//'"
          set (comment of track (v_plt - h) of v_it) to v_comment
          delay 0.15
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
    set l_dn to {1}
    set v_tn to 0
    set v_cdn to 1
    repeat with i in l_album
      if (disc number of i is not v_cdn) and (disc number of i is not in l_dn) then
        set l_dn to l_dn & disc number of i
        set v_cdn to disc number of i
        set v_cnt to (disc number of i) - 1
        set v_an to album of i
        set v_tn to 0
        repeat v_cnt times
          set l_tmp to (tracks whose album is v_an and disc number is v_cnt)
          set v_tn to v_tn + (track count of item 1 of l_tmp)
          set v_cnt to v_cnt - 1
        end repeat
      end if
      set l_idx to l_idx & track number of i
      set l_album_t to l_album_t & ""
    end repeat
    set v_cnt to 1
    repeat with j in l_idx
      --set item j of l_album_t to location of (item v_cnt of l_album)
      set item (contents of j) of l_album_t to (item v_cnt of l_album)
      set v_cnt to v_cnt + 1
    end repeat
    --add l_album_t to playlist "Unite"
    repeat with k in l_album_t
      set comment of k to (comment of k) & "Unite"
      delay 0.3
    end repeat
    delay (v_plt * 0.15) + ((count items of l_album_t) * 0.30) + 0.3
    reveal track 1 of playlist "Unite"
    play playlist "Unite"
  end tell
end run
