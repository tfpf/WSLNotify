use std::fmt::Write;

const LEFT_SQUARE_BRACKET: char = '\x5B';
const RIGHT_SQUARE_BRACKET: char = '\x5D';

/// Get the current timestamp.
///
/// Returns the time in nanoseconds since the Unix epoch.
fn get_timestamp() -> u64 {
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_nanos() as u64
}

/// Get the ID of the window which currently has focus.
fn get_active_window_id() -> String {
    active_win_pos_rs::get_active_window().unwrap().window_id
}

/// Show how long it took to run a command.
///
/// * `last_command` - Most-recently run command.
/// * `exit_code` - Code with which the command exited.
/// * `begin_ts` - Timestamp of the instant the command was started at.
/// * `end_ts` - Timestamp of the instant the command exited at.
///
/// Returns `true` if the command ran for long. Returns `false` otherwise.
fn report_command_status(last_command: &str, exit_code: i32, begin_ts: u64, end_ts: u64) ->bool {
    let delay = end_ts - begin_ts;
    if delay <= 5000000000 {
        // return false;
    }

    #[cfg(feature="bash")]
    let last_command = &last_command[last_command.find(RIGHT_SQUARE_BRACKET).unwrap() + 2..];
    let last_command = last_command.trim_end();
    let last_command_len = last_command.len();
    let mut report = String::with_capacity(last_command_len + 64);

    report.push_str(" ");
    let columns = std::env::var("COLUMNS").unwrap().parse::<usize>().unwrap();
    let left_piece_len = columns * 3 / 8;
    let right_piece_len = left_piece_len;
    if last_command_len <= left_piece_len + 5 + right_piece_len {
        report.push_str(last_command);
    } else{
        report.push_str(&last_command[..left_piece_len]);
        report.push_str(" ... ");
        report.push_str(&last_command[last_command_len - right_piece_len..]);
    }

    if exit_code == 0{
        report.push_str("  ");
    } else {
        report.push_str("  ");
    }
    let mut delay_ = delay / 1000000;
    let milliseconds = delay_ % 1000;
    delay_ /= 1000;
    let seconds = delay_ % 60;
    delay_ /= 60;
    let minutes = delay_ % 60;
    delay_ /= 60;
    let hours = delay_ / 60;
    if hours > 0 {
        write!(report, "{:0>2}", hours).unwrap();
    }
    write!(report, "{:0>2}:{:0>2}:{:0>3}", minutes, seconds, milliseconds).unwrap();

    let width = columns + 12;
    eprintln!("\r{:>width$}", report, width=width);

    false
}

fn main() {
    let ts = get_timestamp();
    let args = std::env::args().collect::<Vec<String>>();
    eprintln!("Received {:?}.", args);
    if args.len() <= 1 {
        println!("{} {}", ts, get_active_window_id());
        return;
    }

    let last_command = &args[1];
    let exit_code = args[2].parse().unwrap();
    let begin_ts = args[3].parse().unwrap();
    let end_ts = ts;
    let window_id = &args[4];
    let git_info = &args[5];

    report_command_status(last_command, exit_code, begin_ts, end_ts);

    println!("> ");

    // notify_rust::Notification::new()
    //     .summary("Firefox News")
    //     .body("This will almost look like a real firefox notification.")
    //     .show()
    //     .unwrap();
}
//#[cfg(feature = "bash")]
//fn f() -> i32 {
//    0
//}
//#[cfg(feature = "zsh")]
//fn f() -> i32 {
//    1
//}
