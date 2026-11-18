# xmake Cheat Sheet

Nov 12, 2026

## Everyday commands

Run these from the folder that holds `xmake.lua`. Each one uses the configuration saved by the last `xmake f`.

| Command                               | What it does                                                        |
| ------------------------------------- | ------------------------------------------------------------------- |
| `xmake`                               | Build the default targets (downloads missing packages first)        |
| `xmake build <target>`                | Build one target                                                    |
| `xmake -r`                            | Rebuild everything from scratch                                     |
| `xmake -v`                            | Build and print every compile and link command                      |
| `xmake -vD`                           | Verbose plus full error detail, for when a build fails mysteriously |
| `xmake run`                           | Run the default binary target                                       |
| `xmake run <target> <args>`           | Run a specific target, passing it arguments                         |
| `xmake run -d`                        | Run under a debugger (gdb or lldb)                                  |
| `xmake test`                          | Build and run every test declared with `add_tests`                  |
| `xmake clean`                         | Delete build output for the current configuration                   |
| `rm -rf build .xmake`                 | Start completely fresh: build output plus saved configuration       |
| `xmake create -l c -t console <name>` | Make a new project skeleton (`-l c++` for C++)                      |
| `xmake update`                        | Update xmake itself                                                 |

Short forms: `xmake b` = build, `xmake r` = run, `xmake f` = config, `xmake c` = clean.

## Configuring with `xmake f`

`xmake f` (short for `xmake config`) saves your choices into `.xmake/`; it builds nothing. Every later `xmake`, `xmake run` and `xmake test` uses them until you configure again.

| Command                                      | What it sets                                                                |
| -------------------------------------------- | --------------------------------------------------------------------------- |
| `xmake f -m debug`                           | Build mode: `debug`, `release`, or any mode your `xmake.lua` defines        |
| `xmake f -p linux`                           | Platform: `linux`, `windows`, `macosx`, `mingw`, `android`, `wasm`, `cross` |
| `xmake f -a x86_64`                          | Architecture: `x86_64`, `arm64`, `wasm32` and so on                         |
| `xmake f -p wasm -m release`                 | Several at once                                                             |
| `xmake f -c`                                 | Clear the saved configuration and detect again                              |
| `xmake f --menu`                             | Interactive menu of every option                                            |
| `xmake f --help`                             | List every option `f` accepts, including your own `option()`s               |
| `xmake f --policies=build.sanitizer.address` | Turn on a policy from the command line                                      |
| `xmake show`                                 | Print the current platform, mode, toolchain and targets                     |
| `xmake g --pkg_searchdirs=/path`             | Global setting (`g`), applies to every project                              |

The configuration is sticky. If something behaves unexpectedly, run `xmake show` first: the usual cause is still being configured for another platform or mode.

## xmake.lua basics

Settings above any `target()` apply to every target; settings inside a target apply to that target only.

```lua
set_project("myapp")
set_version("0.1.0")
set_languages("gnu99")            -- or "c11", "c++20", "c++23"
set_warnings("all", "extra")      -- add "error" for -Werror
add_rules("mode.debug", "mode.release")

target("myapp")
    set_kind("binary")
    add_files("src/*.c")
    add_includedirs("include")
target_end()
```

**Target kinds** (`set_kind`)

| Kind         | Produces                                          |
| ------------ | ------------------------------------------------- |
| `binary`     | An executable                                     |
| `static`     | A static library (`.a`)                           |
| `shared`     | A shared library (`.so`)                          |
| `headeronly` | Nothing to compile; only exports include paths    |
| `phony`      | Nothing; a group of dependencies or a script hook |

**Common target settings**

