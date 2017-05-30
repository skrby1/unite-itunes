on run argv as text
  tell application "iTunes"
    if not (exists playlist "Unite") then
      make playlist with properties {name:"Unite", special kind:"none"}
    else
      delete tracks of playlist "Unite"
    end if
    set l_album to tracks whose album is argv
    set l_idx to {}
    set l_album_t to {}
    repeat with i in l_album
      set l_idx to l_idx & track number of i
      set l_album_t to l_album_t & ""
    end repeat
    set v_cnt to 1
    repeat with j in l_idx
      set item j of l_album_t to location of (item v_cnt of l_album)
      set v_cnt to v_cnt + 1
    end repeat
    add l_album_t to playlist "Unite"
    play playlist "Unite"
  end tell
end run
