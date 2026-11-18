function install-llvm --argument-names ver --description 'Install clang/clangd/clang-format/clang-tidy <ver> from apt.llvm.org'
    if test -z "$ver"
        echo "usage: install-llvm <version>   (newest stable is listed on apt.llvm.org)"
        return 1
    end

    set -l tmp (mktemp)
    wget -qO $tmp https://apt.llvm.org/llvm.sh; or return 1
    sudo bash $tmp $ver # clang, clangd, lld, lldb
    and sudo apt install -y clang-format-$ver clang-tidy-$ver
    or begin
        rm -f $tmp
        return 1
    end
    rm -f $tmp

    # packages only install versioned binaries (clang-21 etc.); point the plain names at them
    for tool in clang clang++ clangd clang-format clang-tidy
        sudo update-alternatives --install /usr/bin/$tool $tool /usr/bin/$tool-$ver 100
    end

    clang --version | head -1
    clangd --version | head -1
end
funcsave install-llvm
