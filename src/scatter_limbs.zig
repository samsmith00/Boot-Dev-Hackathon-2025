const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Stick_Man_Module = @import("stickMan.zig");
const global = @import("constants.zig");
const Hit_Box_Module = @import("hitbox.zig");

const Stick_Man = Stick_Man_Module.Stick_Man;

const LimbType = enum {
    Head,
    Arm,
    Leg,
    Torso,
};

const ALL_LIMB_TYPES = [_]LimbType{
    .Head,
    .Arm,
    .Leg,
    .Torso,
};

pub const Detached_Limb = struct {
    type: LimbType,
    position: Vector2,
    velocity: Vector2,
    // ...
    rotation: f32,
    size: f32,
    color: rl.Color,
};

// pub fn init(limbs: *std.ArrayList(Detached_Limb), sm: *Stick_Man) void {
//     const kick = Vector2.init(random_range(-200, 200), random_range(-300, -100));
//     for (0..5) |i|{
//         try limbs.append(
//         Detached_Limb {
//             .kind = ALL_LIMB_TYPES[i],
//             .position = sm.head_center,
//             .velocity = kick,
//             .rotation = 10
//
//         }
//     )
//     }
// }
//
// pub fn scatter_limbs(sm: *Stick_Man) void {}
