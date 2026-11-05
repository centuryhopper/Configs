import atexit, builtins, os, pprint, readline, sys

import pdb


class Config(pdb.DefaultConfig):
    sticky_by_default = True  # full-screen source view
    use_pygments = True
    truncate_long_lines = False


# ---------- Persistent history (gdb: set history save on) ----------
_hist = os.path.expanduser("~/.pdb_history")
try:
    readline.read_history_file(_hist)
except (FileNotFoundError, OSError):
    pass
readline.set_history_length(10000)
atexit.register(readline.write_history_file, _hist)


# ---------- pwhat: type + value of an expression ----------
def _pwhat(val):
    t = type(val)
    print(f"type  = {t.__module__}.{t.__qualname__}")
    mro = [c.__qualname__ for c in t.__mro__[1:-1]]
    if mro:
        print(f"bases = {' -> '.join(mro)}")
    print(f"size  = {sys.getsizeof(val)} bytes (shallow)")
    print("value = ", end="")
    pprint.pprint(val, width=100, compact=True)


builtins._pwhat = _pwhat  # reachable from any frame