| Setting              | Example                                                                              | Notes                                               |
| -------------------- | ------------------------------------------------------------------------------------ | --------------------------------------------------- |
| Source files         | `add_files("src/*.c", "src/**/*.c")`                                                 | `*` = one folder, `**` = recursive                  |
| Exclude a file       | `add_files("src/*.c\|main.c")`                                                       | Everything after `\|` is excluded                   |
| Include folders      | `add_includedirs("include")`                                                         | `{public = true}` passes it on to dependents        |
| Macros               | `add_defines("DEBUG_DRAW", "N=100")`                                                 | Becomes `-D...`                                     |
| Compiler flags       | `add_cflags("-fno-strict-aliasing")`                                                 | `add_cxxflags` for C++, `add_cxflags` for both      |
| Linker flags         | `add_ldflags("-sASYNCIFY", {force = true})`                                          | `force` skips xmake's flag check                    |
| Link libraries       | `add_links("m")`, `add_syslinks("pthread")`                                          | `syslinks` go last on the link line                 |
| Depend on a target   | `add_deps("mylib")`                                                                  | Builds and links `mylib` first                      |
| Optimisation         | `set_optimize("fastest")`                                                            | `none`, `fast`, `faster`, `fastest`, `smallest`     |
| Debug symbols        | `set_symbols("debug")`                                                               |                                                     |
| Output name          | `set_basename("app")`, `set_extension(".html")`                                      |                                                     |
| Not built by default | `set_default(false)`                                                                 | Still built by `xmake build <name>` or `xmake test` |
| Run settings         | `set_runargs("--fast")`, `set_rundir("$(projectdir)")`, `set_runenv("KEY", "value")` | Used by `xmake run`                                 |

**Conditions** work anywhere in the file: `if is_mode("debug") then ... end`, `is_plat("linux", "wasm")`, `is_arch("x86_64")`, `has_config("myoption")`.

**Loops**: `xmake.lua` is Lua, so `for _, f in ipairs(os.files("tests/test_*.c")) do target(path.basename(f)) ... end` makes one target per file.

## Packages

Declare a package once at the top with `add_requires`, then attach it to each target that uses it with `add_packages`. That one line adds its include paths, libraries and link flags.

```lua
add_requires("raylib", "fmt 11.x")

target("myapp")
    add_packages("raylib", "fmt")
```

**`add_requires` options**

| Need                                            | Write                                                          |
| ----------------------------------------------- | -------------------------------------------------------------- |
| Any version                                     | `add_requires("zlib")`                                         |
| A version range                                 | `add_requires("fmt 11.x")`, `"zlib >=1.2.11"`, `"libpng ~1.6"` |
| A git branch                                    | `add_requires("tbox master")`                                  |
| Always build from source, never the system copy | `add_requires("raylib", {system = false})`                     |
| Optional, build continues if missing            | `add_requires("libomp", {optional = true})`                    |
| Package build options                           | `add_requires("spdlog", {configs = {header_only = true}})`     |
| Shared instead of static                        | `add_requires("gflags", {configs = {shared = true}})`          |
| Another name in your file                       | `add_requires("foo", {alias = "myfoo"})`                       |
| Only on one platform                            | `add_requires("foo", {plat = "linux"})`                        |
| From vcpkg or conan                             | `add_requires("vcpkg::ffmpeg")`, `"conan::openssl/3.0.0"`      |

**Managing installed packages**

| Command                                     | What it does                                                        |
| ------------------------------------------- | ------------------------------------------------------------------- |
| `xrepo search raylib`                       | Find a package and its exact name                                   |
| `xrepo info raylib`                         | Versions, configs and supported platforms                           |
| `xmake require --list`                      | Packages this project uses, with versions                           |
| `xmake require --upgrade`                   | Upgrade this project's packages to the newest allowed versions      |
| `xrepo update-repo`                         | Refresh the local copy of the package repository                    |
| `set_policy("package.requires_lock", true)` | Write `xmake-requires.lock` so every machine gets the same versions |

Packages are cached in `~/.xmake/packages`, shared between projects. Installed packages never upgrade on their own.

**Defining your own package** in `xmake.lua`, for a library the repository lacks or doesn't support on your platform (this is the header-only raygui one from the sorting visualizer):

```lua
package("raygui_h")
    set_kind("library", {headeronly = true})
    add_urls("https://github.com/raysan5/raygui.git")
    add_versions("4.0", "4.0")   -- version -> git tag
    on_install(function (package)
        os.cp("src/raygui.h", package:installdir("include"))
    end)
package_end()

add_requires("raygui_h 4.0")
```

To upgrade a package defined this way, change the version in both places.

## Build modes and sanitizers

A mode is just a name chosen with `xmake f -m <name>`. `add_rules("mode.debug", "mode.release")` gives `debug` and `release` their standard settings; any other mode means only what your `is_mode` blocks say.

