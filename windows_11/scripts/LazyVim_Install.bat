git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim

Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force

@REM nvim
@REM :LazyExtras and enable omnisharp, python, and clangd
@REM use :checkhealth as needed
@REM set checker to false in lazy.lua and append vim.opt.wrap = true in options.lua

@REM "lazyvim.plugins.extras.formatting.prettier",
@REM "lazyvim.plugins.extras.lang.clangd",
@REM "lazyvim.plugins.extras.lang.omnisharp",
@REM "lazyvim.plugins.extras.lang.python",
@REM "lazyvim.plugins.extras.lang.yaml"
