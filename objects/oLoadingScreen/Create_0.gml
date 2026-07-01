 
 
// Configuration
wipe_duration = 20; // How many frames each wipe takes
hold_duration = 40; // How many frames to stay on the loading screen

// State Machine tracking
state = 0;           
timer = 0;          // Progress for the wipe
frame = 0;          //Frames for the clock animation, since with draw_sprite_ext animations dont play automatically


transition_surface = -1;