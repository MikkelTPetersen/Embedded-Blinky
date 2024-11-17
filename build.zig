const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) !void {
    const uno = std.zig.CrossTarget{
        .cpu_arch = .avr,
        .cpu_model = .{ .explicit = &std.Target.avr.cpu.atmega328p },
        .os_tag = .freestanding,
        .abi = .none,
    };

    const exe = b.addExecutable(.{
        .name = "blinkyArduino",
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(uno),
        .optimize = .ReleaseSafe,
    });

    exe.setLinkerScriptPath(b.path("linker.ld"));

    b.installArtifact(exe);
    b.default_step.dependOn(&exe.step);

    const tty = b.option(
        []const u8,
        "tty",
        "Specify the port to which the Arduino is connected (defaults to /dev/ttyACM0)",
    ) orelse "/dev/ttyACM0";

    const bin_path = b.getInstallPath(.{ .custom = exe.installed_path orelse "./bin" }, exe.out_filename);

    const flash_command = blk: {
        var tmp = std.ArrayList(u8).init(b.allocator);
        try tmp.appendSlice("-Uflash:w:");
        try tmp.appendSlice(bin_path);
        try tmp.appendSlice(":e");
        break :blk try tmp.toOwnedSlice();
    };

    const read_command = blk: {
        var tmp = std.ArrayList(u8).init(b.allocator);
        try tmp.appendSlice("-Uflash:r:");
        try tmp.appendSlice("./flash.bin");
        try tmp.appendSlice(":r");
        break :blk try tmp.toOwnedSlice();
    };
    const upload = b.step("flash", "Flashing the code to an Arduino device using avrdude");
    const avrdudeFlash = b.addSystemCommand(&.{
        "avrdude",
        "-carduino",
        "-pm328p",
        "-P",
        tty,
        flash_command,
    });
    upload.dependOn(&avrdudeFlash.step);
    avrdudeFlash.step.dependOn(&exe.step);

    const read = b.step("read", "Reading the code of the conencted Arduino device using avrdude");
    const avrdudeRead = b.addSystemCommand(&.{
        "avrdude",
        "-carduino",
        "-pm328p",
        "-P",
        tty,
        read_command,
    });
    read.dependOn(&avrdudeRead.step);
    avrdudeRead.step.dependOn(&exe.step);
}
