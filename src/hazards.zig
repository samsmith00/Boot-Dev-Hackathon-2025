const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Stick_Man_Module = @import("stickMan.zig");
const global = @import("constants.zig");
const Hit_Box_Module = @import("hitbox.zig");

const Stick_Man = Stick_Man_Module.Stick_Man;

pub const Phase = enum { Flash, Fire, Done };
const FLASH_DURATION: f32 = 0.5;
const FIRE_DURATION: f32 = 0.3;

pub const Boulder = struct {
    position: Vector2,
    velocity: Vector2,
    size: f32,
};

pub const Lazer_Beam = struct {
    position: Vector2,
    flash_color: rl.Color,
    color: rl.Color,
    timer: f32,
    phase: Phase,
};

pub fn init_boulder(starting_pos: Vector2, size: f32, speed: f32) !Boulder {
    return Boulder{
        .position = starting_pos,
        .velocity = Vector2.init(speed, 0),
        .size = size,
    };
}

pub fn init_lazer_beam(pos: f32) Lazer_Beam {
    const lazer_color = global.LAZER_BEAM_COLORS[global.LAZER_BEAM_COLOR_IDX];
    const light_color = global.LAZER_BEAM_FLASH_COLORS[global.LAZER_BEAM_COLOR_IDX];
    global.LAZER_BEAM_COLOR_IDX += 1;
    global.LAZER_BEAM_COLOR_IDX = @mod(global.LAZER_BEAM_COLOR_IDX, 5);

    return Lazer_Beam{
        .position = Vector2.init(pos, -5),
        .flash_color = light_color,
        .color = lazer_color,
        // ...
        .timer = 0,
        .phase = Phase.Flash,
    };
}

pub fn draw_boulder(boulders: *std.ArrayList(Boulder)) void {
    for (boulders.items) |b| {
        const x: i32 = @intFromFloat(b.position.x);
        const y: i32 = @intFromFloat(b.position.y);

        rl.drawCircle(x, y, b.size, rl.Color.brown);
    }
}

pub fn make_boulder_list(allocator: std.mem.Allocator) !std.ArrayList(Boulder) {
    return std.ArrayList(Boulder).init(allocator);
}

pub fn get_boulder_size() !f32 {
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    const c = rand.int(u8);
    var size_value: u32 = undefined;
    if (c < 85) {
        size_value = 10;
    } else if (c >= 85 and c < 190) {
        size_value = 15;
    } else {
        size_value = 30;
    }
    const result: f32 = @floatFromInt(size_value);
    return result;
}

pub fn get_boulder_pos() !Vector2 {
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();
    const idx = rand.uintLessThan(usize, 5);
    return global.BOULDER_STARTING_POS[idx];
}

pub fn get_boulder_speed() !f32 {
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    const speed = rand.float(f32) * 40.0 + 5.0;

    return speed;
}

pub fn generate_boulder_frequency() !f32 {
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    const c = rand.float(f32);

    const result = (@mod(c, 2.0) + 1);

    return result;
}

pub fn get_lazer_list(allocator: std.mem.Allocator) std.ArrayList(Lazer_Beam) {
    return std.ArrayList(Lazer_Beam).init(allocator);
}

// definitely a better way to do this but im too tired to try
// also just realized i have reused the prng seed blk a lot lol
pub fn calc_lazer_spawn_radius(sm: *Stick_Man) !f32 {
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    var sign = rand.float(f32);

    if (sign < 0.5) {
        sign = -1;
    } else {
        sign = 1;
    }

    var offset = rand.float(f32) * 25 + 7;
    offset *= sign;

    const result = sm.position.x + offset;

    return result;
}

pub fn update_lazers(lazers: *std.ArrayList(Lazer_Beam), dt: f32) void {
    var i: usize = 0;
    while (i < lazers.items.len) {
        var lazer = &lazers.items[i];
        lazer.timer += dt;

        switch (lazer.phase) {
            Phase.Flash => {
                if (lazer.timer > FLASH_DURATION) {
                    lazer.timer = 0;
                    lazer.phase = Phase.Fire;
                }
                i += 1;
            },
            Phase.Fire => {
                if (lazer.timer > FIRE_DURATION) {
                    lazer.phase = Phase.Done;
                }
                i += 1;
            },
            Phase.Done => {
                _ = lazers.swapRemove(i);
            },
        }
    }
}

pub fn draw_lazers(lazers: *std.ArrayList(Lazer_Beam), hb: rl.Rectangle) void {
    for (lazers.items) |lazer| {
        const end = calc_lazer_end(lazer);
        switch (lazer.phase) {
            Phase.Flash => {
                rl.drawLineEx(lazer.position, Vector2.init(lazer.position.x, end), 3, lazer.flash_color);
            },
            Phase.Fire => {
                rl.drawLineEx(lazer.position, Vector2.init(lazer.position.x, end), 4, lazer.color);
                stickman_lazer_collision(hb, lazer);
            },
            else => {},
        }
    }
}

fn calc_lazer_end(lazer: Lazer_Beam) f32 {
    var end_y: f32 = global.SCREEN_HEIGHT; // fallback value
    for (global.TERRAIN_RECTANGLES) |rect| {
        if (rect.x <= lazer.position.x) {
            end_y = rect.y;
        } else {
            break;
        }
    }
    return end_y;
}

pub fn stickman_lazer_collision(hb: rl.Rectangle, lazer: Lazer_Beam) void {
    if ((lazer.position.x < hb.x + hb.width) and (lazer.position.x > hb.x)) {
        std.debug.print("LAZER COLLISION", .{});
    }
}
