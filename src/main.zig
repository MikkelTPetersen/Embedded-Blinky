const builtin = @import("builtin");

pub fn main() noreturn {
    // Memory-mapped registers for ATmega328P
    var DDRB_temp: u8 = 0x24;
    var PORTB_temp: u8 = 0x25;
    const DDRB: *volatile u8 = @ptrCast(&DDRB_temp); // Data Direction Register B
    const PORTB: *volatile u8 = @ptrCast(&PORTB_temp); // Port B Data Register

    const LED_PIN: u8 = 5; // Pin 13 corresponds to bit 5 of PORTB.

    // Set LED_PIN as an output
    DDRB.* |= 1 << LED_PIN;

    while (true) {
        // Turn on the LED
        PORTB.* |= 1 << LED_PIN;
        delay_ms(1500);

        // Turn off the LED
        PORTB.* &= ~@as(u8, @intCast(1 << LED_PIN));
        //PORTB.* &= @as(u8, ~(1 << LED_PIN));
        delay_ms(1500);
    }
}

fn delay_ms(ms: usize) void {
    // A crude busy-wait delay loop calibrated for a 16 MHz clock.
    // Adjust the loop count as needed for other clock speeds.
    const clock_cycles_per_ms: u32 = 16000;
    const loop_iterations = clock_cycles_per_ms / 4; // Approximate loop overhead.
    for (ms) |_| {
        for (loop_iterations) |_| asm volatile ("");
    }
}
pub export fn _start() noreturn {
    main();
    //while (true)
}
