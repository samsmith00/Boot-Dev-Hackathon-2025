const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Stick_Man_Module = @import("stickMan.zig");
const global = @import("constants.zig");
const Hit_Box_Module = @import("hitbox.zig");

const Stick_Man = Stick_Man_Module.Stick_Man;

pub fn gravity(sm: *Stick_Man, hb: *rl.Rectangle, tr: rl.Rectangle, dt: f32) void {
    _ = tr;

    sm.velocity.y += global.GRAVITY * dt * global.GRAVITY_ACCELERATION;
    sm.position.y += sm.velocity.y * dt * global.JUMP_ACCELERATION;

    var colliding_rect: rl.Rectangle = undefined;
    const is_colliding = terrain_collision(hb, &colliding_rect);
    const jumping = sm.velocity.y < 0;

    if (is_colliding and !jumping) {
        sm.position.y = colliding_rect.y - hb.height - global.HITBOX_Y_OFFSET + 1;
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
