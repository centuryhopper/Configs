git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim

Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force

@REM nvim
@REM :LazyExtras and enable omnisharp, rust, and vscode
@REM use :checkhealth as needed
@REM set checker to false in lazy.lua and append vim.opt.wrap = true in options.lua
