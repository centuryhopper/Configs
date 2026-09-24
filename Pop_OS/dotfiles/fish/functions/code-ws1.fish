function code-ws1 --description 'Open a path in VS Code and move its window to workspace 1'
    set -l target_path $argv[1]

    if test -z "$target_path"
        echo "Usage: code-ws1 <path>"
        return 1
    end

    if not test -e "$target_path"
        echo "Path does not exist: $target_path"
        return 1
    end

    # Launch VS Code
    code $target_path

    # Give the window a moment to actually appear before we try to move it.
    # Tweak this if VS Code takes longer to spawn a window on your machine.
    sleep 1

    # Move the newly opened VS Code window to workspace 1
    /home/leo_zhang/.cargo/bin/cos-cli move \
        -a code \
        -w 1 \
        --wait 20
end
