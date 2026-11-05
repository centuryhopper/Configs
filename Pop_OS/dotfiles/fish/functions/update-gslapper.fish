function update-gslapper --description 'Install the latest gSlapper .deb from GitHub releases'
    set -l api https://api.github.com/repos/Nomadcxx/gSlapper/releases/latest

    set -l json (curl -fsSL $api)
    or begin
        echo "couldn't reach the GitHub API" >&2
        return 1
    end

    set -l tag (string match -rg '"tag_name":\s*"([^"]+)"' -- $json)
    set -l debs (string match -rag '"browser_download_url":\s*"([^"]+\.deb)"' -- $json)

    if test -z "$debs"
        echo "release $tag has no .deb file — you'll need to build from source" >&2
        return 1
    end

    # Prefer the amd64 build if there are several
    set -l url (string match -e amd64 -- $debs)[1]
    test -z "$url"; and set url $debs[1]

    # Skip if this version is already installed
    set -l installed (dpkg-query -W -f '${Version}' gslapper 2>/dev/null)
    set -l version (string replace -r '^v' '' -- $tag)
    if test -n "$installed"; and string match -q "$version*" -- $installed
        echo "gSlapper $installed is already the latest ($tag)"
        return 0
    end

    set -l dir (mktemp -d /tmp/gslapper.XXXXXX)
    set -l file $dir/(basename $url)

    echo "Downloading $tag: "(basename $url)
    curl -fL --progress-bar -o $file $url
    and sudo apt install -y $file
    set -l ok $status

    rm -rf $dir
    test $ok -eq 0; and echo "Installed gSlapper $tag"
    return $ok
end
