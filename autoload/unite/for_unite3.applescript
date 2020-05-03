on run argv
  tell application "Music"
    stop
    if not (exists playlist "Unite") then
      --make playlist with properties {name:"Unite", special kind:"none"}
      activate
      display dialog "Make smartplaylist named 'Unite'" & return & return & "Rule is..." & return & "[Comments] [contains] [Unite]"
    else
      --delete tracks of playlist "Unite"
      set v_plt to (count tracks of playlist "Unite")
      if exists tracks of playlist "Unite" then
        repeat with h from 0 to (v_plt - 1)
          set l_words to characters of comment of track (v_plt - h) of playlist "Unite"
          set v_cnt to (count items of l_words)
          set l_comment to {}
          repeat with i from 1 to v_cnt - 5
            set l_comment to l_comment & item i of l_words
          end repeat
          set (comment of track (v_plt - h) of playlist "Unite") to l_comment as string
        end repeat
      end if
    end if
    if (compilation of track id (item 3 of argv as integer)) is true then
      set l_album to tracks whose (album is item 1 of argv)
    else
      set l_album to tracks whose (album is item 1 of argv) and (artist is item 2 of argv)
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
    --add l_album_t to playlist "Unite"
    repeat with k in l_album_t
      set comment of k to (comment of k) & "Unite"
      delay 0.5
    end repeat
    delay 1.5
    play playlist "Unite"
  end tell
end run
