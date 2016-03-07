# Save X11 preferences
# xrdb -merge ~/.Xresources

# Lock the screen after 10m inactivity
xautolock -time 10 -locker slock &>/dev/null &

# Redshift (for hurt less the eyes)
redshift -l '45.090157:7.672748' &>/dev/null &

## ssh-agent
# eval $(/usr/bin/killall ssh-agent; /usr/bin/ssh-agent)

# Clipboard Manager
clipmenud &

# Enable dual monitor
xrandr --output VGA1 --auto --right-of LVDS1

# Set background
feh --bg-scale ~/Immagini/Wallpapers/code-wallpaper-18.png

# Remove mouse cursor from screen after 1s inactivity
unclutter -root -idle 1 &

# run dropbox
dropbox start &>/dev/null &

# run davmail to connect to exchange SeatPG server
davmail &>/dev/null &

# remove caps lock
setxkbmap -layout it -variant us -option caps:escape

# Fix Java Apps
wmname LG3D
#AWT_TOOLKIT=MToolkit; export AWT_TOOLKIT

# Start `dwm` with a modified status bar
while true; do
	"${HOME}"/bin/dwm/dwm-tools/dwm-statusbar.sh
done &
