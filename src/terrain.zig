const std = @import("std");
const rl = @import("raylib");
const Vector2 = rl.Vector2;

const Stick_Man_Module = @import("stickMan.zig");
const global = @import("constants.zig");

const Stick_Man = Stick_Man_Module.Stick_Man;

pub fn init() rl.Rectangle {
    return rl.Rectangle{
        .x = 0,
        .y = global.sh - 100,
        // ...
        .width = 30,
        .height = 10,
    };
}

pub fn generate_terrain() void {
    const rect_width: f32 = 120.0;
    const rect_height: f32 = 25;
    const num_of_recs: usize = @intFromFloat(global.SCREEN_WIDTH / rect_width);

    var x_pos: f32 = 0;
    var y_pos: f32 = global.sh - 50.0; // Start height of terrain

    //    var terrain_rectangles: [num_of_recs]rl.Rectangle = undefined;

    for (0..num_of_recs) |i| {
        const tr = rl.Rectangle{
            .x = x_pos,
            .y = y_pos,
            .width = rect_width,
            .height = rect_height,
        };
        global.TERRAIN_RECTANGLES[i] = tr;

        rl.drawRectangleRec(tr, rl.Color.black);

        x_pos += rect_width;
        y_pos -= 22; // Create slope by raising y gradually
    }
    const last_rect = global.TERRAIN_RECTANGLES[num_of_recs - 1];
    const xf = last_rect.x + rect_width;
    const yf = last_rect.y - rect_height;
    const x: i32 = @intFromFloat(xf);
    const y: i32 = @intFromFloat(yf);
    rl.drawRectangle(x, y, rect_width, rect_height, rl.Color.black);
}
