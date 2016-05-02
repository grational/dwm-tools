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
xrandr --auto
# xrandr --output VGA1 --auto --right-of LVDS1

# Set background
left_image=~/Immagini/Wallpapers/St.Louis-Gateway-Arc-Night.jpg
right_image=~/Immagini/Wallpapers/Hyatt-Terrazza.jpg
# third_image=~/Immagini/Wallpapers/Hyatt-Meeting-room.jpg
# old_image=~/Immagini/Wallpapers/code-wallpaper-18.png
feh --bg-scale "${left_image}" "${right_image}"
# Random per file
#feh --randomize --bg-scale ~/Immagini/Wallpapers/{St.Louis,Hyatt}*
# Random with dir
#feh --recursive --randomize --bg-scale ~/Immagini/Wallpapers/

# Remove mouse cursor from screen after 1s inactivity
unclutter -root -idle 1 &

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

# Start `dwm` with a modified status bar
UPDATE_PERIOD='15s'
while true; do
	"${HOME}"/bin/dwm/dwm-tools/dwm-statusbar.sh
  sleep "${UPDATE_PERIOD}"
done &
