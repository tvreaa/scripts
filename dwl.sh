#!/bin/sh

# desktop portal wlr
/usr/lib/xdg-desktop-portal-wlr &
sleep 0.5
/usr/lib/xdg-desktop-portal &

# mako
mako &

# dwl
exec dbus-run-session dwl
