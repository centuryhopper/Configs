function update-scrcpy
    set -l url (curl -s https://api.github.com/repos/Genymobile/scrcpy/releases/latest \
        | grep -o 'https://[^"]*scrcpy-linux-x86_64[^"]*\.tar\.gz' | head -1)
    or begin; echo "couldn't find release"; return 1; end

    rm -rf ~/.local/opt/scrcpy
    mkdir -p ~/.local/opt/scrcpy ~/.local/bin
    curl -L $url | tar -xz -C ~/.local/opt/scrcpy --strip-components=1
    ln -sf ~/.local/opt/scrcpy/scrcpy ~/.local/bin/scrcpy
    scrcpy --version
end
