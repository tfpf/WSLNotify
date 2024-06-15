fn main() {
    let win = active_win_pos_rs::get_active_window().unwrap();
    println!("{}", win.window_id);

notify_rust::Notification::new()
    .summary("Firefox News")
    .body("This will almost look like a real firefox notification.")
    .show().unwrap();
}
