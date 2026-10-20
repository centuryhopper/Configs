function ytsubs --description 'Download English auto-generated subtitles for a YouTube video (no video)'
    if test (count $argv) -eq 0
        echo "usage: ytsubs <url> [more urls or yt-dlp options]"
        return 1
    end
    uvx yt-dlp --write-auto-subs --sub-langs en --skip-download $argv
end
