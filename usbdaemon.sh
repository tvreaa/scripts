#!/bin/sh

udevadm monitor --udev --subsystem-match=usb --subsystem-match=input |
  while read -r dih; do
    case "$dih" in
      *UDEV*add*)
        notify-send "connected" "$dih"
        ;;
      *UDEV*remove*)
        notify-send "disconnected" "$dih"
        ;;
    esac
  done
