const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Stick_Man_Module = @import("stickMan.zig");
const global = @import("constants.zig");
const hitbox = @import("hitbox.zig");

const Stick_Man = Stick_Man_Module.Stick_Man;
const Hit_Box = hitbox.Hitbox;

pub fn draw(sm: Stick_Man, hb: rl.Rectangle) void {
    const base = sm.position;

    // Draw Body
    const b_top = Vector2.init(base.x, base.y);
    const b_bottom = Vector2.init(base.x, base.y + global.BODY_LENGTH);

    rl.drawLineEx(b_top, b_bottom, 2, rl.Color.black);

    // Draw Head
    for (1..3) |i| {
        const offset: f32 = @floatFromInt(i);
        const x, const y = convert_to_int32(base.x, base.y);
        rl.drawCircleLines(x, y - global.HEAD_Y_OFFSET, 10 - offset, rl.Color.black);
    }

    // Draw Right Arm
    const t_arm_start_r = Vector2.init(base.x, base.y + global.ARM_Y_OFFSET);
    const t_arm_end_r = draw_limb_helper(sm, t_arm_start_r, sm.right_arm_top.length, sm.right_arm_top.angle);
    rl.drawLineEx(t_arm_start_r, t_arm_end_r, 2, rl.Color.black);

    const b_arm_end_r = draw_limb_helper(sm, t_arm_end_r, sm.right_arm_bottom.length, sm.right_arm_bottom.angle);
    rl.drawLineEx(t_arm_end_r, b_arm_end_r, 2, rl.Color.black);

    // Draw Left Arm
    const t_arm_start_l = Vector2.init(base.x, base.y + global.ARM_Y_OFFSET);
    const t_arm_end_l = draw_limb_helper(sm, t_arm_start_l, sm.left_arm_top.length, sm.left_arm_top.angle);
    rl.drawLineEx(t_arm_start_l, t_arm_end_l, 2, rl.Color.black);

    const b_arm_end_l = draw_limb_helper(sm, t_arm_end_l, sm.left_arm_bottom.length, sm.left_arm_bottom.angle);
    rl.drawLineEx(t_arm_end_l, b_arm_end_l, 2, rl.Color.black);

    //Draw Right Leg
    const t_leg_start_r = Vector2.init(base.x, b_bottom.y);
    const t_leg_end_r = draw_limb_helper(sm, t_leg_start_r, sm.right_leg_top.length, sm.right_leg_top.angle);
    rl.drawLineEx(t_leg_start_r, t_leg_end_r, 2, rl.Color.black);

    const b_leg_end_r = draw_limb_helper(sm, t_leg_end_r, sm.right_leg_bottom.length, sm.right_leg_bottom.angle);
    rl.drawLineEx(t_leg_end_r, b_leg_end_r, 2, rl.Color.black);

    // Draw Left Leg
    const t_leg_start_l = Vector2.init(base.x, b_bottom.y);
    const t_leg_end_l = draw_limb_helper(sm, t_leg_start_l, sm.left_leg_top.length, sm.left_leg_top.angle);
    rl.drawLineEx(t_leg_start_l, t_leg_end_l, 2, rl.Color.black);

    const b_leg_end_l = draw_limb_helper(sm, t_leg_end_l, sm.left_leg_bottom.length, sm.left_leg_bottom.angle);
    rl.drawLineEx(t_leg_end_l, b_leg_end_l, 2, rl.Color.black);

    // ---------------------------- Draw Hit_Box -------------------------------------------------
    _ = hb;
    //draw_hit_box(hb);
}

fn draw_limb_helper(sm: Stick_Man, start: Vector2, length: f32, angle: f32) Vector2 {
    const x = start.x + std.math.cos(angle) * length * sm.facing;
    const y = start.y + std.math.sin(angle) * length;

    return Vector2.init(x, y);
}

fn convert_to_int32(a: f32, b: f32) [2]i32 {
    const x: i32 = @intFromFloat(a);
    const y: i32 = @intFromFloat(b);
    return .{ x, y };
}

fn draw_hit_box(hb: rl.Rectangle) void {
    const x: i32 = @intFromFloat(hb.x);
    const y: i32 = @intFromFloat(hb.y);
    const width: i32 = @intFromFloat(hb.width);
    const height: i32 = @intFromFloat(hb.height);

    rl.drawRectangleLines(x, y, width, height, rl.Color.red);
}
