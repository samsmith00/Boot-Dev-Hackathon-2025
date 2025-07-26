const std = @import("std");
const global = @import("constants.zig");
const stick_man_mod = @import("stickMan.zig");
const draw_mod = @import("draw.zig");
const update_mod = @import("update.zig");

const rl = @import("raylib");
const Stick_Man = stick_man_mod.Stick_Man;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = global.SCREEN_WIDTH;
    const screenHeight = global.SCREEN_HEIGHT;

    rl.initWindow(screenWidth, screenHeight, global.TITLE);
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    var stick_man = Stick_Man.init();

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        const dt = rl.getFrameTime();
        // Update
        //----------------------------------------------------------------------------------
        update_mod.update(&stick_man, dt);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);

        // Draw stick man to screen
        draw_mod.draw(stick_man);

        //rl.drawText("Congrats! You created your first window!", 190, 200, 20, .light_gray);
        //----------------------------------------------------------------------------------
    }
}
