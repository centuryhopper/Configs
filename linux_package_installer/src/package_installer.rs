use std::{fs::OpenOptions, io::Write, process::Command, thread, time::Duration, path::Path};
use indoc::indoc;
use colored::Colorize;


pub trait PackageInstaller<'a> {
    fn install_packages<T>(&self, iterable: T)
    where
        T: Iterator<Item = &'a str>;

    fn run_bash_command(&self, cmd: &'a str);

    fn get_user_input(&self, input: &'a str) -> String;

    fn append_contents_to_file(&self, contents: &'a str, file: &'a str);

    fn run(&self);
}

pub struct ArchHyperlandInstaller<'a> {
    instlog_path: &'a str,
}

impl<'a> ArchHyperlandInstaller<'a> {
    pub fn new(instlog_path: &'a str) -> Self {
        let o = ArchHyperlandInstaller {
            instlog_path: instlog_path,
        };
        o.run_bash_command("sudo pacman -Syu --noconfirm");
        o
    }
}

impl<'a> PackageInstaller<'a> for ArchHyperlandInstaller<'a> {
    fn install_packages<T>(&self, packages: T)
    where
        T: Iterator<Item = &'a str>,
    {
        for package in packages {
            // Command::new("yay")
            //     .arg("-S")
            //     .arg(package)
            //     .arg("--needed")
            //     .arg("--noconfirm")
            //     .output()
            //     .expect(&format!("couldn't install package: {:#?}", package));

            self.run_bash_command(&format!("yay -S {} --needed --noconfirm", package));
        }
    }

    fn run_bash_command(&self, cmd: &'a str) {
        let parts: Vec<&str> = cmd.split_whitespace().collect::<Vec<_>>();

        println!("parts: {:#?}", parts);

        let output = Command::new(&parts[0])
            .args(&parts[1..])
            .output()
            .expect(&format!("failed to run command: {:#?}", cmd));

        println!("{:?}", output);

        // Write the combined stdout and stderr to the log file
        let mut log_file = OpenOptions::new()
            .create(true)
            .append(true)
            .open(self.instlog_path)
            .expect("Failed to open log file");

        log_file
            .write_all(&output.stdout)
            .expect("Failed to write to log file");

        log_file
            .write_all(&output.stderr)
            .expect("Failed to write to log file");
    }

    fn get_user_input(&self, msg: &'a str) -> String {
        // Create a new instance of std::io::Stdin
        let stdin = std::io::stdin();

        // Print a prompt to the user
        println!("{}", msg);

        // Create a mutable string to store the user input
        let mut input = String::new();

        // Read the user input into the String
        stdin.read_line(&mut input).expect("Failed to read line");

        // Print the user's input
        println!("You entered: {}", input);

        // println!("{}", input == "\n");

        input
    }

    fn append_contents_to_file(&self, contents: &'a str, file: &'a str) {
        println!("{} will be created if it hasn't been already.", file);

        let mut fp = OpenOptions::new()
            .create(true)
            .append(true)
            .open(file)
            .expect(&format!("Failed to open file: {}", file));

        fp.write_all(contents.as_bytes())
            .expect(&format!("Failed to write to file: {}", file));
    }

    fn run(&self) {
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
        let mut prompt = format!(
            "{}",
            "ACTION - Would you like to continue with the install (y,n)".yellow()
        );

        let mut response = self.get_user_input(prompt.as_str());

        if response.to_lowercase() == "y" {
            println!("{}", "starting install script...".white());
        } else {
            println!(
                "{}",
                "This script will now exit. No changes were made to your system.".white()
            );
            std::process::exit(0);
        }

        let notice = indoc! {
            "NOTE - This script will run some commands that require sudo. You will be prompted to enter your password.
            If you are worried about entering your password then you may want to review the content of the script."
        };

        println!("{}", notice.yellow());

        thread::sleep(Duration::from_secs(3));

        // check for yay. Install it if it doesn't exist
        if Path::new("/sbin/yay").exists() {
            println!("{}", "yay was located, moving on.".white());
        } else {
            println!("{}", "yay not was located.".white());
            prompt = format!("{}", "ACTION - Would you like to install yay (y,n)".yellow());
            response = self.get_user_input(&prompt);

            if response.to_lowercase() == "y" {
                self.run_bash_command("git clone https://aur.archlinux.org/yay.git");
                self.run_bash_command("cd yay");
                self.run_bash_command("makepkg -si --noconfirm");
                self.run_bash_command("cd ..");
            } else {
                println!("Yay is required for this script, now exiting.");
                std::process::exit(0);
            }
        }

        response = self.get_user_input("Would you like to disable WiFi powersave? (y,n)");

        if response.to_lowercase() == "y" {
            self.append_contents_to_file(
                "[connection]\nwifi.powersave = 2",
                "/etc/NetworkManager/conf.d/wifi-powersave.conf",
            );
            println!("{}", "NOTE - Restarting NetworkManager service...".yellow());

            thread::sleep(Duration::from_secs(1));
            self.run_bash_command("sudo systemctl restart NetworkManager");
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
        response =
            self.get_user_input(&format!("Would you like to install the packages (y,n)").yellow());

        if response.to_lowercase() == "y" {
            println!("Updating yay database...");
            self.run_bash_command("yay -Syu --noconfirm");

            println!(
                "{}",
                "Installing main components. This may take a while...".yellow()
            );

            self.install_packages(main_components.into_iter());

            self.install_packages(additional_components.into_iter());

            self.install_packages(theme_components.into_iter());
        }

        let services = vec![
            "sudo systemctl enable --now bluetooth.service",
            "sudo systemctl enable sddm",
        ];

        for service in services {
            self.run_bash_command(service);
            thread::sleep(Duration::from_secs(2));
        }

        println!("{}", "Clearning out conflicting xdg portals...".yellow());
        self.run_bash_command("yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk");

        // copy configs over and finish remaining setup
        self.run_bash_command("bash set-configs");
    }
}
