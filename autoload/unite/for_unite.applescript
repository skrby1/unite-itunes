on run argv as text
  set l_props to {}
  tell application "Music"
    set l_props to playlists whose special kind is none
    set v_temp to ""
    set l_data to ""
    set v_flag to 0
    repeat with i in l_props
      set v_dur to duration of i
      set v_H to ((v_dur div 3600) as integer) as string
      set v_M to (((v_dur mod 3600) div 60) as integer) as string
      set v_S to ((v_dur mod 60) as integer) as string
      set v_temp to name of i & tab & v_H & ":" & v_M & ":" & v_S
      if v_flag = 0 then
        set l_data to v_temp
        set v_flag to 1
      else
        set l_data to l_data & return & v_temp
      end if
    end repeat
    l_data
  end tell
end run
