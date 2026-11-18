function install-docker --description Install\ Docker\ Engine\ +\ compose/buildx\ from\ Docker\'s\ apt\ repo
    set -l keyring /etc/apt/keyrings/docker.gpg
    set -l list /etc/apt/sources.list.d/docker.list
    set -l codename (string replace -rf '^UBUNTU_CODENAME=' '' < /etc/os-release)   # noble on Pop 24.04
    set -l arch (dpkg --print-architecture)

    # 0) remove distro/unofficial packages that conflict with Docker's own
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
        sudo apt remove -y $pkg 2>/dev/null
    end

    # 1) Docker's GPG key (one-time)
    if not test -f $keyring
        sudo apt update
        sudo apt install -y ca-certificates curl gpg; or return 1
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
            | sudo gpg --dearmor -o $keyring; or return 1
        sudo chmod a+r $keyring
    end

    # 2) Docker's apt repo (one-time)
    if not test -f $list
        echo "deb [arch=$arch signed-by=$keyring] https://download.docker.com/linux/ubuntu $codename stable" \
            | sudo tee $list >/dev/null
    end

    # 3) install engine + extras
    sudo apt update; or return 1
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    or return 1

    # 4) start on boot, and allow running docker without sudo
    sudo systemctl enable --now docker; or return 1
    sudo usermod -aG docker $USER

    # 5) verify (sudo here, since the group change needs a re-login)
    docker --version
    sudo docker run --rm hello-world
    echo "Log out and back in (or reboot) to use docker without sudo."
end
