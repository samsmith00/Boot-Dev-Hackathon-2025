const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Stick_Man_Module = @import("stickMan.zig");
const global = @import("constants.zig");
const Hit_Box_Module = @import("hitbox.zig");
const Hazards = @import("hazards.zig");

const Stick_Man = Stick_Man_Module.Stick_Man;
const Boulder = Hazards.Boulder;

pub fn gravity(sm: *Stick_Man, hb: *rl.Rectangle, tr: rl.Rectangle, boulders: *std.ArrayList(Boulder), dt: f32) void {
    _ = tr;

    sm.velocity.y += global.GRAVITY * dt * global.GRAVITY_ACCELERATION;
    sm.position.y += sm.velocity.y * dt * global.JUMP_ACCELERATION;

    var colliding_rect_b: rl.Rectangle = undefined;
    for (boulders.items) |*b| {
        b.velocity.y += global.GRAVITY * dt * global.GRAVITY_ACCELERATION;
        if (boulder_collision(b, &colliding_rect_b)) {
            b.position.y = colliding_rect_b.y - b.size;
            b.velocity.y *= -1;
            b.velocity.y += global.BOULDER_FRICTION;
        }
        stickman_boulder_collision(b, hb);
    }

    var colliding_rect_sm: rl.Rectangle = undefined;
    const is_colliding = terrain_collision(hb, &colliding_rect_sm);
    const jumping = sm.velocity.y < 0;

    if (is_colliding and !jumping) {
        sm.position.y = colliding_rect_sm.y - hb.height - global.HITBOX_Y_OFFSET + 1;
        sm.velocity.y = 0;
        sm.first_jump = false;
        sm.second_jump = false;
        sm.on_ground = true;
    } else {
        sm.on_ground = false;
    }
}

pub fn terrain_collision(hb: *rl.Rectangle, cr: *rl.Rectangle) bool {
    for (0..global.TERRAIN_RECTANGLES.len) |i| {
        if (rl.checkCollisionRecs(hb.*, global.TERRAIN_RECTANGLES[i])) {
            cr.* = global.TERRAIN_RECTANGLES[i];
            return true;
        }
    }
    return false;
}

pub fn boulder_collision(boulder: *Boulder, cr: *rl.Rectangle) bool {
    for (0..global.TERRAIN_RECTANGLES.len) |i| {
        if (rl.checkCollisionCircleRec(boulder.position, boulder.size, global.TERRAIN_RECTANGLES[i])) {
            cr.* = global.TERRAIN_RECTANGLES[i];
            return true;
        }
    }
    return false;
}

pub fn stickman_boulder_collision(boulder: *Boulder, hb: *rl.Rectangle) void {
    if (rl.checkCollisionCircleRec(boulder.position, boulder.size, hb.*)) {
        global.GAME_ENDS = true;
    }
}
