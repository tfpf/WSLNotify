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

fn report_command_status(last_command: &str, exit_code: i32, begin_ts: u64, end_ts: u64) {}

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
#[cfg(feature = "bash")]
fn f() -> i32 {
    0
}
#[cfg(feature = "zsh")]
fn f() -> i32 {
    1
}
