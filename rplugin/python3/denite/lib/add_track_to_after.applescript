on run argv
	tell application "Music"
		reveal track argv
	end tell
	tell application "System Events"
		tell process "Music"
			click menu item 6 of menu 1 of menu bar item 5 of menu bar 1
		end tell
	end tell
end run