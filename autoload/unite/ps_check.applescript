on run
  tell application "System Events" to exists application process "Music"
  if result is false then
    tell application "Music"
      set shuffle enabled to false
    end tell
    set v_dir to (path to me)
    tell application "Finder"
      set v_dir to container of v_dir
    end tell
    set v_dir to POSIX path of (v_dir as alias)
    set v_shell to "perl " & v_dir & "ps_check.pl"
    set v_ps to do shell script v_shell

(*
    repeat
        tell application "System Events" to exists application process "iTunes"
        if result is true then exit repeat
        delay 1
    end repeat
  *)

    delay 6

(*
    tell application "Finder"
      activate
      tell application "System Events"
        key code 123 using {control down}
      end tell
    end tell
*)

    tell application v_ps
      activate
    end tell
  else
    tell application "Music"
      set shuffle enabled to false
    end tell
  end if
end run
