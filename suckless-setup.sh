#!/bin/sh

operationdir="$HOME"
root="doas"
install="pacman -S --noconfirm"
sucklessrepo="https://github.com/tvreaa/suckless"
sucklessdir="$operationdir/suckless"
DirDwm="$operationdir/suckless/dwm"
DirSt="$operationdir/suckless/st"
DirDwmblocks="$operationdir/suckless/dwmblocks"
DirDmenu="$operationdir/suckless/dmenu"
compile="$root make clean install"
# you may want to change xlibre-xserver with xorg-server if its not avaiable in your repo
wmdeps="
gcc
pkgconf
make
xlibre-xserver
xorg-xinit
libxinerama
libxft
ttf-hack
ttf-terminus-nerd
"
installsucklessdeps(){
  $root $install $wmdeps
}

clonesuckless(){
  git clone $sucklessrepo "$sucklessdir"
}

overwritesuckless(){
  $root rm -rf "$sucklessdir"
}

buildsuckless(){
  cd $DirDwm
  $compile
  cd $DirSt
  $compile
  cd $DirDwmblocks
  $compile
  cd $DirDmenu
  $compile
}

overwritesuckless
installsucklessdeps
clonesuckless
buildsuckless

# dots
dotsrepo="https://github.com/tvreaa/suckless-dots"
dotsdir="$operationdir/dots"

clonedots(){
  git clone $dotsrepo $dotsdir
}
overwritedots(){
  $root rm -rf $dotsdir
}
dunst(){
  packages="dunst"
  conf="$dotsdir/dunst"
  moveconf="$HOME/.config/"
  overwrite="$HOME/.config/dunst"
}
bookmarkstxt(){
  conf="$dotsdir/bookmarks.txt"
  overwrite="$HOME/.config/bookmarks.txt"
  moveconf="$HOME/.config/" 
}
emojistxt(){
  conf="$dotsdir/emojis.txt"
  moveconf="$HOME/.config/"
  overwrite="$HOME/.config/emojis.txt"
}

overwritedots
clonedots

dunst
$root $install $packages
rm -rf $overwrite
cp -r $conf $moveconf

bookmarkstxt
rm -rf $overwrite
cp $conf $moveconf

emojistxt
rm -rf $overwrite
cp $conf $moveconf

clear
echo "done!! we didnt setup your xinit script tho, do it yourself:>"
