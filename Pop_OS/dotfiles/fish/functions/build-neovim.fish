function build-neovim --description 'Build/install latest stable neovim from source'
    set -l dir ~/.local/src/neovim

    sudo apt install -y ninja-build gettext unzip curl build-essential cmake; or return 1

    if test -d $dir
        git -C $dir fetch --tags --force; or return 1   # 'stable' is a moving tag
    else
        git clone https://github.com/neovim/neovim $dir; or return 1
    end

    git -C $dir checkout stable; or return 1
    make -C $dir distclean                              # required when the version changes
    make -C $dir CMAKE_BUILD_TYPE=RelWithDebInfo
    and sudo make -C $dir install
    or return 1

    nvim --version | head -1
end
