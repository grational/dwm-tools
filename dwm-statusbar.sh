#!/bin/bash
set -euo pipefail

DBOX="$(dropbox status | head -n1 | cut -b1-3)"
if [[ "${DBOX}" == 'Dro' ]]; then
  DBOX='-'
else
  DBOX="${DBOX}."
fi
#WLAN="$(iwconfig wlan0 | grep -oP '(?<=ESSID:)("[^"]*"|\S*)' | tr -d '"')"
WLAN="$(nmcli device wifi list | sed -rn '1d; /^[*]/ s/ {2,}/;/gp' | awk -F';' '{print $2, $7}')"
# WLAN="$(iwconfig wlan0 | grep -oP '(?<=ESSID:")[^"]*')"
#VOL="$(amixer get Master | grep -oP 'off(?=\])|\d+%(?=.*\[on\])')"
VOL="$(pactl list sinks | perl -ne 'local $/; my $stdin = <>; print "$1" if ($stdin =~ /N[ao]me:\h+alsa_output.pci.*?Mut[eo]:\h+(?:off|no).*?Volume:.*?(\d+%)/s)')"
[[ ! $VOL ]] && VOL='off'
#VOL="$(amixer get Master | egrep -o '[0-9]+%')"
#VOL="$(amixer get Master | awk '/[0-9]+%/ { gsub(/[][]/,""); printf("%s",$4)  }')"
TEMP="$(grep -o '^[0-9][0-9]' /sys/class/thermal/thermal_zone0/temp)"
DATE="$(date '+%A, %d.%m.%Y %H:%M')"
LOAD=$(echo "$(cut -d' ' -f1 /proc/loadavg)*100" | bc | sed 's/\.[0-9]*//')
FREE_DATA=$(free -m | grep Mem | tr -s ' ')
CURRENT=$(echo "${FREE_DATA}" | cut -f3 -d' ')
TOTAL=$(echo "${FREE_DATA}" | cut -f2 -d' ')
MEM="$(echo "scale=2; ${CURRENT}/${TOTAL}*100" | bc | cut -f1 -d'.')"
CPU="$(ps -A -o pcpu | tail -n+2 | paste -sd+ | bc)"
HDD="$(df -lh | awk '{if ($6 == "/") { print $5 }}')"
PLAYER=$(dwmp --bar)
# Combine data
HEAD="WL: ${WLAN} | DBOX: ${DBOX} | CPU: ${CPU}% | MEM: ${MEM}% | LOAD: ${LOAD}% | HDD: ${HDD} | T: ${TEMP}C"
TAIL="VOL: ${VOL} | PL: ${PLAYER} | ${DATE}"
if acpi -a | grep off-line > /dev/null; then
  BAT="$(acpi -b | cut -d' ' -f4 | tr -d '%,')"
  xsetroot -name "${HEAD} | BAT: ${BAT}% | ${TAIL}"
  # Ask to suspend if lower than 10%
  if [[ $BAT -eq 10 ]] || [[ $BAT -lt 5 ]]; then
    if zenity --question --timeout 8 --text="Low battery ($BAT%). Suspend?"; then
      sudo pm-suspend
    fi
  fi
else
  xsetroot -name "${HEAD} | ${TAIL}"
fi