```lua
add_rules("mode.debug", "mode.release")
set_allowedmodes("debug", "release", "asan", "tsan")  -- typos become errors
set_defaultmode("debug")

if is_mode("asan") then
    set_symbols("debug")
    set_optimize("none")
    set_policy("build.sanitizer.address", true)
    set_policy("build.sanitizer.undefined", true)
    add_cflags("-fno-omit-frame-pointer", "-fno-sanitize-recover=undefined")
elseif is_mode("tsan") then
    set_symbols("debug")
    set_optimize("none")
    set_policy("build.sanitizer.thread", true)
end
```

| Policy                      | Sanitizer                                              |
| --------------------------- | ------------------------------------------------------ |
| `build.sanitizer.address`   | AddressSanitizer: out-of-bounds, use-after-free, leaks |
| `build.sanitizer.undefined` | UndefinedBehaviorSanitizer                             |
| `build.sanitizer.thread`    | ThreadSanitizer: data races (not with ASan)            |
| `build.sanitizer.leak`      | LeakSanitizer alone                                    |
| `build.sanitizer.memory`    | MemorySanitizer: uninitialised reads (clang only)      |

For a one-off run without editing the file: `xmake f --policies=build.sanitizer.address`.

**Runtime options** for sanitized programs:

- `ASAN_OPTIONS=detect_leaks=0 xmake run` turns leak checking off for one run.
- `set_runenv("LSAN_OPTIONS", "suppressions=...")` in a target applies a suppressions file on every `xmake run`.
- `setarch (uname -m) -R xmake run` disables address randomisation, which ThreadSanitizer needs on some kernels.

## Tests

Declare tests on a target with `add_tests` (xmake 2.8.5 or newer); `xmake test` builds and runs them all, even targets marked `set_default(false)`.

```lua
for _, file in ipairs(os.files("tests/test_*.c")) do
    target(path.basename(file))
        set_kind("binary")
        set_default(false)
        add_files(file)
        add_packages("unity_test")
        add_tests("default")
    target_end()
end
```

**`add_tests` options**

| Option              | Example                               | Effect                                        |
| ------------------- | ------------------------------------- | --------------------------------------------- |
| `runargs`           | `{runargs = {"foo", "bar"}}`          | Arguments passed to the test program          |
| `runenvs`           | `{runenvs = {LSAN_OPTIONS = "..."}}`  | Environment variables for the run             |
| `timeout`           | `{timeout = 5}`                       | Fail after this many seconds                  |
| `pass_outputs`      | `{pass_outputs = "hello foo"}`        | Pass only if the output matches (Lua pattern) |
| `fail_outputs`      | `{fail_outputs = {"ERROR", "FATAL"}}` | Fail if the output matches any of these       |
| `trim_output`       | `{trim_output = true}`                | Strip whitespace before matching output       |
| `build_should_fail` | `{build_should_fail = true}`          | Pass only if the target fails to compile      |

**Running**

| Command                          | Runs                                  |
| -------------------------------- | ------------------------------------- |
| `xmake test`                     | Every test                            |
| `xmake test test_sample/default` | One test of one target                |
| `xmake test test_sample/*`       | Every test of one target              |
| `xmake test */default`           | Tests with that name in every target  |
| `xmake test -v`                  | Every test, showing each one's output |
| `xmake test -vD`                 | Every test, with full failure detail  |

"nothing to test" means no target declares tests in the current configuration, often because you're configured for a platform where the test targets are skipped.

## Platforms and the web build

The platform is chosen with `xmake f -p <platform>`; packages follow it, so each platform gets its own package builds.

**Web (wasm) with Emscripten**

```fish
source ~/emsdk/emsdk_env.fish    # every new terminal, before any wasm command
xmake f -p wasm -m release
xmake
xmake f -p linux -m debug        # back to the desktop build
```

```lua
if is_plat("wasm") then
    set_extension(".html")
    add_defines("PLATFORM_WEB")
    add_ldflags("-sUSE_GLFW=3", "-sASYNCIFY", {force = true})
    add_values("wasm.preloadfiles", "assets/font.ttf")   -- bundle a file
end
```

Output lands in `build/wasm/wasm32/release/`. Serve it with `python3 -m http.server -d build/wasm/wasm32/release` and open the `.html` file; plain `file://` won't load the `.wasm`.

**Other platforms**

