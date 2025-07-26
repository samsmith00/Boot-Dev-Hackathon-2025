const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Stick_Man_Module = @import("stickMan.zig");
const global = @import("constants.zig");
const Hit_Box_Module = @import("hitbox.zig");

const Stick_Man = Stick_Man_Module.Stick_Man;

const Boulder = struct {
    position: Vector2,
    velocity: Vector2,
    size: f32,
};

const Lazer_Beam = struct {
    position: Vector2,
    color: rl.Color,
};

pub fn init_bouder() Boulder {
    const size = try get_boulder_size();
    return Boulder{
        .positoin = Vector2.init(global.SCREEN_WIDTH + 50, -50),
        .velocity = Vector2.init(10, 0),
        .size = size,
    };
}

pub fn init_lazer_beam(pos: Vector2) Lazer_Beam {
    const color = global.LAZER_BEAM_COLORS[global.LAZER_BEAM_COLOR_IDX];
    global.LAZER_BEAM_COLOR_IDX += 1;
    global.LAZER_BEAM_COLOR_IDX = @mod(global.LAZER_BEAM_COLOR_IDX, 5);

    return Lazer_Beam{
        .positoin = pos,
        .color = color,
    };
}

pub fn draw_boulder(boulder: *Boulder) void {
    rl.drawPoly(boulder.position, 10, boulder.size, 6, rl.Color.gray);
}

fn get_boulder_size() !f32 {
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    const c = rand.int(u8);
    var size_value: u32 = undefined;
    if (c < 85) {
        size_value = 15;
    } else if (c >= 85 and c < 190) {
        size_value = 30;
    } else {
        size_value = 45;
    }
    const result: f32 = @floatFromInt(size_value);
    return result;
}
