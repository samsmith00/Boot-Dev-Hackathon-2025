const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Stick_Man_Module = @import("stickMan.zig");
const global = @import("constants.zig");

const Stick_Man = Stick_Man_Module.Stick_Man;

pub fn gravity(sm: *Stick_Man, dt: f32) void {
    sm.velocity.y += global.GRAVITY * dt * global.GRAVITY_ACCELERATION;
    sm.position.y += sm.velocity.y * dt;

    if (sm.position.y >= global.BODY_TOP_Y) {
        sm.position.y = global.BODY_TOP_Y;
        sm.velocity.y = 0;
        sm.first_jump = false;
        sm.second_jump = false;
    }
}
