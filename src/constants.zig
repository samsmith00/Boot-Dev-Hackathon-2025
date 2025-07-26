const std = @import("std");

pub const SCREEN_WIDTH: u32 = 1280;
pub const SCREEN_HEIGHT: u32 = 720;

pub const TITLE = "Getting Over It";

pub const PLAYER_SPEED: f32 = 3.0;

// Convert screen width/height to f32
const sw: f32 = @floatFromInt(SCREEN_WIDTH);
const sh: f32 = @floatFromInt(SCREEN_HEIGHT);

pub const MAX_SWING_ANGLE: f32 = std.math.pi;

// STICK MAN LIMB POSITION
pub const BODY_TOP_X: f32 = sw / 2.0;
pub const BODY_TOP_Y: f32 = sh / 2.0;
pub const BODY_LENGTH: f32 = 29.0;

pub const HEAD_CENTER_X: f32 = BODY_TOP_X;
pub const HEAD_CENTER_Y: f32 = BODY_TOP_Y - 15.0;
pub const HEAD_RADIUS: f32 = 13.0;
pub const HEAD_Y_OFFSET: i32 = 8;

pub const ARM_TOP_X: f32 = BODY_TOP_X;
pub const ARM_TOP_Y: f32 = BODY_TOP_Y + 5.0;
pub const ARM_Y_OFFSET: f32 = 5.0;
pub const ARM_SEGMENT_LENGTH: f32 = 12.0;
pub const ARM_TOP_ANGLE_RIGHT: f32 = std.math.pi / 4.0;
pub const ARM_TOP_ANGLE_LEFT: f32 = 3 * std.math.pi / 4.0;
pub const ARM_BOTTOM_ANGLE_RIGHT: f32 = std.math.pi / 2.0;
pub const ARM_BOTTOM_ANGLE_LEFT: f32 = std.math.pi / 2.0;

pub const LEG_TOP_X: f32 = BODY_TOP_X;
pub const LEG_TOP_Y: f32 = BODY_TOP_X + BODY_LENGTH;
pub const LEG_SEGMENT_LENGTH: f32 = 15.0;
pub const LEG_TOP_ANGLE_RIGHT: f32 = std.math.pi / 3.0;
pub const LEG_TOP_ANGLE_LEFT: f32 = 4 * std.math.pi / 6.0;
pub const LEG_BOTTOM_ANGLE_RIGHT: f32 = std.math.pi / 3.0;
pub const LEG_BOTTOM_ANGLE_LEFT: f32 = 4 * std.math.pi / 6.0;

pub const JUMP_HEIGHT: f32 = -15;
pub const JUMP_ACCELERATION: f32 = 12.0;
pub const GRAVITY: f32 = 4.0;
pub const GRAVITY_ACCELERATION: f32 = 14.0;
