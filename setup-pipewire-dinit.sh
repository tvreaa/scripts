#!/bin/sh
set -e

printf "which priv tool shall be used for this installation? ( sudo / doas ) > "
read tool

deps="turnstile turnstile-dinit pipewire pipewire-dinit pipewire-pulse pipewire-pulse-dinit wireplumber wireplumber-dinit"

$tool pacman -S --needed --noconfirm $deps

$tool sed -i 's/^manage_rundir[[:space:]]*=.*/manage_rundir = yes/' /etc/turnstile/turnstiled.conf

$tool dinitctl enable turnstiled
$tool dinitctl restart turnstiled

echo "reboot or relogin then as your user run:"
echo""
echo "  dinitctl enable pipewire"
echo "  dinitctl enable pipewire-pulse"
echo "  dinitctl enable wireplumber"
