function build-mpv --description 'Build/update mpv (release) from source via mpv-build'
    set -l dir ~/.local/src/mpv-build

    sudo apt install -y git devscripts equivs; or return 1

    if test -d $dir
        git -C $dir pull --ff-only; or return 1
    else
        git clone https://github.com/mpv-player/mpv-build.git $dir; or return 1
    end

    pushd $dir
    ./use-mpv-release
    and ./use-ffmpeg-release
    and mk-build-deps -s sudo -i          # installs build dependencies
    and ./rebuild -j(nproc)               # also fetches latest sources
    and sudo ./install
    set -l st $status
    popd

    test $st -eq 0; and mpv --version | head -1
    return $st
end
