if (toggleLockFrames > 0) {
    toggleLockFrames -= 1;
}

if (transition_is_active()) {
    exit;
}

var keyPause = keyboard_check_pressed(vk_escape);

if (!paused) {
    if (keyPause && toggleLockFrames <= 0) {
        openPAUSE();
    }
    exit;
}

if (optionsOpen) {
    if (!instance_exists(oOptionsMenu)) {
        optionsOpen = false;
    }
    exit;
}

var keyUp = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var keyDown = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var keyConfirm = keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(ord("Z"));

if (keyUp) {
    selectedIndex = (selectedIndex - 1 + array_length(menuItems)) mod array_length(menuItems);
}
else if (keyDown) {
    selectedIndex = (selectedIndex + 1) mod array_length(menuItems);
}

if (keyPause) {
    closePAUSE();
    exit;
}

if (keyConfirm) {
    activateSELECTED();
}
