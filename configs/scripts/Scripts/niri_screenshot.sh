#!/usr/bin/env sh

# Niri screenshot helper.
#  - Niri's built-in screenshot UI freezes the screen and lets you pick a region
#    or window. We use it for frozen modes (s, sf, w) via `niri msg action screenshot`.
#  - For non-interactive captures (full screen, focused monitor) and live region
#    selection we use grim/slurp.

if [ -z "$XDG_PICTURES_DIR" ]; then
	XDG_PICTURES_DIR="$HOME/Pictures"
fi

swpy_dir="${XDG_CONFIG_HOME:-$HOME/.config}/swappy"
save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
save_path="${save_dir}/${save_file}"
temp_screenshot="/tmp/screenshot.png"

mkdir -p "$save_dir"
mkdir -p "$swpy_dir"
# Make swappy save into our chosen dir/filename so its "Save" button matches niri's defaults.
printf '[Default]\nsave_dir=%s\nsave_filename_format=%s\n' "$save_dir" "$save_file" >"$swpy_dir/config"

print_error() {
	cat <<"EOF"
    ./niri_screenshot.sh <action>
    ...valid actions are...
        p  : print all outputs (full virtual screen)
        s  : snip a region (frozen, niri screenshot UI)
        sf : alias of s
        r  : snip a region (live, slurp + grim)
        m  : print focused monitor
        w  : screenshot focused window (frozen, niri UI)
EOF
}

notify_saved() {
	[ -f "$save_path" ] && notify-send -a "screenshot" -i "$save_path" "saved in $save_dir"
}

copy_clipboard() {
	wl-copy --type image/png <"$1"
}

focused_output() {
	niri msg --json focused-output 2>/dev/null | grep -oP '"name":\s*"\K[^"]+' | head -1
}

case "$1" in
p)
	grim "$temp_screenshot" &&
		swappy -f "$temp_screenshot" -o "$save_path" &&
		copy_clipboard "$save_path"
	;;
s | sf)
	# Niri's screenshot UI freezes the screen and lets you drag-select a region.
	# It writes to disk (screenshot-path) and copies to clipboard automatically.
	niri msg action screenshot
	exit $?
	;;
r)
	region=$(slurp) || exit 1
	grim -g "$region" "$temp_screenshot" &&
		swappy -f "$temp_screenshot" -o "$save_path" &&
		copy_clipboard "$save_path"
	;;
m)
	out=$(focused_output)
	if [ -n "$out" ]; then
		grim -o "$out" "$temp_screenshot"
	else
		grim "$temp_screenshot"
	fi
	swappy -f "$temp_screenshot" -o "$save_path" &&
		copy_clipboard "$save_path"
	;;
w)
	niri msg action screenshot-window
	exit $?
	;;
*)
	print_error
	exit 1
	;;
esac

rm -f "$temp_screenshot"
notify_saved
