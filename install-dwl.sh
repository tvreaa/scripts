#!/bin/sh
set -e

printf "which priv tool shall be used for this installation? ( sudo / doas ) > "
read tool

deps="git make gcc pkgconf wayland-protocols wlroots0.19 mako libinput libxkbcommon fcft tllist grim slurp wl-clipboard xorg-xwayland xcb-util-wm ttf-hack ttf-terminus-nerd wmenu awww foot xdg-utils"
aur_deps=""

repo="https://github.com/tvreaa/dwl"
dir="dwl"

$tool pacman -S --needed --noconfirm $deps

if command -v yay >/dev/null 2>&1; then
  yay -S --needed --noconfirm $aur_deps
elif command -v paru >/dev/null 2>&1; then
  paru -S --needed --noconfirm $aur_deps
else
  echo "no aur helper found skipping: $aur_deps" >&2
fi

git clone "$repo" "$dir"
cd "$dir"
$tool make clean install
cd ..
