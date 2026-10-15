# GDB init — save as ~/.config/gdb/gdbinit (GDB 11+) or ~/.gdbinit

# ---------- General ----------
set confirm off
set pagination off
set verbose off

# Silence the "Enable debuginfod?" prompt on Ubuntu/Pop!_OS (flip to "on" if you want remote symbols)
set debuginfod enabled off

# Persistent, global command history
set history save on
set history size 10000
set history remove-duplicates unlimited
set history filename ~/.gdb_history

# ---------- Printing ----------
set print pretty on
set print object on
set print static-members off
set print vtbl on
set print demangle on
set print asm-demangle on
set print elements 200
set print null-stop on

# ---------- Disassembly ----------
set disassembly-flavor intel

# ---------- Project-local .gdbinit files ----------
# Uncomment and point at your projects folder to let GDB load a .gdbinit
# sitting next to your build:
# add-auto-load-safe-path ~/projects

# ---------- pwhat: type + value of an expression ----------
# Usage: pwhat EXPR
# Prints the static type, the underlying type (if it's a typedef/alias),
# the dynamic type (if polymorphic and different), the size, and the value.
# Written in Python so EXPR can contain spaces, e.g.  pwhat tree.root->left
python
import gdb

class PWhat(gdb.Command):
    """Print the type and value of an expression.
Usage: pwhat EXPR"""

    def __init__(self):
        super().__init__("pwhat", gdb.COMMAND_DATA, gdb.COMPLETE_EXPRESSION)

    def invoke(self, arg, from_tty):
        if not arg.strip():
            raise gdb.GdbError("usage: pwhat EXPR")

        val = gdb.parse_and_eval(arg)
        t = val.type

        print(f"type  = {t}")

        real = t.strip_typedefs()
        if str(real) != str(t):
            print(f"real  = {real}")

        try:
            dyn = val.dynamic_type
            if str(dyn) != str(t):
                print(f"dyn   = {dyn}")
        except gdb.error:
            pass

        try:
            print(f"size  = {t.sizeof} bytes")
        except gdb.error:
            pass

        try:
            print(f"value = {val.format_string(pretty_structs=True)}")
        except gdb.error as e:
            print(f"value = <unavailable: {e}>")

PWhat()
end

