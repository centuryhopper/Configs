use std::{process::Command, fs::OpenOptions, io::Write};

pub trait PackageInstaller<'a> {
    fn install_packages<T>(&self, iterable: T)
    where
        T: Iterator<Item = &'a str>;

    fn run_bash_command(&self, cmd: &'a str);

    fn get_user_input(&self, input: &'a str) -> String;

    fn append_contents_to_file(&self, contents:&'a str, file: &'a str);
}

pub struct ArchHyperlandInstaller<'a>
{
    instlog_path: &'a str
}

impl<'a> ArchHyperlandInstaller<'a> {
    pub fn new(instlog_path : &'a str) -> Self {
        let o = ArchHyperlandInstaller{
            instlog_path: instlog_path
        };
        o.run_bash_command("sudo pacman -Syu --noconfirm");
        o
    }

    pub fn copy_configs(source:&'a str, dest: &'a str) {
        
    }

    pub fn check_for_yay(&self) {}

    pub fn disable_wifi_powersave_mode(&self) {}

    pub fn clean_out_other_portals(&self) {}
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

            &self.run_bash_command(&format!("yay -S {} --needed --noconfirm", package));
        }
    }

    fn run_bash_command(&self, cmd: &'a str) {
        let parts : Vec<&str> = cmd.split_whitespace().collect::<Vec<_>>();

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
        .open(&self.instlog_path)
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

    fn append_contents_to_file(&self, contents:&'a str, file: &'a str) {

        println!("{} will be created if it hasn't been already.", file);

        let mut fp = OpenOptions::new()
        .create(true)
        .append(true)
        .open(file)
        .expect(&format!("Failed to open file: {}", file));

        fp
        .write_all(contents.as_bytes())
        .expect(&format!("Failed to write to file: {}", file));
        
    }
}
