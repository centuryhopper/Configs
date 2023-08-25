mod package_installer;
use std::path::Path;

use package_installer::{ArchHyperlandInstaller, PackageInstaller};

fn main() {

    // check for yay. Install it if it doesn't exist
    println!("{}", Path::new("/sbin/yay").exists());

    // let ai = ArchHyperlandInstaller::new();

    // copy "[connection]\nwifi.powersave = 2" to /etc/NetworkManager/conf.d/wifi-powersave.conf
    // sudo systemctl restart NetworkManager

    // let main_components: Vec<&str> = vec![
    //     "hyprland",
    //     "kitty",
    //     "waybar",
    //     "swww",
    //     "swaylock-effects",
    //     "wofi",
    //     "wlogout",
    //     "mako",
    //     "xdg-desktop-portal-hyprland",
    //     "swappy",
    //     "grim",
    //     "slurp",
    //     "thunar",
    // ];

    // let additional_components: Vec<&str> = vec![
    //     "polkit-gnome",
    //     "python-requests",
    //     "pamixer",
    //     "pavucontrol",
    //     "brightnessctl",
    //     "bluez",
    //     "bluez-utils",
    //     "blueman",
    //     "network-manager-applet",
    //     "gvfs",
    //     "thunar-archive-plugin",
    //     "file-roller",
    //     "btop",
    //     "pacman-contrib",
    // ];

    // let theme_components: Vec<&str> = vec![
    //     "starship",
    //     "ttf-jetbrains-mono-nerd",
    //     "noto-fonts-emoji",
    //     "lxappearance",
    //     "xfce4-settings",
    //     "sddm-git",
    //     "qt5-svg",
    //     "qt5-quickcontrols2",
    //     "qt5-graphicaleffects",
    // ];

    // let servicesToEnable = vec![
    //     "sudo systemctl enable --now bluetooth.service",
    //     "sudo systemctl enable sddm",
    // ];

    // let configs = vec![
    //     "fish",
    //     "hypr",
    //     "kitty",
    //     "lf",
    //     "mako",
    //     "nvim",
    //     "shaders",
    //     "tmux",
    //     "Wallpapers",
    //     "waybar",
    //     "wlogout",
    //     "wofi",
    // ];

    // // ai.run_bash_command("cp /home/leo_zhang/Documents/GitHub/Configs/arch_linux_hyprland/dotfiles/starship.toml /home/leo_zhang/.config/test/");
    // // copy starship
    // ai.run_bash_command("");

    // // copy bashrc
    // ai.run_bash_command("");


    // copy over configs

    // set some scripts as executable

    // copy the sddm theme

    // setup the first look and feel as dark

    // let response = ai.get_user_input("Would you like to start Hyprland now? (y,n)");

    // start hyprland if user says yes
    // if (response.to_lowercase() == "y") {
    //     println!("sudo systemctl start sddm");
    // }
}
