#!/bin/sh

outdir="$HOME/vids"
fps=30
crf=18
preset=ultrafast
abitrate=128k
msg_start="started"
msg_pause="paused"
msg_resume="resumed"
msg_stop="saved"
msg_already="already recording"
msg_nothing="not recording"
menu_fn_x11="Hack:size=12"
menu_fn_wl="Hack 12"
menu_nb="222222"
menu_nf="bbbbbb"
menu_sb="BEB58F"
menu_sf="222222"
menu_lines=5
pidfile=/tmp/rec.pid
pausefile=/tmp/rec.paused
outfile=/tmp/rec.out

mkdir -p "$outdir"

if [ -n "$WAYLAND_DISPLAY" ]; then
	session=wayland
else
	session=x11
fi

notify() { notify-send "rec" "$1"; }

menu() {
	if [ "$session" = wayland ]; then
		wmenu -f "$menu_fn_wl" -N "$menu_nb" -n "$menu_nf" -M "$menu_nb" -m "$menu_nf" -S "$menu_sb" -s "$menu_sf" -l "$menu_lines" -p "$1"
	else
		dmenu -fn "$menu_fn_x11" -nb "#$menu_nb" -nf "#$menu_nf" -sb "#$menu_sb" -sf "#$menu_sf" -l "$menu_lines" -p "$1"
	fi
}

if [ -f "$pausefile" ]; then
	status="paused:"
	choices="continue\nstop"
elif [ -f "$pidfile" ]; then
	status="recording:"
	choices="start\npause\nstop"
else
	status="not recording:"
	choices="start\npause\nstop"
fi

choice=$(printf "$choices" | menu "$status") || exit 0

case "$choice" in
	start)
		[ -f "$pidfile" ] && { notify "$msg_already"; exit 1; }
		f="$outdir/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"
		echo "$f" > "$outfile"
		if [ "$session" = wayland ]; then
			sink=$(pactl get-default-sink).monitor
			wf-recorder -f "$f" -r "$fps" -c libx264 -p preset="$preset" -p crf="$crf" --audio="$sink" \
				> /tmp/rec.log 2>&1 &
		else
			res=$(xrandr | awk '/\*/{print $1; exit}')
			sink=$(pactl get-default-sink).monitor
			ffmpeg -f x11grab -framerate "$fps" -video_size "$res" -i "$DISPLAY" \
				-f pulse -i "$sink" \
				-c:v libx264 -preset "$preset" -crf "$crf" -pix_fmt yuv420p \
				-c:a aac -b:a "$abitrate" \
				"$f" > /tmp/rec.log 2>&1 &
		fi
		echo $! > "$pidfile"
		notify "$msg_start → $(basename "$f")"
		;;
	pause)
		[ -f "$pidfile" ] || { notify "$msg_nothing"; exit 1; }
		kill -STOP "$(cat "$pidfile")"
		touch "$pausefile"
		notify "$msg_pause"
		;;
	continue)
		[ -f "$pausefile" ] || { notify "not paused"; exit 1; }
		kill -CONT "$(cat "$pidfile")"
		rm -f "$pausefile"
		notify "$msg_resume"
		;;
	stop)
		[ -f "$pidfile" ] || { notify "$msg_nothing"; exit 1; }
		[ -f "$pausefile" ] && { kill -CONT "$(cat "$pidfile")"; rm -f "$pausefile"; }
		kill -INT "$(cat "$pidfile")"
		rm -f "$pidfile"
		notify "$msg_stop → $(basename "$(cat "$outfile")")"
		rm -f "$outfile"
		;;
esac
