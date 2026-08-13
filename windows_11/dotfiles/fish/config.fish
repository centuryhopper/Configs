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

fish_add_path -g "~/.local/bin/"

fm6000 -c red -dog -o Ubuntu -n -m 8 -g 12 -l 40

## Useful aliases

# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | egrep '^\.'" # show only dotfiles
alias ip="ip -color"

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

#alias bat='batcat'

# Replace some more things with better alternatives
alias cat='bat --style header --style snip --style changes --style header'
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

alias py='python3'
alias cls='clear'
alias dir='ls'
alias list='crontab -l'
alias edit='crontab -e'
alias JOURNAL='code /home/leo_zhang/Documents/GitHub/Journal/'
alias rm='rm -i'
alias ACP='git add . && git commit -m"update" && git push'
alias SLEEP='systemctl suspend'
alias conf='nvim /home/leo_zhang/.config/hypr/hyprland.conf'
alias v='nvim'
alias tl='trash-list'
alias m='math'
alias birth='stat / | grep Birth'

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias pbclear='xclip -selection clipboard /dev/null'

alias shutdown='powershell.exe shutdown /s /t 0'
alias reboot='powershell.exe shutdown /r /t 0'
alias suspend='powershell.exe -Command "rundll32.exe powrprof.dll,SetSuspendState 0,1,0"'
alias open='explorer.exe .'
alias adb='/mnt/c/Android/platform-tools/adb.exe'
alias emulator '/mnt/c/Android/emulator/emulator.exe'
# Device management
alias adbdevices 'adb devices -l'
alias adbroot 'adb root'
alias adbreboot 'adb reboot'

# Common shell operations
alias adbshell 'adb shell'
alias adblogcat 'adb logcat'

# App management
alias adbinstall 'adb install'
alias adbuninstall 'adb uninstall'

# Screenshots
alias adbscreenshot 'adb exec-out screencap -p > screenshot.png'
alias r='ranger'

function wsl_code
    code --remote wsl+Ubuntu "$PWD"
end

# activate mise
mise activate fish | source

zoxide init fish | source

set -gx VISUAL nvim

function notify
    powershell.exe -Command "Import-Module BurntToast; New-BurntToastNotification -Text '$argv[1]', '$argv[2]'"
end

set -x LF_ICONS "\
di=📁:\
fi=📃:\
tw = 🤝:\
ow = 📂:\
ln = ⛓:\
or = ❌:\
ex = 🎯:\
*.txt	=✍:\
*.mom	=✍:\
*.me	=✍:\
*.ms	=✍:\
*.avif	=🖼:\
*.png	=🖼:\
*.webp	=🖼:\
*.ico	=🖼:\
*.jpg	=📸:\
*.jpe	=📸:\
*.jpeg	=📸:\
*.gif	=🖼:\
*.svg	=🗺:\
*.tif	=🖼:\
*.tiff	=🖼:\
*.xcf	=🖌:\
*.html	=🌎:\
*.xml	=📰:\
*.gpg	=🔒:\
*.css	=🎨:\
*.pdf	=📚:\
*.djvu	=📚:\
*.epub	=📚:\
*.csv	=📓:\
*.xlsx	=📓:\
*.tex	=📜:\
*.md	=📘:\
*.r	    =📊:\
*.R	    =📊:\
*.rmd	=📊:\
*.Rmd	=📊:\
*.m	    =📊:\
*.mp3	=🎵:\
*.opus	=🎵:\
*.ogg	=🎵:\
*.m4a	=🎵:\
*.flac	=🎼:\
*.wav	=🎼:\
*.mkv	=🎥:\
*.mp4	=🎥:\
*.webm	=🎥:\
*.mpeg	=🎥:\
*.avi	=🎥:\
*.mov	=🎥:\
*.mpg	=🎥:\
*.wmv	=🎥:\
*.m4b	=🎥:\
*.flv	=🎥:\
*.zip	=📦:\
*.rar	=📦:\
*.7z	=📦:\
*.tar	=📦:\
*.z64	=🎮:\
*.v64	=🎮:\
*.n64	=🎮:\
*.gba	=🎮:\
*.nes	=🎮:\
*.gdi	=🎮:\
*.1	    =ℹ:\
*.nfo	=ℹ:\
*.info	=ℹ:\
*.log	=📙:\
*.iso	=📀:\
*.img   =📀:\
*.bib   =🎓:\
*.ged   =👪:\
*.part  =💔:\
*.torrent = 🔽:\
*.jar   = ♨:\
*.java	= ♨:\
*.rs=:\
*.c=:\
*.cc=:\
*.cpp=:\
*.py=:\
*.cs=:\
"

set -x LF_COLORS "\
~/Documents=01;31:\
~/Downloads=01;31:\
~/.local/share=01;31:\
~/.config/lf/lfrc=31:\
.git/=01;32:\
.git*=32:\
*.gitignore=32:\
*Makefile=32:\
README.*=33:\
*.txt=34:\
*.md=34:\
ln=01;36:\
di=01;34:\
ex=01;32:\
"

function ranger --description 'Ranger that cds into last visited dir on exit'
    # Temporary file to store last directory
    set -l tmp (mktemp)

    # Launch ranger with choosedir pointing to temp file
    command ranger --choosedir="$tmp" $argv

    # If the temp file exists and has a valid directory, cd into it
    if test -f "$tmp"
        set -l dir (string trim (cat "$tmp"))
        rm -f $tmp
        if test -d "$dir"
            cd "$dir"
        end
    end
end
