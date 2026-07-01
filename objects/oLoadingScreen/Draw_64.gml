var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var clockx =_gw/2
var clocky =_gh/2
var clockscale=3
if (!surface_exists(transition_surface)) {
    transition_surface = surface_create(_gw, _gh);
}

//Drawing the loading screen before its cut out
if (state == 0) {
 
    draw_self(); 
    draw_sprite_ext(sLoadingClock, frame, clockx, clocky, clockscale, clockscale, 0, c_white, 1);
}
 
 //Draw Wipe Hole
if (state == 0 || state == 2) {
    surface_set_target(transition_surface);
    draw_clear_alpha(c_black, 0);
    
    // Draw the screenshot we took of the previous room
    if (state == 0) {
        if (surface_exists(global.snapshot)) {
            draw_surface_stretched(global.snapshot, 0, 0, _gw, _gh);
        }
    } else if (state == 2) {
        draw_self();
        draw_sprite_ext(sLoadingClock, frame, clockx, clocky, clockscale, clockscale, 0, c_white, 1);
    }
    
    // Change mode to erase
gpu_set_blendmode(bm_subtract);
    draw_set_color(c_white);
     
    var _cx = _gw / 2;
    var _cy = _gh / 2;
     
    var _max_radius = point_distance(_cx, _cy, 0, 0); 
    
    // The Radial Wipe
    var _progress = timer / wipe_duration;
    var _current_radius = _progress * _max_radius;
    
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_cx, _cy); // Center origin vertex
    
    // Draw circle segments for current radius 
    var _segments = 36;
    for (var i = 0; i <= _segments; i++) {
        var _angle = i * (360 / _segments);
        
        draw_vertex(_cx + lengthdir_x(_current_radius, _angle), _cy + lengthdir_y(_current_radius, _angle));
    }
    draw_primitive_end();
    
    // Reset  
    gpu_set_blendmode(bm_normal);
    surface_reset_target();
    
    // Draw the completed top layer ( 
    draw_surface(transition_surface, 0, 0);
}

//Holding state
if (state == 1) {
    draw_self();
    draw_sprite_ext(sLoadingClock, frame, clockx, clocky, clockscale, clockscale, 0, c_white, 1);
}