if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

set -gx DOTNET_ROOT /usr/bin/dotnet

set -gx DOTNET_ROOT /home/leo_zhang/.dotnet
set -gx PATH $DOTNET_ROOT $PATH $DOTNET_ROOT/tools


set PATH $PATH ~/flutter_development/flutter/bin


set -gx JAVA_HOME /opt/java/jdk-17.0.12+7/
set -gx PATH $JAVA_HOME/bin $PATH

set -gx PATH $PATH ~/android-sdk/platform-tools

set -gx ANDROID_HOME ~/android-sdk
set -gx PATH $PATH $ANDROID_HOME/platform-tools
set -gx PATH $PATH ~/android-sdk/cmdline-tools/latest/bin

set -Ua fish_user_paths /home/leo_zhang/Documents/GitHub/Configs/Pop_OS/dotfiles/extras/scripts/

set -Ua fish_user_paths /home/leo_zhang/Documents/GitHub/Tools/python_tools/utils/

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
set -x PATH $(go env GOPATH)/bin/ $PATH
#set -x DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function rust_find
    cargo run --manifest-path=/home/leo_zhang/Documents/GitHub/Tools/rust_tools/file_management/Cargo.toml search $argv[1] $argv[2]
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
alias lf='lfcd'
alias l=lf
alias lfconf='nvim ~/.config/lf/lfrc'
alias tl='trash-list'
alias m='math'
alias birth='stat / | grep Birth'
alias ovpn='sudo openvpn ~/.vpn_stuff/us-free-11.protonvpn.net.udp.ovpn'
alias py='/home/leo_zhang/miniconda3/envs/web_auto/bin/python'
alias reset_bt="sudo rfkill unblock all && sudo rmmod btusb && sudo rmmod btintel && sudo modprobe btintel && sudo modprobe btusb"

set -x BROWSER /usr/bin/firefox
set -gx VISUAL nvim
# set -gx PATH $HOME/miniconda3/bin $PATH  # commented out by conda initialize



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/leo_zhang/miniconda3/bin/conda
    eval /home/leo_zhang/miniconda3/bin/conda "shell.fish" hook $argv | source
end
# <<< conda initialize <<<
# fi=:\


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

# needed so that directory navigation is consistent in and out of lf
function lfcd
    set tmp (mktemp)
    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -last-dir-path=$tmp $argv
    if test -f "$tmp"
        set dir (cat $tmp)
        rm -f $tmp
        if test -d "$dir"
            if test "$dir" != (pwd)
                cd $dir
            end
        end
    end
end



# lf icons
#set -x LF_ICONS "\
#tw=:\
#st=:\
#ow=:\
#dt=:\
#di=:\
#fi=:\
#ln=:\
#or=:\
#ex=:\
#*.c=:\
#*.cc=:\
#*.clj=:\
#*.coffee=:\
#*.cpp=:\
#*.css=:\
#*.d=:\
#*.dart=:\
#*.erl=:\
#*.exs=:\
#*.fs=:\
#*.go=:\
#*.h=:\
#*.hh=:\
#*.hpp=:\
#*.hs=:\
#*.html=:\
#*.java=:\
#*.jl=:\
#*.js=:\
#*.json=:\
#*.lua=:\
#*.md=:\
#*.php=:\
#*.pl=:\
#*.pro=:\
#*.py=:\
#*.rb=:\
#*.rs=:\
#*.scala=:\
#*.ts=:\
#*.vim=:\
#*.cmd=:\
#*.ps1=:\
#*.sh=:\
#*.bash=:\
#*.zsh=:\
#*.fish=:\
#*.tar=:\
#*.tgz=:\
#*.arc=:\
#*.arj=:\
#*.taz=:\
#*.lha=:\
#*.lz4=:\
#*.lzh=:\
#*.lzma=:\
#*.tlz=:\
#*.txz=:\
#*.tzo=:\
#*.t7z=:\
#*.zip=:\
#*.z=:\
#*.dz=:\
#*.gz=:\
#*.lrz=:\
#*.lz=:\
#*.lzo=:\
#*.xz=:\
#*.zst=:\
#*.tzst=:\
#*.bz2=:\
#*.bz=:\
#*.tbz=:\
#*.tbz2=:\
#*.tz=:\
#*.deb=:\
#*.rpm=:\
#*.jar=:\
#*.war=:\
#*.ear=:\
#*.sar=:\
#*.rar=:\
#*.alz=:\
#*.ace=:\
#*.zoo=:\
#*.cpio=:\
#*.7z=:\
#*.rz=:\
#*.cab=:\
#*.wim=:\
#*.swm=:\
#*.dwm=:\
#*.esd=:\
#*.jpg=:\
#*.jpeg=:\
#*.mjpg=:\
#*.mjpeg=:\
#*.gif=:\
#*.bmp=:\
#*.pbm=:\
#*.pgm=:\
#*.ppm=:\
#*.tga=:\
#*.xbm=:\
#*.xpm=:\
#*.tif=:\
#*.tiff=:\
#*.png=:\
#*.svg=:\
#*.svgz=:\
#*.mng=:\
#*.pcx=:\
#*.mov=:\
#*.mpg=:\
#*.mpeg=:\
#*.m2v=:\
#*.mkv=:\
#*.webm=:\
#*.ogm=:\
#*.mp4=:\
#*.m4v=:\
#*.mp4v=:\
#*.vob=:\
#*.qt=:\
#*.nuv=:\
#*.wmv=:\
#*.asf=:\
#*.rm=:\
#*.rmvb=:\
#*.flc=:\
#*.avi=:\
#*.fli=:\
#*.flv=:\
#*.gl=:\
#*.dl=:\
#*.xcf=:\
#*.xwd=:\
#*.yuv=:\
#*.cgm=:\
#*.emf=:\
#*.ogv=:\
#*.ogx=:\
#*.aac=:\
#*.au=:\
#*.flac=:\
#*.m4a=:\
#*.mid=:\
#*.midi=:\
#*.mka=:\
#*.mp3=:\
#*.mpc=:\
#*.ogg=:\
#*.ra=:\
#*.wav=:\
#*.oga=:\
#*.opus=:\
#*.spx=:\
#*.xspf=:\
#*.pdf=:\
#*.nix=:\
#"
