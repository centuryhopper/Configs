mod package_installer;
use std::path::Path;
use dirs::home_dir;
use package_installer::ArchHyperlandInstaller;
use package_installer::PackageInstaller;


fn main() {
    let home = home_dir().unwrap();
    let home_path = Path::new(&home);
    let desired_dir = home_path.join(Path::new("Configs/arch_linux_hyprland/dotfiles"));
    
    if !desired_dir.exists() {
        println!("Please make sure to copy my github repo into your home folder");
        std::process::exit(0);
    }

    std::env::set_current_dir(&desired_dir).expect("failed to set to new directory");

    println!("{:?}", std::env::current_dir().unwrap());

    // let status = Command::new("echo")
    //     .arg("$USER")
    //     .status()
    //     .expect("failed to run command");

    // println!("output: {:?}", status);
    let ai = ArchHyperlandInstaller::new("install.log");
    ai.run();

}
