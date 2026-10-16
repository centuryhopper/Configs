function install-cmake --description Install\ CMake\ from\ Kitware\'s\ apt\ repo\;\ optional\ version\ prefix\ pins\ it\ \(e.g.\ 4.3\) --argument ver
    set -l keyring /usr/share/keyrings/kitware-archive-keyring.gpg
    set -l list /etc/apt/sources.list.d/kitware.list
    set -l codename (string replace -rf '^UBUNTU_CODENAME=' '' < /etc/os-release)   # noble on Pop 24.04

    # one-time repo setup
    if not test -f $list
        sudo apt update
        sudo apt install -y ca-certificates gpg wget; or return 1

        wget -qO - https://apt.kitware.com/keys/kitware-archive-latest.asc \
            | gpg --dearmor | sudo tee $keyring >/dev/null; or return 1
        echo "deb [signed-by=$keyring] https://apt.kitware.com/ubuntu/ $codename main" \
            | sudo tee $list >/dev/null
        sudo apt update; or return 1

        # swap the manual key for the keyring package (handles future key rotations)
        sudo rm $keyring
        sudo apt install -y kitware-archive-keyring; or return 1
    end

    sudo apt update
    sudo apt-mark unhold cmake cmake-data >/dev/null

    if test -z "$ver"
        sudo apt install -y cmake cmake-data; or return 1
    else
        # newest available build matching the prefix, e.g. 4.3 -> 4.3.2-0kitware1ubuntu24.04.1
        set -l full (apt-cache madison cmake | string split -f2 '|' | string trim \
            | string match -r '^'(string escape --style=regex $ver)'\..*' | head -1)
        if test -z "$full"
            echo "no cmake $ver.* in the repo; available:"
            apt-cache madison cmake | string split -f2 '|' | string trim
            return 1
        end
        sudo apt install -y --allow-downgrades cmake=$full cmake-data=$full; or return 1
        sudo apt-mark hold cmake cmake-data      # stop apt upgrade from pulling 4.4 back in
    end

    cmake --version | head -1
end
