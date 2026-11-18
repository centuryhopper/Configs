function emsdk-update --description 'Install or update Emscripten (emsdk)'
    set -l dir ~/emsdk
    if not test -d $dir
        git clone https://github.com/emscripten-core/emsdk.git $dir; or return 1
    else
        git -C $dir pull; or return 1
    end
    $dir/emsdk install latest; and $dir/emsdk activate latest; or return 1
    $dir/upstream/emscripten/emcc --version | head -1
end
