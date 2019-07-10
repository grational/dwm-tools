#!/bin/bash
set -euo pipefail

vpn_status () {
	vpnc_pid="$(pgrep pppd)"
	[ "$vpnc_pid" ] && echo up || echo down
}

interval() {
	local start_date="$(date -u -d "${1}" +"%s")"
	local final_date="$(date -u -d "${2}" +"%s")"
	date -u -d "0 ${final_date} sec -${start_date} sec" +"%T"
}

pomodoro_time="$(atq | head -n1 | cut -d' ' -f4)"
if [[ -z $pomodoro_time ]]; then
	POMO='-'
else
	current_time="$(date +%T)"
	POMO="$(interval "${current_time}" "${pomodoro_time}")"
fi

DBOX="$(dropbox status | head -n1 | cut -b1-3)"
if [[ "${DBOX}" == 'Dro' ]]; then
	DBOX='-'
else
	DBOX="${DBOX}."
fi
#WLAN="$(iwconfig wlan0 | grep -oP '(?<=ESSID:)("[^"]*"|\S*)' | tr -d '"')"
# WLAN="$(iwconfig wlan0 | grep -oP '(?<=ESSID:")[^"]*')"
WLAN="$(nmcli device wifi list | sed -rn '1d; /^[*]/ s/ {2,}/;/gp' | awk -F';' 'END{if (NR) {sub(/-.*$/, "", $2); print $2, $7;} else print "-" }')"
VPN="$(vpn_status)"
#VOL="$(amixer get Master | grep -oP 'off(?=\])|\d+%(?=.*\[on\])')"
VOL="$(pactl list sinks | perl -ne 'local $/; my $stdin = <>; print "$1" if ($stdin =~ /N[ao]me:\h+alsa_output.pci.*analog(?:.(?!\n\n))*?Mut[eo]:\h+(?:off|no).*?Volume:.*?(\d+%)/s)')"
[[ ! $VOL ]] && VOL='🔇' || VOL="🔊 ${VOL}"
#VOL="$(amixer get Master | egrep -o '[0-9]+%')"
#VOL="$(amixer get Master | awk '/[0-9]+%/ { gsub(/[][]/,""); printf("%s",$4)  }')"
TEMP="$(grep -o '^[0-9][0-9]' /sys/class/thermal/thermal_zone0/temp)"
DATE="$(date '+%a, %d.%m.%Y %H:%M')"
LOAD=$(echo "$(cut -d' ' -f1 /proc/loadavg)*100" | bc | sed 's/\.[0-9]*//')
FREE_DATA=$(free -m | grep Mem | tr -s ' ')
CURRENT=$(echo "${FREE_DATA}" | cut -f3 -d' ')
TOTAL=$(echo "${FREE_DATA}" | cut -f2 -d' ')
MEM="$(echo "scale=2; ${CURRENT}/${TOTAL}*100" | bc | cut -f1 -d'.')"
CPU="$(ps -A -o pcpu | tail -n+2 | paste -sd+ | bc)"
HDD="$(df -lh | awk '{if ($6 == "/") { print $5 }}')"
PLAYER=$(dwmp --bar)
if [[ $PLAYER == mpd ]]; then PROGRESS="$(mpc status | grep -oP '\d+:\d+/\d+:\d+')"; PLAYER="${PLAYER} ${PROGRESS}"; fi
# Combine data
HEAD=" 📶 $WLAN"
separator='   '
[[ $POMO != - ]] && HEAD="${HEAD}${separator}🍅 ${POMO}"
[[ $VPN == up ]] && HEAD="${HEAD}${separator}🔒 ${VPN}"
[[ $DBOX != - ]] && HEAD="${HEAD}${separator}🎁 ${DBOX}"
HEAD="${HEAD}${separator}⛋ ${CPU}%${separator}⛼ ${MEM}%${separator}⛃ ${LOAD}%${separator}💽 ${HDD}${separator}🌡️ ${TEMP}C"
TAIL="${VOL}"; [[ $PLAYER != - ]] && TAIL="${TAIL}${separator}► ${PLAYER}"; TAIL="${TAIL}${separator}🗓️  ${DATE}"
if acpi -a | grep off-line > /dev/null; then
	BAT="$(acpi -b | cut -d' ' -f4 | tr -d '%,')"
	xsetroot -name "${HEAD}${separator}🔋 ${BAT}%${separator}${TAIL}"
	# Ask to suspend if lower than 10%
	if [[ $BAT -le 10 ]]; then
		xsetroot -name "LOW BATTERY! ${BAT}%"
	elif [[ $BAT -le 3 ]]; then
		systemctl suspend
	fi
else
	xsetroot -name "${HEAD}${separator}${TAIL}"
fi
