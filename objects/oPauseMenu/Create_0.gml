/// @desc Gameplay pause menu overlay.

menuItems = ["RESUME", "OPTIONS", "RESTART STAGE", "QUIT TO MAIN MENU"];
selectedIndex = 0;

paused = false;
optionsOpen = false;
toggleLockFrames = 0;

openPAUSE = function() {
    paused = true;
    optionsOpen = false;
    selectedIndex = 0;
    toggleLockFrames = 8;

    instance_deactivate_all(true);
};

closePAUSE = function() {
    instance_activate_all();

    paused = false;
    optionsOpen = false;
    toggleLockFrames = 8;
};

activateSELECTED = function() {
    var selectedLabel = menuItems[selectedIndex];

    switch (selectedLabel) {
        case "RESUME":
            closePAUSE();
        break;

        case "OPTIONS":
            if (!optionsOpen) {
                var optionsInstance = instance_create_layer(0, 0, "Instances", oOptionsMenu);
                optionsInstance.callerId = id;
                optionsOpen = true;
            }
        break;

        case "RESTART STAGE":
            instance_activate_all();
            room_restart();
        break;

        case "QUIT TO MAIN MENU":
            instance_activate_all();
            transition_goto(rmMainMenu, 0.5, 0.5, 60, 50, shdSonicFadeToBlackTransition);
        break;
    }
};
