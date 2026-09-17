if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

#source ~/emsdk/emsdk_env.fish ^/dev/null

#status --is-interactive; and source ~/emsdk/emsdk_env.fish
#source ~/emsdk/emsdk_env.fish

set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

#set -gx DOTNET_ROOT /usr/bin/dotnet
#set -gx DOTNET_ROOT /usr/lib/dotnet

set -gx DOTNET_ROOT /home/leo_zhang/.dotnet
set -gx PATH $DOTNET_ROOT $PATH $DOTNET_ROOT/tools

set PATH $PATH ~/flutter_development/flutter/bin

#set -gx JAVA_HOME /opt/java/jdk-17.0.12+7
#set -gx PATH $JAVA_HOME/bin $PATH

set -gx PATH $PATH ~/android-sdk/platform-tools

set -gx ANDROID_HOME ~/android-sdk
set -gx PATH $PATH $ANDROID_HOME/platform-tools
set -gx PATH $PATH ~/android-sdk/cmdline-tools/latest/bin
set -gx PATH $PATH $ANDROID_HOME/emulator

set -gx VCPKG_ROOT ~/tools/vcpkg
set -gx PATH $PATH $VCPKG_ROOT

#set -gx PATH $HOME/vcpkg $PATH

#set -Ua fish_user_paths /home/leo_zhang/Documents/GitHub/Configs/Pop_OS/dotfiles/extras/scripts/
#
#set -Ua fish_user_paths /home/leo_zhang/Documents/GitHub/Tools/python_tools/utils/
#
#set -Ua fish_user_paths /home/leo_zhang/Documents/GitHub/Tools/rust_tools/utils/

#set -gx PATH $HOME/.local/share/fnm $PATH
#$HOME/.local/share/fnm/fnm env --use-on-cd | source

## Run fastfetch if session is interactive
#if status --is-interactive && type -q fastfetch
#    fastfetch
#end

if status is-interactive && not set -q TMUX
    exec tmux
end

set -x EDITOR /usr/bin/nvim
set -x PATH ~/.dotnet/tools/ $PATH
set -x PATH ~/.local/bin/ $PATH
set -x PATH ~/goroot/bin/ $PATH
set -x PATH ~/go/bin $PATH
#set -x PATH $(go env GOPATH)/bin/ $PATH
#set -x DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function rust_find
    cargo run --manifest-path=/home/leo_zhang/Documents/GitHub/Tools/rust_tools/file_management/Cargo.toml search $argv[1] $argv[2]
end

function suspend_at
    echo 'systemctl suspend' | sudo at $argv[1]
end

fish_add_path -g "/home/leo_zhang/.local/bin/"

fm6000 -c red -dog -o Pop!_OS -n -m 8 -g 12 -l 40

## Useful aliases

# Replace ls with exa
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias la='exa -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons' # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l.="exa -a | egrep '^\.'" # show only dotfiles
alias ip="ip -color"

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

alias bat='batcat'

# Replace some more things with better alternatives
alias cat='bat --style header --style snip --style changes --style header'
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

alias py='python3'
alias cls='clear'
alias dir='ls'
alias GITHUB='cd /home/leo_zhang/Documents/GitHub/'
alias ZOOM='/home/leo_zhang/.conda/envs/web_auto/bin/python /home/leo_zhang/Documents/GitHub/Zoom-Automation-Python/zoom_lecture_automations.py'
alias web_auto='/home/leo_zhang/.conda/envs/web_auto/bin/python'
alias NOTES='nvim /home/leo_zhang/Documents/GitHub/my_linux_configs/arch_linux_configs/arch_linux.txt'
alias JOBS='nvim /home/leo_zhang/Documents/GitHub/my_linux_configs/jobs_apps/applications.txt'
alias OPEN='xdg-open . &'
alias list='crontab -l'
alias edit='crontab -e'
alias JOURNAL='code /home/leo_zhang/Documents/GitHub/Journal/'
alias rm='rm -i'
# find files in current directory
alias IFIND='find . -iname'
# find directory within current directory
alias IFINDDIR='find . -type d -iname'
alias ACP='git add . && git commit -m"update" && git push'
alias SLEEP='systemctl suspend'
alias conf='nvim /home/leo_zhang/.config/hypr/hyprland.conf'
alias v='nvim'
alias tl='trash-list'
alias m='math'
alias birth='stat / | grep Birth'
alias ovpn='sudo openvpn ~/.vpn_stuff/us-free-11.protonvpn.net.udp.ovpn'
alias py='/home/leo_zhang/miniconda3/envs/web_auto/bin/python'
alias reset_bt="sudo rfkill unblock all && sudo rmmod btusb && sudo rmmod btintel && sudo modprobe btintel && sudo modprobe btusb"
alias flst='flatpak list --app --columns=name,size'
alias nightlight='echo "# From TTY (Ctrl+Alt+F3): Example: sudo drm_colortemp -d /dev/dri/card1 -t 3500"'

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias pbclear='xclip -selection clipboard /dev/null'

alias COUNT='ls -1 | wc -l'

set -x BROWSER /usr/bin/firefox
set -gx VISUAL nvim
# set -gx PATH $HOME/miniconda3/bin $PATH  # commented out by conda initialize
