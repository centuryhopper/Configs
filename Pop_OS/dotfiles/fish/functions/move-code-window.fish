function move-code-window --description 'Move the VS Code window whose title contains TEXT to a workspace'
    set -l match $argv[1]
    set -l ws $argv[2]

    if test -z "$match" -o -z "$ws"
        echo "Usage: move-code-window <title-text> <workspace>"
        return 1
    end

    # Poll for up to 20 seconds, since VS Code sets its title shortly after opening
    for i in (seq 20)
        set -l idx (~/.cargo/bin/cos-cli info --json | jq -r --arg m "$match" '
            .apps[]
            | select(.app_id | test("code"; "i"))
            | select(.title | contains($m))
            | .index' | head -n 1)

        if test -n "$idx"
            ~/.cargo/bin/cos-cli move -i $idx -w $ws
            return
        end
        sleep 1
    end

    echo "No VS Code window with '$match' in its title" >&2
    return 1
end
