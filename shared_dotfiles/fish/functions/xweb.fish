function xweb --description 'Build the web (wasm) version with xmake'
    source ~/emsdk/emsdk_env.fish >/dev/null 2>&1
    xmake f -p wasm -m release; and xmake
end
