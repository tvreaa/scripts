#!/bin/sh

while :
do
  echo "1) kernel.yama.ptrace_scope = 1 | kernel.unprivileged_userns_clone = 1  this will fix electron and some flatpak apps:)"
	echo "2) kernel.yama.ptrace_scope = 2 | kernel.unprivileged_userns_clone = 0  "
	echo "4) exit"
	printf "> "
	read x
	case "$x" in
		1)
			sudo sysctl -w kernel.yama.ptrace_scope=1
			sudo sysctl -w kernel.unprivileged_userns_clone=1
			;;
		2)
			sudo sysctl -w kernel.yama.ptrace_scope=2
			sudo sysctl -w kernel.unprivileged_userns_clone=0
			;;	
		4) exit ;;
		*) echo "invalid option" ;;
	esac
done
