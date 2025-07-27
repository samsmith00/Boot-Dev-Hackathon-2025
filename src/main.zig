const std = @import("std");
const global = @import("constants.zig");
const stick_man_mod = @import("stickMan.zig");
const draw_mod = @import("draw.zig");
const update_mod = @import("update.zig");
const Hit_Box = @import("hitbox.zig");
const Terrain = @import("terrain.zig");
const Hazards = @import("hazards.zig");
const Physics = @import("physics.zig");
const Limb = @import("scatter_limbs.zig");

const rl = @import("raylib");
const Stick_Man = stick_man_mod.Stick_Man;

//const Boulder = undefined;

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
    var hit_box = Hit_Box.init();
    const terrain = Terrain.init();

    var boulder_spawn_timer: f32 = 0;
    var boulder_spawn_delay: f32 = try Hazards.generate_boulder_frequency();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var boulders = try Hazards.make_boulder_list(allocator);

    var lazer_timer: f32 = 0;
    var lazer_delay = try Hazards.generate_boulder_frequency();
    var lazers = Hazards.get_lazer_list(allocator);

    //var limbs = std.ArrayList(allocator).init(Limb.Detached_Limb);

    var exitWindow: bool = false;

    // Main game loop
    while (!exitWindow) { // Detect window close button or ESC key
        const dt = rl.getFrameTime();

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

        // Update
        //----------------------------------------------------------------------------------

        update_mod.update(&stick_man, &hit_box, terrain, &boulders, &lazers, dt);

        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);

        // Draw stick man to screen
        draw_mod.draw(stick_man, hit_box, &boulders, &lazers);

        // Check for end game
        if (global.GAME_ENDS) {
            exitWindow = true;
        }

        //rl.drawText("Congrats! You created your first window!", 190, 200, 20, .light_gray);
        //----------------------------------------------------------------------------------
    }
}
