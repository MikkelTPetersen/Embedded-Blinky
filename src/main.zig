const builtin = @import("builtin");
pub fn main() void {
    while (true) {}
}

pub export fn _start() noreturn {
    main();
    while (true) {}
}
