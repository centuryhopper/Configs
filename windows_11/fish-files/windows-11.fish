function notify
    powershell.exe -Command "Import-Module BurntToast; New-BurntToastNotification -Text '$argv[1]', '$argv[2]'"
end


alias shutdown='powershell.exe shutdown /s /t 0'
alias reboot='powershell.exe shutdown /r /t 0'
alias suspend='powershell.exe -Command "rundll32.exe powrprof.dll,SetSuspendState 0,1,0"'
alias open='explorer.exe .'
alias adb='/mnt/c/Android/platform-tools/adb.exe'
alias emulator '/mnt/c/Android/emulator/emulator.exe'
