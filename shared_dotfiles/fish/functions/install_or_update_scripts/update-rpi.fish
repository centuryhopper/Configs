function update-rpi
    curl -L -o ~/.local/bin/rpi-imager https://downloads.raspberrypi.com/imager/imager_latest_amd64.AppImage
    chmod +x ~/.local/bin/rpi-imager
end
