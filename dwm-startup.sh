# If this is not dwm exit from the script
# ( or as an alternative test:
# if grep -q dwm <<<$XDG_DATA_DIRS; then... )
if [[ "${GDMSESSION}" != 'dwm' ]]; then
  return 0
fi

# Save X11 preferences
# xrdb -merge ~/.Xresources

# Lock the screen after 10m inactivity
xautolock -time 10 -locker slock &>/dev/null &

# Redshift (to hurt less the eyes)
# redshift -l '45.090157:7.672748' &>/dev/null &

## ssh-agent
# eval $(/usr/bin/killall ssh-agent; /usr/bin/ssh-agent)

# Clipboard Manager
# clipmenud &

# Enable dual monitor
xrandr --auto
# xrandr --output VGA1 --auto --right-of LVDS1

# set custom wallpapers
"${HOME}"/bin/wallpaper-refresh

# Remove mouse cursor from screen after 1s inactivity
unclutter -root -idle 1 &

# Run timidity in pulseaudio-compatible mode (mostly to use vkeyboard)
#$ if [ -z "$(pgrep timidity)" ]; then
#if ! pgrep timidity &>/dev/null; then
#timidity -iA -Os --background &>/dev/null
#fi

# run dropbox
dropbox start &>/dev/null &

# run davmail to connect to exchange SeatPG server
davmail &>/dev/null &

# remove caps lock
setxkbmap -layout it -variant us -option caps:escape

## Fix Java Apps
wmname LG3D # Pretend to be another window manager
# Use motif toolkit for java applications
#AWT_TOOLKIT=MToolkit; export AWT_TOOLKIT
# Use env var to tell java that it's inside a non reparenting WM
# _JAVA_AWT_WM_NONREPARENTING=1; export _JAVA_AWT_WM_NONREPARENTING

# Start Music Player Daemon, conf=~/.mpdconf
if ! pgrep mpd &>/dev/null; then
  mpd
fi

# Start `dwm` with a modified status bar
UPDATE_PERIOD='15s'
while true; do
	"${HOME}"/bin/dwm/dwm-tools/dwm-statusbar.sh
  sleep "${UPDATE_PERIOD}"
done &
