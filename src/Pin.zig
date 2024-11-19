const std = @import("std");
pub const Pin = struct {
    DDR: *volatile u8, //Data Direction Register
    Port: *volatile u8, //Port address
    PinBit: u3, //The bit of the pin TODO: WHY DOES THIS HAVE TO BE A u3???? Remember if this changes, also check the functions.

    pub fn setPinAsInput(self: *Pin) void {
        const temp: u8 = 1;
        self.DDR.* &= ~(@as(u8, @intCast(temp << self.PinBit)));
    }

    pub fn setPinAsOutput(self: *Pin) void {
        const temp: u8 = 1;
        self.DDR.* |= temp << self.PinBit;
    }

    pub fn setPinOn(self: *Pin) void {
        const temp: u8 = 1;
        self.Port.* &= ~(@as(u8, @intCast(temp << self.PinBit)));
    }

    pub fn setPinOff(self: *Pin) void {
        const temp: u8 = 1;
        self.Port.* |= temp << self.PinBit;
    }
    pub fn init(DDR: *volatile u8, Port: *volatile u8, PinBit: u3) !Pin {
        return Pin{
            .DDR = DDR,
            .Port = Port,
            .PinBit = PinBit,
        };
    }
};