| Target                        | Command                                               |
| ----------------------------- | ----------------------------------------------------- |
| Native Linux                  | `xmake f -p linux`                                    |
| Windows from Linux (MinGW)    | `xmake f -p mingw`                                    |
| Android                       | `xmake f -p android --ndk=~/android-ndk -a arm64-v8a` |
| Any GCC/Clang cross toolchain | `xmake f -p cross --sdk=/path/to/toolchain`           |
| Choose compiler               | `xmake f --toolchain=clang` or `--cc=clang-18`        |

A package that doesn't support the chosen platform is reported as "unsupported on \<platform>" at configure time. Options: guard it with `if not is_plat(...)`, define your own package, or skip that feature on that platform.

## Editor integration and debugging

| Task                                                         | How                                                                                 |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------- |
| `compile_commands.json` for clangd, refreshed on every build | `add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})` in `xmake.lua` |
| Generate `compile_commands.json` once                        | `xmake project -k compile_commands`                                                 |
| Export a CMake project                                       | `xmake project -k cmakelists`                                                       |
| See the exact compile and link commands                      | `xmake -rv`                                                                         |
| Debug the program                                            | `xmake f -m debug`, then `xmake run -d <target>`                                    |
| Pick the debugger                                            | `xmake f --debugger=gdb`                                                            |
| Inspect the project                                          | `xmake show`, `xmake show -t <target>` for one target's flags and files             |
| Run a Lua snippet with xmake's APIs                          | `xmake l print(os.files("src/*.c"))`                                                |

**LazyVim completion for `xmake.lua`**: lazydev.nvim can load xmake's type definitions when a file named `xmake.lua` opens. Put this in `~/.config/nvim/lua/plugins/xmake.lua`:

```lua
return {
  { "LelouchHe/xmake-luals-addon", lazy = true },
  {
    "folke/lazydev.nvim",
    opts = function(_, opts)
      opts.library = opts.library or {}
      table.insert(opts.library, { path = "xmake-luals-addon/library", files = { "xmake.lua" } })
    end,
  },
}
```

This gives completion for `target`, `add_files` and similar; xmake-specific `os.` calls may still show warnings, which are safe to ignore.

## Troubleshooting

| Message                                                                    | Cause                                                                   | Fix                                                                                                               |
| -------------------------------------------------------------------------- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `attempt to call a nil value (global 'on_source')` in a repository package | xmake is older than the package repository expects; distro packages lag | Remove the apt package, install with `curl -fsSL https://xmake.io/shget.text \| bash`, add `~/.local/bin` to PATH |
| `emscripten not found!`                                                    | emsdk isn't active in this terminal                                     | `source ~/emsdk/emsdk_env.fish`, check with `emcc --version`                                                      |
| `packages are unsupported on wasm/wasm32`                                  | That package's recipe doesn't support the platform                      | Guard it with `is_plat`, or define your own package                                                               |
| `nothing to test`                                                          | No target declares tests in the current configuration                   | `xmake show`; reconfigure, e.g. `xmake f -p linux -m debug`                                                       |
| `fatal error: unity.h: No such file or directory`                          | The package installs its header in a subfolder                          | `find ~/.xmake/packages -name unity.h`, then include `<unity/unity.h>` or add that folder with `add_includedirs`  |
| `clone ... failed`                                                         | Network, a wrong URL, or a tag that doesn't exist                       | Rerun with `-v` to see the git error                                                                              |
| `warning: Ascend SDK not found`                                            | xmake probing for an AI-accelerator toolchain you don't use             | Harmless; ignore                                                                                                  |
| Changes to `xmake.lua` seem ignored, or odd stale behaviour                | Old saved configuration                                                 | `xmake f -c`, or `rm -rf build .xmake`                                                                            |

## Sources

- [Run tests](https://xmake.io/guide/basic-commands/run-tests.html)
- [Run targets](https://xmake.io/guide/basic-commands/run-targets.html)
- [Add packages](https://xmake.io/guide/project-configuration/add-packages.html)
- [Package dependencies API](https://xmake.io/api/description/package-dependencies.html)
- [Build policies](https://xmake.io/mirror/guide/build_policies.html)
- [WebAssembly example](https://xmake.io/examples/cpp/wasm.html)
- [lazydev.nvim](https://github.com/folke/lazydev.nvim)
