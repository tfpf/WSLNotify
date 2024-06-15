use std::fmt::Write;

#[cfg(target_os = "linux")]
const OPERATING_SYSTEM_ICON: &str = "";
#[cfg(target_os = "macos")]
const OPERATING_SYSTEM_ICON: &str = "";
#[cfg(target_os = "windows")]
const OPERATING_SYSTEM_ICON: &str = "";

#[cfg(feature = "bash")]
#[macro_use]
mod constants {
    macro_rules! BEGIN_INVISIBLE {
        () => {
            "\x01"
        };
    }
    macro_rules! END_INVISIBLE {
        () => {
            "\x02"
        };
    }
    pub const USER: &str = "\\u";
    pub const HOST: &str = "\\h";
    pub const DIRECTORY: &str = "\\w";
    pub const PROMPT_SYMBOL: &str = "\\$";
}
#[cfg(feature = "zsh")]
#[macro_use]
mod constants {
    macro_rules! BEGIN_INVISIBLE {
        () => {
            "%\x7B"
        };
    }
    macro_rules! END_INVISIBLE {
        () => {
            "%\x7D"
        };
    }
    pub const USER: &str = "%n";
    pub const HOST: &str = "%m";
    pub const DIRECTORY: &str = "%~";
    pub const PROMPT_SYMBOL: &str = "%#";
}
pub use constants::*;

const BELL: &str = "\x07";
macro_rules! ESCAPE {
    () => {
        "\x1B"
    };
}
macro_rules! LEFT_SQUARE_BRACKET {
    () => {
        '\x5B'
    };
}
macro_rules! RIGHT_SQUARE_BRACKET {
    () => {
        '\x5D'
    };
}

// Bold, bright and italic.
const BBIYELLOW: &str = concat!(BEGIN_INVISIBLE!(), ESCAPE!(), LEFT_SQUARE_BRACKET!(), "1;3;93m", END_INVISIBLE!());

// Bold and bright.
const BBCYAN: &str = concat!(BEGIN_INVISIBLE!(), ESCAPE!(), LEFT_SQUARE_BRACKET!(), "1;96m", END_INVISIBLE!());
const BBGREEN: &str = concat!(BEGIN_INVISIBLE!(), ESCAPE!(), LEFT_SQUARE_BRACKET!(), "1;92m", END_INVISIBLE!());

// Bright.
const BBLUE: &str = concat!(BEGIN_INVISIBLE!(), ESCAPE!(), LEFT_SQUARE_BRACKET!(), "94m", END_INVISIBLE!());
const BGREENRAW: &str = concat!(ESCAPE!(), LEFT_SQUARE_BRACKET!(), "92m");
const BREDRAW: &str = concat!(ESCAPE!(), LEFT_SQUARE_BRACKET!(), "91m");

// Reset.
const RST: &str = concat!(BEGIN_INVISIBLE!(), ESCAPE!(), LEFT_SQUARE_BRACKET!(), "m", END_INVISIBLE!());
const RSTRAW: &str = concat!(ESCAPE!(), LEFT_SQUARE_BRACKET!(), "m");

/// Get the current timestamp.
///
/// Returns the time in nanoseconds since the Unix epoch.
fn get_timestamp() -> u64 {
    std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos() as u64
}

/// Convert an interval into human-readable form.
///
/// * `delay` - Interval of time measured in nanoseconds.
///
/// Returns a tuple of numbers representing the interval in more traditional
/// units: h, m, s and ms.
fn human_readable(mut delay: u64) -> (u32, u32, u32, u32) {
    delay /= 1000000;
    let milliseconds = (delay % 1000) as u32;
    delay /= 1000;
    let seconds = (delay % 60) as u32;
    delay /= 60;
    let minutes = (delay % 60) as u32;
    delay /= 60;
    let hours = (delay / 60) as u32;
    (hours, minutes, seconds, milliseconds)
}

/// Get the ID of the window which currently has focus.
fn get_active_window_id() -> String {
    active_win_pos_rs::get_active_window().unwrap().window_id
}

