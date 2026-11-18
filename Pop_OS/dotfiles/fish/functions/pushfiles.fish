function pushfiles --description 'Push files to an Android phone and add them to the gallery'
    # usage: pushpics <serial> <files...>
    if test (count $argv) -lt 2
        echo "usage: pushpics <serial> <files...>"
        return 1
    end

    set serial $argv[1]
    set files $argv[2..-1]
    set dest /sdcard/Pictures/Pushed

    adb -s $serial shell mkdir -p $dest
    or return 1

    for file in $files
        set name (basename $file)
        adb -s $serial push $file $dest/
        or continue
        # tell the gallery about this one file
        adb -s $serial shell am broadcast \
            -a android.intent.action.MEDIA_SCANNER_SCAN_FILE \
            -d "'file://$dest/$name'" >/dev/null
        echo "added $name"
    end
end
