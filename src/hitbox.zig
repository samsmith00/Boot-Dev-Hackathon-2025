const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Stick_Man_Module = @import("stickMan.zig");
const global = @import("constants.zig");
const gravity = @import("physics.zig");
const terrain = @import("terrain.zig");

const Stick_Man = Stick_Man_Module.Stick_Man;

pub fn init() rl.Rectangle {
    return rl.Rectangle{
        .x = global.BODY_TOP_X + global.HITBOX_X_OFFSET,
        .y = global.BODY_TOP_Y + global.HITBOX_Y_OFFSET,
        // ...
        .width = global.HITBOX_WIDTH,
        .height = global.HITBOX_HEIGHT,
    };
}
