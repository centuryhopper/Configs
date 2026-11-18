function count-files-by-ext --description 'Count files in current dir matching given extensions'
    set -l extensions $argv

    if test (count $extensions) -eq 0
        echo "Usage: count-files-by-ext ext1 ext2 ext3 ..."
        echo "Example: count-files-by-ext jpg jpeg png heic"
        return 1
    end

    # Build up the -iname '*.ext' -o -iname '*.ext' ... args
    set -l name_args
    for ext in $extensions
        if test (count $name_args) -gt 0
            set name_args $name_args -o
        end
        set name_args $name_args -iname "*.$ext"
    end

    find . -maxdepth 1 -type f \( $name_args \) | count
end
