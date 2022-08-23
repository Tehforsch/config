launch () {
	nohup "$@" > /dev/null 2> /dev/null &
	disown
}
launch zathura "$@"
