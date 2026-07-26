#!/bin/sh

#
# based dotfiles for those who hate hyprbloat ^_^
#

operationdir="$HOME" 
root="doas" # you may want to change doas with sudo
install="pacman -S --noconfirm"

# wm part
wmrepo="https://github.com/tvreaa/dwl" # my modified version of dwl, read config.h for binds and stuff
wmdir="$operationdir/dwl"
wmcompile="$root make clean install"
wmdeps="
git
gcc
pkgconf
make
wayland
wayland-protocols
tllist
wlroots0.19
libinput
libxkbcommon
fcft
xorg-xwayland
xcb-util-wm
ttf-hack
ttf-terminus-nerd
wmenu
xdg-utils
pixman
xdg-user-dirs
wl-clipboard
xcb-util-wm
libdrm
mesa
awww
"
installwmdeps(){
  $root $install $wmdeps
}

clonewmrepo(){
  git clone $wmrepo $wmdir
}

overwritewm(){
  $root rm -rf "$operationdir/dwl"
}

buildwm(){
  cd $wmdir
  $wmcompile
}

overwritewm
installwmdeps
clonewmrepo
buildwm

# dots
dotsrepo="https://github.com/tvreaa/dwl-dots"
dotsdir="$operationdir/dots"

clonedotsrepo(){
  git clone $dotsrepo $dotsdir
}

foot(){
  packages="foot"   
  conf="foot"
  moveconf="$HOME/.config/"
}
mako(){
  packages="mako"
  conf="mako"
  moveconf="$HOME/.config/"
}
dwlsh(){
  conf="dwl.sh" # greeters are bloat
  moveconf="$HOME"
}


overwritedots(){
  $root rm -rf "$dotsdir"
}
bmtxt(){
  cp "$dotsdir/bookmarks.txt" "$HOME/.config/" # based way of doing browser bookmarks
}
emojitxt(){
  cp "$dotsdir/emojis.txt" "$HOME/.config/"
}

overwritedots
clonedotsrepo
cd $dotsdir

mako
$root $install "$packages"
rm -rf "$HOME/.config/mako"
cp -r "$dotsdir/$conf" "$moveconf"

foot
$root $install "$packages"
rm -rf "$HOME/.config/foot"
cp -r "$dotsdir/$conf" "$moveconf"

dwlsh
cp "$dotsdir/$conf" "$moveconf"
chmod +x "$operationdir/dwl.sh"

bmtxt
emojitxt
clear
echo"run 'sh dwl.sh' and pray it works"

#
# gay
#
