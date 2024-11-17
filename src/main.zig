const builtin = @import("builtin");

pub fn main() noreturn {
    // Memory-mapped registers for ATmega328P
    const DDRB5: *volatile u8 = @ptrFromInt(0x24); // Data Direction Register B
    const PORTB5: *volatile u8 = @ptrFromInt(0x25); // Port B Data Register

    const LED_PIN: u8 = 5; // Pin 13 corresponds to bit 5 of PORTB.

    // Set LED_PIN as an output
    DDRB5.* |= 1 << LED_PIN;

    while (true) {
        // Turn on the LED
        PORTB5.* |= 1 << LED_PIN;
        delay_ms(1000);

        // Turn off the LED
        PORTB5.* &= ~@as(u8, @intCast(1 << LED_PIN));
        delay_ms(1000);
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
}
