/// Get the current timestamp.
///
/// Returns the time in milliseconds since the Unix epoch.
fn get_timestamp() -> u64 {
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_nanos() as u64
}

fn report_command_status() {}

fn main() {
    let ts = get_timestamp();
    let winid = active_win_pos_rs::get_active_window().unwrap().window_id;
    let args = std::env::args().collect::<Vec<String>>();
    if args.len() <= 1 {
        println!("{} {}", ts, winid);
        return;
    }

    notify_rust::Notification::new()
        .summary("Firefox News")
        .body("This will almost look like a real firefox notification.")
        .show()
        .unwrap();
}
#[cfg(feature = "bash")]
fn f() -> i32 {
    0
}
#[cfg(feature = "zsh")]
fn f() -> i32 {
    1
}
