#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"

if [ -t 1 ]; then exec fish; fi

export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
# should do export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 && mlnet for mlnet to work
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export PATH=$PATH:~/.dotnet/tools/
# Change working dir in shell to last dir in lf on exit (adapted from ranger).
#
# You need to either copy the content of this file to your shell rc file
# (e.g. ~/.bashrc) or source this file directly:
#
#     LFCD="/path/to/lfcd.sh"
#     if [ -f "$LFCD" ]; then
#         source "$LFCD"
#     fi
#
# You may also like to assign a key (Ctrl-O) to this command:
#
#     bind '"\C-o":"lfcd\C-m"'  # bash
#     bindkey -s '^o' 'lfcd\n'  # zsh
#

# maintains consistency with directory navigation when user is entering/exiting lf
lfcd() {
	tmp="$(mktemp)"
	# `command` is needed in case `lfcd` is aliased to `lf`
	command lf -last-dir-path="$tmp" "$@"
	if [ -f "$tmp" ]; then
		dir="$(cat "$tmp")"
		rm -f "$tmp"
		if [ -d "$dir" ]; then
			if [ "$dir" != "$(pwd)" ]; then
				cd "$dir"
			fi
		fi
	fi
}
