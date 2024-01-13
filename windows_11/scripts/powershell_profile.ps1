Set-Alias -Name touch -Value New-Item
Set-Alias -Name v -Value nvim
Set-Alias -Name term -Value "C:\Users\leoth\Documents\GitHub\Tools\c#_tools\dotnet_terminal_filemanager\bin\Release\net8.0\dotnet_terminal_filemanager.exe"


# change User to Machine for system path
function Add-Path($Path) {
    $Path = [Environment]::GetEnvironmentVariable("PATH", "User") + [IO.Path]::PathSeparator + $Path
    [Environment]::SetEnvironmentVariable( "Path", $Path, "User" )
}

# Function to prompt for confirmation
function Confirm-Delete {
    param(
        [string]$Path
    )

    $confirmation = Read-Host "Are you sure you want to delete $Path? (Y/N)"

    if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
        Remove-Item -Path $Path -Force
        Write-Host "Deleted: $Path"
    } else {
        Write-Host "Deletion canceled."
    }
}

# Set alias for 'soft_del' to 'Confirm-Delete'
Set-Alias soft_del Confirm-Delete



