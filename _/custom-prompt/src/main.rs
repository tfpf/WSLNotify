fn main() {
    let win = active_win_pos_rs::get_active_window().unwrap();
    println!("{} {}", f(), win.window_id);

notify_rust::Notification::new()
    .summary("Firefox News")
    .body("This will almost look like a real firefox notification.")
    .show().unwrap();

}
#[cfg(feature="bash")]
fn f() -> i32{
0}
#[cfg(feature="zsh")]
fn f() -> i32{
1}
