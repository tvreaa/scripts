#!/bin/sh

            # automated setup script for my suckelss programs
            # this programs are designed to work with github.com/tvreaa/suckless-dots dotfiles
            # but for now this script only installs suckless programs.


OperationDir="$HOME"
root="sudo"
repo="https://github.com/tvreaa/suckless" # git repo for my suckless programs
compile="$root make clean install"

RemoveExisting(){
  rm -r "$OperationDir/suckless"
}

clone(){
  git clone "$repo" "$OperationDir/suckless"
  printf "%s" "[log] cloned repo in $OperationDir/suckless"
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

  printf "%s" "[log] compilation complete"
}

RemoveExisting
clone
build
printf "%s" "[log] installation complete"
