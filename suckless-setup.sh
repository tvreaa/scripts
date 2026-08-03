#!/bin/sh

            # automated setup script for my suckelss programs
            # this programs are designed to work with github.com/tvreaa/suckless-dots dotfiles
            # but for now this script only installs suckless programs.



root="sudo" # you may want to change this to doas

# you may want to change xlibre-xserver with xorg-server if its not in your repo
# also change install command and package names according to your distribution 
deps="gcc pkgconf make git libx11 libxft libxinerama xorg-xinit xlibre-xserver xclip maim"
install="$root pacman -S --needed --noconfirm $deps"

OperationDir="$HOME"
repo="https://github.com/tvreaa/suckless" # git repo for my suckless programs
compile="$root make clean install"

InstallDeps(){
  $install
}

RemoveExisting(){
  rm -rf "$OperationDir/suckless"
}

clone(){
  git clone "$repo" "$OperationDir/suckless"
  printf "%s\n" "[log] cloned repo in $OperationDir/suckless"
}

build(){
  cd "$OperationDir/suckless"

  cd "dwm"
  $compile
  cd ..

  cd "st"
  $compile
  cd .. 

  cd "dwmblocks"
  $compile
  cd ..

  cd "dmenu"
  $compile

  cd "$OperationDir"

  printf "%s\n" "[log] compilation complete"
}

InstallDeps
RemoveExisting
clone
build
printf "%s\n" "[log] installation complete"
