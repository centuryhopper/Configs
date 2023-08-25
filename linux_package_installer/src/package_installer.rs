use std::process::Command;

pub trait PackageInstaller<'a> {
    fn install_packages<T>(&self, iterable: T)
    where
        T: Iterator<Item = &'a str>;

    fn run_bash_command(&self, cmd: &'a str);

    fn get_user_input(&self, input: &'a str) -> String;
}

pub struct ArchHyperlandInstaller;

impl ArchHyperlandInstaller {
    pub fn new() -> Self {
        let o = ArchHyperlandInstaller{};
        o.run_bash_command("yay -Syu --noconfirm");
        o
    }

    pub fn check_for_yay(&self) {}

    pub fn disable_wifi_powersave_mode(&self) {}

    pub fn clean_out_other_portals(&self) {}
}

impl<'a> PackageInstaller<'a> for ArchHyperlandInstaller {
    fn install_packages<T>(&self, packages: T)
    where
        T: Iterator<Item = &'a str>,
    {
        for package in packages {
            Command::new("yay")
                .arg("-S")
                .arg(package)
                .arg("--needed")
                .arg("--noconfirm")
                .output()
                .expect(&format!("couldn't install package: {:#?}", package));
        }
    }

    fn run_bash_command(&self, cmd: &'a str) {
        let parts : Vec<&str> = cmd.split_whitespace().collect::<Vec<_>>();

        println!("parts: {:#?}", parts);

        let status = Command::new(&parts[0])
        .args(&parts[1..])
        .status()
        .expect(&format!("failed to run command: {:#?}", cmd));

        println!("{:?}", status)
    }

    fn get_user_input(&self, msg: &'a str) -> String{
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
}
