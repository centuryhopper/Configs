function newc --description 'Create include/<name>.h and src/<name>.c'
    python3 -c '
import sys
from pathlib import Path

if len(sys.argv) != 2:
    sys.exit("usage: newc <name>")

name = sys.argv[1]
header = Path("include") / f"{name}.h"
source = Path("src") / f"{name}.c"

for path in (header, source):
    if path.exists():
        sys.exit(f"newc: {path} already exists")

guard = "".join(c if c.isalnum() else "_" for c in name).upper() + "_H"

header.parent.mkdir(exist_ok=True)
source.parent.mkdir(exist_ok=True)
header.write_text(f"#pragma once\n#ifndef {guard}\n#define {guard}\n\n\n\n#endif\n")
source.write_text(f"#include \"{name}.h\"\n")
print(f"created {header} and {source}")
' $argv
end
