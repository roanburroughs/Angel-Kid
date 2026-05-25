/// @desc Options menu overlay used from both Main Menu and Pause Menu.

callerId = noone;

pageIndex = 0;
pages = ["AUDIO", "DISPLAY", "CONTROLS"];
selectedIndex = 0;

getITEM_COUNT = function() {
    switch (pageIndex) {
        case 0: return 1;
        case 1: return 1;
        default: return 0;
    }
};

closeMENU = function() {
    if (instance_exists(callerId)) {
        with (callerId) {
            optionsOpen = false;
        }
    }

    instance_destroy();
};

changePAGE = function(_direction) {
    pageIndex = (pageIndex + _direction + array_length(pages)) mod array_length(pages);
    selectedIndex = 0;
};

setMASTER_VOLUME = function(_value) {
    global.SAVE.SETTINGS.MASTER_VOLUME = clamp(_value, 0, 1);
    saveSETTINGS();
};

toggleFULLSCREEN = function() {
    global.SAVE.SETTINGS.FULLSCREEN = !global.SAVE.SETTINGS.FULLSCREEN;
    saveSETTINGS();
};
