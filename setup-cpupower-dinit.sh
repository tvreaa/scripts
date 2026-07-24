#!/bin/sh
set -e

printf "which priv tool shall be used for this installation? ( sudo / doas ) > "
read tool

deps="cpupower cpupower-dinit"

$tool pacman -S --needed --noconfirm $deps

$tool sh -c "echo governor=performance > /etc/default/cpupower"

$tool dinitctl enable cpupower || true
$tool dinitctl restart cpupower || true
echo "reboot may be required to take effect"