/// Send a desktop notification.
///
/// * `summary` - Notification title.
/// * `body` - Notification details.
fn notify(summary: &str, body: &str) {
    notify_rust::Notification::new().summary(summary).body(body).show().unwrap();
}

/// Show how long it took to run a command in a pretty manner.
///
/// * `last_command` - Most-recently run command.
/// * `exit_code` - Code with which the command exited.
/// * `delay` - Time the command ran for in nanoseconds.
/// * `window_id` - ID of the window which had focus when the command started.
/// * `columns` - Width of the terminal window.
fn report_command_status(last_command: &str, exit_code: i32, delay: u64, window_id: &str, columns: usize) {
    if delay <= 5000000000 {
        return;
    }

    // Remove the initial part (index and timestamp) of the command, if
    // applicable. Remove trailing whitespace characters, if any. Then allocate
    // enough space to write what remains and some additional information.
    #[cfg(feature = "bash")]
    let last_command = &last_command[last_command.find(RIGHT_SQUARE_BRACKET!()).unwrap() + 2..];
    let last_command = last_command.trim_end();
    let last_command_len = last_command.len();
    let mut report = String::with_capacity(last_command_len + 64);

    report.push_str(" ");
    let left_piece_len = columns * 3 / 8;
    let right_piece_len = left_piece_len;
    if last_command_len <= left_piece_len + 5 + right_piece_len {
        report.push_str(last_command);
    } else {
        report.push_str(&last_command[..left_piece_len]);
        report.push_str(" ... ");
        report.push_str(&last_command[last_command_len - right_piece_len..]);
    }
    if exit_code == 0 {
        write!(report, " {BGREENRAW}{RSTRAW} ").unwrap();
    } else {
        write!(report, " {BREDRAW}{RSTRAW} ").unwrap();
    }
    let (hours, minutes, seconds, milliseconds) = human_readable(delay);
    if hours > 0 {
        write!(report, "{hours:02}").unwrap();
    }
    write!(report, "{minutes:02}:{seconds:02}:{milliseconds:03}").unwrap();

    // Ensure that the text is right-aligned. Since there are non-printable
    // characters in the string, compensate for the width.
    let width = columns + 8;
    eprintln!("\r{report:>width$}");

    if delay > 10000000000 && window_id != get_active_window_id() {
        notify("CLI Ready", last_command);
    }
}

/// Show the primary prompt.
///
/// * `git_info` Description of the status of the current Git repository.
fn display_primary_prompt(git_info: &str) {
    print!("\n┌[{BBGREEN}{USER}{RST} {BBIYELLOW}{OPERATING_SYSTEM_ICON} {HOST}{RST} {BBCYAN}{DIRECTORY}{RST}]");
    print!("{git_info}");
    if let Ok(venv) = std::env::var("VIRTUAL_ENV_PROMPT") {
        print!("  {BBLUE}{venv}{RST}");
    };
    println!("\n└─{PROMPT_SYMBOL} ");
}

/// Update the title of the current terminal window. This should automatically
/// update the title of the current terminal tab.
///
/// * `pwd` - Current directory.
fn update_terminal_title(pwd: &str) {
    let short_pwd = match pwd.len() {
        1 => "",
        _ => &pwd[pwd.rfind("/").unwrap() + 1..],
    };
    eprint!("{}{}0;{}/{}", ESCAPE!(), RIGHT_SQUARE_BRACKET!(), short_pwd, BELL);
}

fn main() {
    let ts = get_timestamp();
    let args = std::env::args().collect::<Vec<String>>();
    if args.len() <= 1 {
        println!("{} {}", ts, get_active_window_id());
        return;
    }

    let last_command = &args[1];
    let exit_code = args[2].parse().unwrap();
    let delay = ts - args[3].parse::<u64>().unwrap();
    let window_id = &args[4];
    let columns = args[5].parse().unwrap();
    let git_info = &args[6];
    let pwd = &args[7];

    report_command_status(last_command, exit_code, delay, window_id, columns);
    display_primary_prompt(git_info);
    update_terminal_title(pwd);
}
