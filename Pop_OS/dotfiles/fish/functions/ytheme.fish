function ytheme
    if test (count $argv) -ne 1
        echo "Usage: ytheme <tokyo|everforest>"
        return 1
    end

    switch $argv[1]
        case tokyo tokyo-night
            set flavor tokyo-night

        case everforest everforest-medium
            set flavor everforest-medium

        case '*'
            echo "Unknown theme: $argv[1]"
            echo "Available: tokyo, everforest"
            return 1
    end

    set theme_file ~/.config/yazi/theme.toml

    mkdir -p ~/.config/yazi

    python3 -c '
import sys
from pathlib import Path

path = Path(sys.argv[1])
flavor = sys.argv[2]

text = path.read_text() if path.exists() else ""
lines = text.splitlines()

out = []

in_flavor = False
found_flavor = False
found_dark = False
found_light = False

for line in lines:
    stripped = line.strip()

    # Entering a new TOML section
    if stripped.startswith("[") and stripped.endswith("]"):

        # We are leaving [flavor], so add anything missing
        if in_flavor:
            if not found_dark:
                out.append(f"dark = \"{flavor}\"")

            if not found_light:
                out.append(f"light = \"{flavor}\"")

        in_flavor = stripped == "[flavor]"

        if in_flavor:
            found_flavor = True

        out.append(line)
        continue

    if in_flavor:
        if stripped.startswith("dark"):
            out.append(f"dark = \"{flavor}\"")
            found_dark = True
            continue

        if stripped.startswith("light"):
            out.append(f"light = \"{flavor}\"")
            found_light = True
            continue

    out.append(line)

# [flavor] was the final section in the file
if in_flavor:
    if not found_dark:
        out.append(f"dark = \"{flavor}\"")

    if not found_light:
        out.append(f"light = \"{flavor}\"")

# No [flavor] section existed at all
elif not found_flavor:
    if out and out[-1] != "":
        out.append("")

    out.extend([
        "[flavor]",
        f"dark = \"{flavor}\"",
        f"light = \"{flavor}\"",
    ])

path.write_text("\n".join(out) + "\n")
' "$theme_file" "$flavor"

    or return 1

    echo "Yazi theme → $flavor"
    echo "Restart Yazi to apply."
end
