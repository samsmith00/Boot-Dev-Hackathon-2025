const std = @import("std");
const rl = @import("raylib");
const global = @import("constants.zig");
const Vector2 = rl.Vector2;

pub const limb = struct { length: f32, angle: f32 };

pub const Stick_Man = struct {
    position: Vector2,
    velocity: Vector2,
    head_center: Vector2,
    head_radius: f32,
    body_start: Vector2,
    body_end: Vector2,
    right_arm_top: limb,
    right_arm_bottom: limb,
    left_arm_top: limb,
    left_arm_bottom: limb,
    right_leg_top: limb,
    right_leg_bottom: limb,
    left_leg_top: limb,
    left_leg_bottom: limb,
    facing: f32,
    first_jump: bool,
    second_jump: bool,
    animation_phase: f32,

    pub fn init() Stick_Man {
        return Stick_Man{
            .position = Vector2.init(global.BODY_TOP_X, global.BODY_TOP_Y),
            .velocity = Vector2.init(0, 0),
            // ... -> keeps nvim from collapsing struct
            .head_center = Vector2.init(global.HEAD_CENTER_X, global.HEAD_CENTER_Y),
            .head_radius = global.HEAD_RADIUS,
            .body_start = Vector2.init(global.BODY_TOP_X, global.BODY_TOP_Y),
            .body_end = Vector2.init(global.BODY_TOP_X, global.BODY_TOP_Y + global.BODY_LENGTH),
            // ...
            .right_arm_top = limb{ .length = global.ARM_SEGMENT_LENGTH, .angle = global.ARM_TOP_ANGLE_RIGHT },
            .right_arm_bottom = limb{ .length = global.ARM_SEGMENT_LENGTH, .angle = global.ARM_BOTTOM_ANGLE_RIGHT },
            // ...
            .left_arm_top = limb{ .length = global.ARM_SEGMENT_LENGTH, .angle = global.ARM_TOP_ANGLE_LEFT },
            .left_arm_bottom = limb{ .length = global.ARM_SEGMENT_LENGTH, .angle = global.ARM_BOTTOM_ANGLE_LEFT },
            // ...
            .right_leg_top = limb{ .length = global.LEG_SEGMENT_LENGTH, .angle = global.LEG_TOP_ANGLE_RIGHT },
            .right_leg_bottom = limb{ .length = global.LEG_SEGMENT_LENGTH, .angle = global.LEG_BOTTOM_ANGLE_RIGHT },
            // ...
            .left_leg_top = limb{ .length = global.LEG_SEGMENT_LENGTH, .angle = global.LEG_TOP_ANGLE_LEFT },
            .left_leg_bottom = limb{ .length = global.LEG_SEGMENT_LENGTH, .angle = global.LEG_BOTTOM_ANGLE_LEFT },
            .facing = 1,
            .first_jump = false,
            .second_jump = false,
            .animation_phase = 0.0,
        };
    }
};
