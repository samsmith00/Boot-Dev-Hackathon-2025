const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Stick_Man_Module = @import("stickMan.zig");
const global = @import("constants.zig");
const gravity = @import("physics.zig");
const terrain = @import("terrain.zig");
const Hit_Box_Module = @import("hitbox.zig");

const Stick_Man = Stick_Man_Module.Stick_Man;

pub fn update(sm: *Stick_Man, hb: *rl.Rectangle, tr: rl.Rectangle, dt: f32) void {
    sm.animation_phase += dt;
    update_stickman(sm);
    update_hitbox(sm, hb);
    run(sm);
    jump(sm);
    gravity.gravity(sm, hb, tr, dt);
    terrain.generate_terrain();
}

fn run(sm: *Stick_Man) void {
    if (rl.isKeyDown(.d)) {
        sm.facing = 1;
        sm.position = sm.position.add(Vector2.init(1, 0).scale(global.PLAYER_SPEED));
        run_animation(sm);
    } else if (rl.isKeyDown(.a)) {
        sm.facing = -1;
        sm.position = sm.position.add(Vector2.init(-1, 0).scale(global.PLAYER_SPEED));
        run_animation(sm);
    } else if (rl.isKeyReleased(.d)) {
        stick_man_idle(sm);
    } else if (rl.isKeyReleased(.a)) {
        stick_man_idle(sm);
    }
}

fn jump(sm: *Stick_Man) void {
    if (rl.isKeyPressed(.space) and sm.first_jump == false) {
        sm.velocity.y += global.JUMP_HEIGHT;
        sm.first_jump = true;
        sm.on_ground = false;
    } else if (rl.isKeyPressed(.space) and sm.second_jump == false) {
        sm.velocity.y = 0;
        sm.velocity.y += global.JUMP_HEIGHT;
        sm.second_jump = true;
        sm.on_ground = false;
    }
}

fn update_stickman(sm: *Stick_Man) void {
    sm.position = sm.position.add(sm.velocity);

    // sm.right_arm_top.angle = std.math.sin(std.math.pi) * 1.2;
    // sm.right_arm_top.angle += 0.05;
}

fn run_animation(sm: *Stick_Man) void {
    const swing = std.math.sin(sm.animation_phase * 3.5);
    const swingL = std.math.sin((sm.animation_phase - 0.5) * 3.5);
    const clamped_swing = swing * swing; // cubic easing in/out (less floaty)
    const clamped_swingLA = swingL * swingL;

    const swing_legR = std.math.sin(sm.animation_phase * 3.5);
    const swing_legL = std.math.sin((sm.animation_phase - 0.5) * 3.5);
    const clamped_RL = swing_legR * swing_legR;
    const clamped_LL = swing_legL * swing_legL;

    // const forward_bend_factor: f32 = 1.2;
    // const backward_bend_factor = 0.5;
    var lower_leg_bendR: f32 = 0;
    var lower_leg_bendL: f32 = 0;

    // ---------------------------------------------- Arms ----------------------------------------------
    const elbow_bend_base: f32 = -1.2;
    const elbow_bend_amp: f32 = 0.2;
    const elbow_bend = elbow_bend_base + elbow_bend_amp * swing;
    const elbow_bendL = elbow_bend_base + elbow_bend_amp * swingL;

    sm.right_arm_top.angle = global.ARM_TOP_ANGLE_RIGHT + clamped_swing * global.MAX_SWING_ANGLE - 0.7;
    sm.right_arm_bottom.angle = sm.right_arm_top.angle + elbow_bend;

    sm.left_arm_top.angle = global.ARM_TOP_ANGLE_LEFT + clamped_swingLA * global.MAX_SWING_ANGLE - 1.6;
    sm.left_arm_bottom.angle = sm.left_arm_top.angle + elbow_bendL;

    // ---------------------------------------------- Legs ----------------------------------------------
    const knee_bend_base: f32 = 1;
    const knee_bend_amp: f32 = 0.1;
    const knee_bendR = knee_bend_base + knee_bend_amp * swing;
    const knee_bendL = knee_bend_base + knee_bend_amp * swingL;
    sm.right_leg_top.angle = global.LEG_TOP_ANGLE_RIGHT + clamped_RL * global.MAX_SWING_ANGLE - 1.3;
    sm.left_leg_top.angle = global.LEG_TOP_ANGLE_LEFT + clamped_LL * global.MAX_SWING_ANGLE - 2.2;
    lower_leg_bendR = sm.right_leg_top.angle + knee_bendR;
    lower_leg_bendL = sm.left_leg_top.angle + knee_bendL;

    sm.right_leg_bottom.angle = lower_leg_bendR;
    sm.left_leg_bottom.angle = lower_leg_bendL;
}

fn stick_man_idle(sm: *Stick_Man) void {
    sm.right_arm_top.angle = global.ARM_TOP_ANGLE_RIGHT;
    sm.right_arm_bottom.angle = global.ARM_BOTTOM_ANGLE_RIGHT;
    sm.left_arm_top.angle = global.ARM_TOP_ANGLE_LEFT;
    sm.left_arm_bottom.angle = global.ARM_BOTTOM_ANGLE_LEFT;

    sm.right_leg_top.angle = global.LEG_TOP_ANGLE_RIGHT;
    sm.right_leg_bottom.angle = global.LEG_BOTTOM_ANGLE_RIGHT;
    sm.left_leg_top.angle = global.LEG_TOP_ANGLE_LEFT;
    sm.left_leg_bottom.angle = global.LEG_BOTTOM_ANGLE_LEFT;
}

fn update_hitbox(sm: *Stick_Man, hb: *rl.Rectangle) void {
    // const x: i32 = @intFromFloat(sm.position.x);
    // const y: i32 = @intFromFloat(sm.position.y);
    hb.x = sm.position.x + global.HITBOX_X_OFFSET;
    hb.y = sm.position.y + global.HITBOX_Y_OFFSET;
}
