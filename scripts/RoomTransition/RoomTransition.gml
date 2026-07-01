function RoomTransition(_targetRoom) {
    var _w = surface_get_width(application_surface);
    var _h = surface_get_height(application_surface);
    
    if (!variable_global_exists("snapshot")) global.snapshot = -1;
    if (!surface_exists(global.snapshot)) {
        global.snapshot = surface_create(_w, _h);
    }
    
 
    surface_set_target(global.snapshot);
    draw_surface(application_surface, 0, 0);
    surface_reset_target();
    
    // Spawn the persistent controller
    instance_create_depth(0, 0, -9999, oLoadingScreen);
    
    if (_targetRoom != noone) {
        room_goto(_targetRoom);
    }
}