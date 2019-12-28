on run argv as text
  set l_props to {}
  tell application "iTunes"
    set shuffle enabled to false
    if 2nd character of argv is not "|"
      set l_props to tracks of playlist argv
    else if 1st character of argv is "n"
      set v_sw to setSW(argv) of me
      set l_props to tracks whose artist contains v_sw
    else if 1st character of argv is "a"
      set v_sw to setSW(argv) of me
      set l_props to tracks whose album contains v_sw
    else if 1st character of argv is "y"
      set v_sw to setSW(argv) of me
      set l_props to tracks whose year = v_sw as integer and video kind of it is none
    else if 1st character of argv is ">" or 1st character of argv is "<" then
      set v_sw to setSW(argv) of me
      set v_td to AppleScript's text item delimiters
      set AppleScript's text item delimiters to "-"
      set l_t to text items of v_sw
      set AppleScript's text item delimiters to v_td
      set l_props to tracks whose duration >= (item 1 of l_t as number) * 60 and duration of it <= (item 2 of l_t as number) * 60 and video kind of it is none
    end if
    set v_temp to ""
    set l_data to ""
    set v_flag to 0
    repeat with i in l_props
      set v_s to ""
      if( class of i is shared track ) then
        if ( date added of i is missing value) then
          set v_s to "[S] "
        else
          set v_s to "[s] "
        end if
      end if
      set v_temp to v_s & name of i & tab & album of i & tab & artist of i & tab & track number of i & tab & argv & tab & id of i
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

on setSW(sw)
  set v_temp to text 3 thru end of sw
  set v_td to AppleScript's text item delimiters
  set AppleScript's text item delimiters to "_"
  set l_temp to text items of v_temp
  set AppleScript's text item delimiters to " "
  set v_temp to l_temp as string
  set AppleScript's text item delimiters to v_td
  return v_temp
end
