var guiWidth = display_get_gui_width();
var guiHeight = display_get_gui_height();

var panelWidth = min(guiWidth * 0.86, 900);
var panelHeight = min(guiHeight * 0.86, 620);
var panelX1 = (guiWidth - panelWidth) * 0.5;
var panelY1 = (guiHeight - panelHeight) * 0.5;
var panelX2 = panelX1 + panelWidth;
var panelY2 = panelY1 + panelHeight;

var panelInset = 16;
var contentX = panelX1 + 42;
var contentY = panelY1 + 132;

draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, guiWidth, guiHeight, false);

draw_set_alpha(0.95);
draw_set_color(make_color_rgb(20, 24, 36));
draw_rectangle(panelX1, panelY1, panelX2, panelY2, false);

draw_set_alpha(1);
draw_set_color(make_color_rgb(230, 230, 250));
draw_rectangle(panelX1 + panelInset, panelY1 + panelInset, panelX2 - panelInset, panelY2 - panelInset, true);

if (pageIndex == 0) {
    draw_sprite_stretched(sOptionsBgAudio, 0, panelX1 + panelInset, panelY1 + panelInset, panelWidth - panelInset * 2, panelHeight - panelInset * 2);
}
else if (pageIndex == 1) {
    draw_sprite_stretched(sOptionsBgDisplay, 0, panelX1 + panelInset, panelY1 + panelInset, panelWidth - panelInset * 2, panelHeight - panelInset * 2);
}
else {
    draw_sprite_stretched(sOptionsBgControls, 0, panelX1 + panelInset, panelY1 + panelInset, panelWidth - panelInset * 2, panelHeight - panelInset * 2);
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(guiWidth * 0.5, panelY1 + 46, "OPTIONS");

var tabY = panelY1 + 88;
for (var i = 0; i < array_length(pages); i++) {
    var tabX = guiWidth * 0.5 + ((i - 1) * 190);
    var isCurrentTab = (i == pageIndex);

    draw_set_color(isCurrentTab ? c_yellow : c_white);
    draw_text(tabX, tabY, pages[i]);
}

draw_set_halign(fa_left);
draw_set_valign(fa_middle);

if (pageIndex == 0) {
    var volumeValue = global.SAVE.SETTINGS.MASTER_VOLUME;
    var rowY = contentY + 40;

    draw_set_color(selectedIndex == 0 ? c_yellow : c_white);
    draw_text(contentX, rowY, "MASTER VOLUME");

    var sliderX = contentX + 330;
    var sliderY = rowY;
    var sliderW = 320;
    var sliderH = 18;

    draw_set_color(make_color_rgb(50, 60, 90));
    draw_rectangle(sliderX, sliderY - sliderH * 0.5, sliderX + sliderW, sliderY + sliderH * 0.5, false);

    draw_set_color(make_color_rgb(105, 200, 255));
    draw_rectangle(sliderX + 2, sliderY - (sliderH * 0.5) + 2, sliderX + 2 + ((sliderW - 4) * volumeValue), sliderY + (sliderH * 0.5) - 2, false);

    draw_set_color(c_white);
    draw_text(sliderX + sliderW + 24, rowY, string(round(volumeValue * 100)) + "%");

    draw_set_halign(fa_center);
    draw_text(guiWidth * 0.5, panelY2 - 58, "LEFT / RIGHT: ADJUST   Q/E OR TAB: CHANGE PAGE");
}
else if (pageIndex == 1) {
    var rowY2 = contentY + 40;
    var fullText = global.SAVE.SETTINGS.FULLSCREEN ? "ON" : "OFF";

    draw_set_color(selectedIndex == 0 ? c_yellow : c_white);
    draw_text(contentX, rowY2, "FULLSCREEN");

    draw_set_halign(fa_right);
    draw_text(panelX2 - 70, rowY2, fullText);

    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(guiWidth * 0.5, panelY2 - 58, "ENTER OR LEFT/RIGHT: TOGGLE   Q/E OR TAB: CHANGE PAGE");
}
else {
    draw_set_color(c_white);
    draw_text(contentX, contentY + 10, "MOVE: ARROW KEYS / WASD");
    draw_text(contentX, contentY + 50, "JUMP: SPACE");
    draw_text(contentX, contentY + 90, "PUNCH: Z");
    draw_text(contentX, contentY + 130, "THROW HALO: X");
    draw_text(contentX, contentY + 170, "FLY: F");
    draw_text(contentX, contentY + 210, "RUN: SHIFT");

    draw_set_halign(fa_center);
    draw_text(guiWidth * 0.5, panelY2 - 58, "Q/E OR TAB: CHANGE PAGE");
}

draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(guiWidth * 0.5, panelY2 - 26, "ESC OR X: BACK");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
