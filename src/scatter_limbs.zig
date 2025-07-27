const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Stick_Man_Module = @import("stickMan.zig");
const global = @import("constants.zig");
const Hit_Box_Module = @import("hitbox.zig");

const Stick_Man = Stick_Man_Module.Stick_Man;

// const ALL_LIMB_TYPES = [_]LimbType{
//     .Head,
//     .Arm,
//     .Leg,
//     .Torso,
// };

const limb_type = enum {
    Head,
    Right_Arm,
    Left_Arm,
    Right_Leg,
    Left_Leg,
    Torso,
};

pub const Detached_Limb = struct {
    kind: limb_type,
    position: Vector2,
    velocity: Vector2,
    angle: f32,
    // ...
    rotation: f32,
    size: f32, // => only for head
    color: rl.Color,
};

// not most efficient but running out of time
pub fn init(limbs: *std.ArrayList(Detached_Limb), sm: *Stick_Man) !void {
    try limbs.append(Detached_Limb{
        .kind = limb_type.Head,
        .position = sm.head_center,
        .velocity = try get_random_velocity(),
        .angle = 0,
        .rotation = 10,
        .size = global.HEAD_RADIUS,
        .color = rl.Color.fromInt(0x8B0000),
    });
    try limbs.append(Detached_Limb{
        .kind = limb_type.Right_Arm,
        .position = get_coordinates(sm.body_start, sm.right_arm_top.angle, sm.right_arm_top.length * 2),
        .velocity = try get_random_velocity(),
        .angle = sm.right_arm_top.angle,
        .rotation = 10,
        .size = 0,
        .color = rl.Color.fromInt(0x8B0000),
    });
    try limbs.append(Detached_Limb{
        .kind = limb_type.Left_Arm,
        .position = get_coordinates(sm.body_start, sm.left_arm_top.angle, sm.left_arm_top.length * 2),
        .velocity = try get_random_velocity(),
        .angle = sm.left_arm_top.angle,
        .rotation = 10,
        .size = 0,
        .color = rl.Color.fromInt(0x8B0000),
    });
    try limbs.append(Detached_Limb{
        .kind = limb_type.Right_Leg,
        .position = get_coordinates(sm.body_end, sm.right_leg_top.angle, sm.right_leg_top.length * 2),
        .velocity = try get_random_velocity(),
        .angle = sm.right_leg_top.angle,
        .rotation = 10,
        .size = 0,
        .color = rl.Color.fromInt(0x8B0000),
    });
    try limbs.append(Detached_Limb{
        .kind = limb_type.Left_Leg,
        .position = get_coordinates(sm.body_end, sm.left_leg_top.angle, sm.left_leg_top.length * 2),
        .velocity = try get_random_velocity(),
        .angle = sm.left_leg_top.angle,
        .rotation = 10,
        .size = 0,
        .color = rl.Color.fromInt(0x8B0000),
    });
    try limbs.append(Detached_Limb{
        .kind = limb_type.Torso,
        .position = get_coordinates(sm.body_start, 0, global.BODY_LENGTH),
        .velocity = try get_random_velocity(),
        .angle = 0,
        .rotation = 10,
        .size = 0,
        .color = rl.Color.fromInt(0x8B0000),
    });
}

pub fn update_limbs(limbs: *std.ArrayList(Detached_Limb), dt: f32) void {
    for (limbs.items) |*limb| {
        scatter_limbs(limb, dt);
    }
}

pub fn draw_scattered_limbs(limbs: *std.ArrayList(Detached_Limb)) void {
    for (limbs.items) |limb| {
        draw(limb);
    }
}

fn draw(limb: Detached_Limb) void {
    if (limb.kind == limb_type.Head) {
        const x: i32 = @intFromFloat(limb.position.x);
        const y: i32 = @intFromFloat(limb.position.y);
        rl.drawCircle(x, y, limb.size, limb.color);
    } else {
        rl.drawLineEx(limb.position, get_limb_end(limb.position, global.LEG_SEGMENT_LENGTH * 2, limb.angle), 3, limb.color);
    }
}

pub fn scatter_limbs(limb: *Detached_Limb, dt: f32) void {
    limb.velocity.y += global.GRAVITY * global.GRAVITY_ACCELERATION * dt;

    limb.position.x += limb.velocity.x * dt;
    limb.position.y += limb.velocity.y * dt;

    limb.rotation += 1.5 * dt;

    if (limb.position.y > global.SCREEN_HEIGHT - 10) {
        limb.position.y = global.SCREEN_HEIGHT - 10;
        limb.velocity.y *= -0.5; // Bounce with reduced speed
    }
    if (limb.position.x < 0) {
        limb.position.x = 0;
        limb.velocity.x *= -0.5;
    } else if (limb.position.x > global.SCREEN_WIDTH) {
        limb.position.x = global.SCREEN_WIDTH;
        limb.velocity.x *= -0.5;
    }
}

fn get_coordinates(origin: Vector2, angle: f32, length: f32) Vector2 {
    const x = origin.x + std.math.cos(angle) * length;
    const y = origin.y + std.math.sin(angle) * length;
    return Vector2.init(x, y);
}

fn get_limb_end(start: Vector2, length: f32, angle: f32) Vector2 {
    const x = start.x + std.math.cos(angle) * length;
    const y = start.y + std.math.sin(angle) * length;
    return Vector2.init(x, y);
}

fn get_random_velocity() !Vector2 {
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();
    const a = rand.intRangeAtMost(i8, -10, 10); // Smaller range
    const b = rand.intRangeAtMost(i8, -20, 0); // Bias upward for y
    //
    const x: f32 = @floatFromInt(a);
    const y: f32 = @floatFromInt(b);

    return Vector2.init(x, y);
}
