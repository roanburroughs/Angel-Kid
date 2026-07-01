// Step through the timeline
timer++;

switch(state) {
    case 0: // Wipe In 
        if (timer >= wipe_duration) {
            state = 1;
            timer = 0;
        }
        break;
        
    case 1: // Hold on Loading Screen
        if (timer >= hold_duration) {
            state = 2;
            timer = 0;
             
            if (surface_exists(global.snapshot)) surface_free(global.snapshot);//Deletes the screenshot since we dont need it anymore and it'll just add clutter to ram
        }
        break;
        
    case 2: // Wipe Out  
        if (timer >= wipe_duration) {
            if (surface_exists(transition_surface)) surface_free(transition_surface);//Deletes the screenshot since we dont need it anymore and it'll just add clutter to ram
            instance_destroy(); //Its over so destroy it
        }
        break;
}

// Animate the loading clock  
frame += sprite_get_speed(sLoadingClock) / game_get_speed(gamespeed_fps);