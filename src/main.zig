const std = @import("std");
const global = @import("constants.zig");
const stick_man_mod = @import("stickMan.zig");
const draw_mod = @import("draw.zig");
const update_mod = @import("update.zig");
const Hit_Box = @import("hitbox.zig");
const Terrain = @import("terrain.zig");
const Hazards = @import("hazards.zig");
const Physics = @import("physics.zig");
const Scatter_Limbs_Module = @import("scatter_limbs.zig");

const rl = @import("raylib");
const Stick_Man = stick_man_mod.Stick_Man;

pub fn main() anyerror!void {
    // // Initialization
    // //--------------------------------------------------------------------------------------
    // rl.setConfigFlags(.{ .window_highdpi = false }); // Disable DPI scaling
    // const screenWidth = rl.getMonitorWidth(0); // Get primary monitor width
    // const screenHeight = rl.getMonitorHeight(0); // Get primary monitor height
    // rl.initWindow(screenWidth, screenHeight, global.TITLE);
    // defer rl.closeWindow(); // Close window and OpenGL context
    //
    // rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    // //--------------------------------------------------------------------------------------
    //
    // Initialization
    //--------------------------------------------------------------------------------------

    rl.setConfigFlags(.{ .window_resizable = true }); // Optional: lets you resize
    const screenWidth = rl.getMonitorWidth(0);
    const screenHeight = rl.getMonitorHeight(0);

    rl.initWindow(screenWidth, screenHeight, global.TITLE);
    rl.toggleFullscreen(); // Enter fullscreen, using screen's actual resolution    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------
    var stick_man = Stick_Man.init();
    var hit_box = Hit_Box.init();
    const terrain = Terrain.init();

    var boulder_spawn_timer: f32 = 0;
    var boulder_spawn_delay: f32 = try Hazards.generate_boulder_frequency();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var boulders = try Hazards.make_boulder_list(allocator);
    defer boulders.deinit();

    var lazer_timer: f32 = 0;
    var lazer_delay = try Hazards.generate_boulder_frequency();
    var lazers = Hazards.get_lazer_list(allocator);
    defer lazers.deinit();

    var limbs = std.ArrayList(Scatter_Limbs_Module.Detached_Limb).init(allocator);
    defer limbs.deinit();

    var exitWindow: bool = false;

    // Main game loop
    while (!exitWindow) { // Detect window close button or ESC key
        const dt = rl.getFrameTime();
        if (!global.GAME_ENDS) {
            boulder_spawn_timer += dt;
            if (boulder_spawn_timer >= boulder_spawn_delay) {
                const size = try Hazards.get_boulder_size();
                const speed = try Hazards.get_boulder_speed();
                const pos = try Hazards.get_boulder_pos();
                const new_boulder = try Hazards.init_boulder(pos, size, speed);
                try boulders.append(new_boulder);

                boulder_spawn_timer = 0;
                boulder_spawn_delay = try Hazards.generate_boulder_frequency(); // get next delay
            }

            lazer_timer += dt;
            if (lazer_timer >= lazer_delay) {
                const lazer_pos = try Hazards.calc_lazer_spawn_radius(&stick_man);
                const lazer = Hazards.init_lazer_beam(lazer_pos);
                try lazers.append(lazer);

                lazer_timer = 0;
                lazer_delay = try Hazards.generate_boulder_frequency();
            }
        }

        // Update
        //----------------------------------------------------------------------------------
        if (!global.GAME_ENDS) {
            try update_mod.update(&stick_man, &hit_box, terrain, &boulders, &lazers, &limbs, dt);
            try draw_mod.draw(&stick_man, hit_box, &boulders, &lazers, &limbs);
        }
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        rl.clearBackground(.white);
        if (global.GAME_ENDS) {
            _ = lazers.clearRetainingCapacity();
            _ = boulders.clearRetainingCapacity();
            // const x: i32 = @divTrunc(screenWidth, 2) - 100;
            // const y: i32 = @divTrunc(screenHeight, 2);
            Scatter_Limbs_Module.draw_scattered_limbs(&limbs);
            rl.drawText("Oh no, you died!! {q} to quit or {r} to restart", @divTrunc(screenWidth, 2), @divTrunc(screenHeight, 2), 20, rl.Color.red);
            if (rl.isKeyPressed(.q)) {
                exitWindow = true;
            }
            if (rl.isKeyPressed(.r)) {
                global.GAME_ENDS = false;
            }
        }

        // else {
        //     try draw_mod.draw(&stick_man, hit_box, &boulders, &lazers, &limbs);
        // }

        rl.endDrawing();
    }
}

