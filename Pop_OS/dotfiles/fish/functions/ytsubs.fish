function ytsubs --description 'Download English auto-generated subtitles for a YouTube video'
    if test (count $argv) -lt 1
        echo "usage: ytsubs <url>" >&2
        return 1
    end
    uvx yt-dlp --write-auto-subs --sub-langs en --skip-download $argv[1]
end
