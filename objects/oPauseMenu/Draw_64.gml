if (!paused) {
    exit;
}

var guiWidth = display_get_gui_width();
var guiHeight = display_get_gui_height();

var panelWidth = min(guiWidth * 0.72, 720);
var panelHeight = min(guiHeight * 0.72, 560);
var panelX1 = (guiWidth - panelWidth) * 0.5;
var panelY1 = (guiHeight - panelHeight) * 0.5;
var panelX2 = panelX1 + panelWidth;
var panelY2 = panelY1 + panelHeight;

draw_set_alpha(0.6);
draw_set_color(c_black);
draw_rectangle(0, 0, guiWidth, guiHeight, false);

draw_set_alpha(0.94);
draw_set_color(make_color_rgb(12, 18, 28));
draw_rectangle(panelX1, panelY1, panelX2, panelY2, false);

draw_set_alpha(1);
draw_set_color(make_color_rgb(214, 228, 255));
draw_rectangle(panelX1 + 14, panelY1 + 14, panelX2 - 14, panelY2 - 14, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(guiWidth * 0.5, panelY1 + 58, "PAUSED");

var startY = panelY1 + 148;
var spacingY = 68;
for (var i = 0; i < array_length(menuItems); i++) {
    var y = startY + i * spacingY;
    var isCurrent = (i == selectedIndex);

    draw_set_color(isCurrent ? c_yellow : c_white);
    draw_text(guiWidth * 0.5, y, menuItems[i]);
}

draw_set_color(c_white);
draw_text(guiWidth * 0.5, panelY2 - 44, "ARROWS/WASD: MOVE   ENTER/Z: SELECT   ESC: RESUME");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
