mod package_installer;
use std::{path::Path, thread, time::Duration, env, vec};
use colored::Colorize;
use indoc::indoc;
use package_installer::{ArchHyperlandInstaller, PackageInstaller};
use dirs::home_dir;

fn main() {
    println!("home: {:?}", home_dir().unwrap());
    let home = home_dir().unwrap();

    let ai = ArchHyperlandInstaller::new("install.log");

    let expectations = indoc! {
        "
        NOTE - You are about to execute a script that would attempt to setup Hyprland.
        Please note that Hyprland is still in Beta.
        Please note that VMs are not fully supported and if you try to run this on
        a Virtual Machine there is a high chance this will fail.
        Please note that support for Nvidia GPUs is limited and may require
        more work which is beyond the scope of this script.
        \n
        "
    };

    println!("{}", expectations.yellow());
    let mut prompt = format!("{}", "ACTION - Would you like to continue with the install (y,n)".yellow());
    let mut response = ai.get_user_input(prompt.as_str());

    if response.to_lowercase() == "y" {
        println!("{}", "starting install script...".white());
    }
    else {
        println!("{}", "This script will now exit. No changes were made to your system.".white());
        std::process::exit(0);
    }

    let mut notice = indoc! {
        "NOTE - This script will run some commands that require sudo. You will be prompted to enter your password.
        If you are worried about entering your password then you may want to review the content of the script."
    };

    println!("{}", notice.yellow());

    thread::sleep(Duration::from_secs(3));

    // check for yay. Install it if it doesn't exist
    if Path::new("/sbin/yay").exists() {
        println!("{}", "yay was located, moving on.".white());
    }
    else {
        println!("{}", "yay not was located.".white());
        response = ai.get_user_input(&format!("ACTION - Would you like to install yay (y,n)"));

        if response.to_lowercase() == "y" {
            ai.run_bash_command("git clone https://aur.archlinux.org/yay.git");
            ai.run_bash_command("cd yay");
            ai.run_bash_command("makepkg -si --noconfirm");
            ai.run_bash_command("cd ..");
        }
        else {
            println!("Yay is required for this script, now exiting.");
            std::process::exit(0);
        }
    }


    response = ai.get_user_input("Would you like to disable WiFi powersave? (y,n)");

    if response.to_lowercase() == "y" {
        ai.append_contents_to_file("[connection]\nwifi.powersave = 2", "/etc/NetworkManager/conf.d/wifi-powersave.conf");
        println!("{}", "NOTE - Restarting NetworkManager service...".yellow());

        thread::sleep(Duration::from_secs(1));
        ai.run_bash_command("sudo systemctl restart NetworkManager");
        thread::sleep(Duration::from_secs(3));
    }

    let main_components: Vec<&str> = vec![
        "hyprland",
        "kitty",
        "waybar",
        "swww",
        "swaylock-effects",
        "wofi",
        "wlogout",
        "mako",
        "xdg-desktop-portal-hyprland",
        "swappy",
        "grim",
        "slurp",
        "thunar",
    ];

    let additional_components: Vec<&str> = vec![
        "polkit-gnome",
        "python-requests",
        "pamixer",
        "pavucontrol",
        "brightnessctl",
        "bluez",
        "bluez-utils",
        "blueman",
        "network-manager-applet",
        "gvfs",
        "thunar-archive-plugin",
        "file-roller",
        "btop",
        "pacman-contrib",
    ];

    let theme_components: Vec<&str> = vec![
        "starship",
        "ttf-jetbrains-mono-nerd",
        "noto-fonts-emoji",
        "lxappearance",
        "xfce4-settings",
        "sddm-git",
        "qt5-svg",
        "qt5-quickcontrols2",
        "qt5-graphicaleffects",
    ];
    response = ai.get_user_input(&format!("Would you like to install the packages (y,n)").yellow());

    if response.to_lowercase() == "y" {
        println!("Updating yay database...");
        ai.run_bash_command("yay -Syu --noconfirm");

        println!("{}", "Installing main components. This may take a while...".yellow());

        ai.install_packages(main_components.into_iter());

        ai.install_packages(additional_components.into_iter());

        ai.install_packages(theme_components.into_iter());


    }

    let servicesToEnable = vec![
        "sudo systemctl enable --now bluetooth.service",
        "sudo systemctl enable sddm",
    ];

    for service in servicesToEnable {
        ai.run_bash_command(service);
        thread::sleep(Duration::from_secs(2));
    }

    println!("{}", "Clearning out conflicting xdg portals...".yellow());
    ai.run_bash_command("yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk");

    

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
    let exes = vec![
        format!("chmod +x {}/.config/hypr/scripts/bgaction", home.to_string_lossy()),
        format!("chmod +x {}/.config/hypr/scripts/xdg-portal-hyprland", home.to_string_lossy()),
        format!("chmod +x {}/.config/waybar/scripts/waybar-wttr.py", home.to_string_lossy()),
        format!("chmod +x {}/.config/waybar/scripts/baraction", home.to_string_lossy()),
        format!("chmod +x {}/.config/waybar/scripts/update-sys", home.to_string_lossy()),
    ];

    for ex in exes {
        ai.run_bash_command(ex.as_str());
    }

    // copy the sddm theme

    // setup the first look and feel as dark

    // let response = ai.get_user_input("Would you like to start Hyprland now? (y,n)");

    // start hyprland if user says yes
    // if (response.to_lowercase() == "y") {
    //     println!("sudo systemctl start sddm");
    // }
}
