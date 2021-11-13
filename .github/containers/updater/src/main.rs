use std::path::PathBuf;
use structopt::StructOpt;

mod github;
mod

#[derive(StructOpt, Debug, Clone)]
#[structopt(about = "Overlay Updater 3000", rename_all = "kebab-case")]
enum Updater {
    RustAnalyzer {
        #[structopt(default_value = "1")]
        last: u32,
        destination: Option<PathBuf>,
    },
}

fn main() {
    let opt = Updater::from_args();
    println!("{:?}", opt);
}
