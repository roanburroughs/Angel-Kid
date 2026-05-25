if (transition_is_active()) {
    exit;
}

var keyCancel = keyboard_check_pressed(vk_escape)
    || keyboard_check_pressed(vk_backspace)
    || keyboard_check_pressed(ord("X"));

if (keyCancel) {
    closeMENU();
    exit;
}

var keyPrevPage = keyboard_check_pressed(ord("Q")) || keyboard_check_pressed(vk_tab);
var keyNextPage = keyboard_check_pressed(ord("E"));

if (keyPrevPage) {
    changePAGE(-1);
}
else if (keyNextPage) {
    changePAGE(1);
}

var itemCount = getITEM_COUNT();
if (itemCount > 0) {
    var keyUp = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    var keyDown = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));

    if (keyUp) {
        selectedIndex = (selectedIndex - 1 + itemCount) mod itemCount;
    }
    else if (keyDown) {
        selectedIndex = (selectedIndex + 1) mod itemCount;
    }
}
else {
    selectedIndex = 0;
}

var keyLeft = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var keyRight = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var keyConfirm = keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(ord("Z"));

switch (pageIndex) {
    case 0:
        if (selectedIndex == 0) {
            var deltaVolume = 0;
            if (keyLeft) { deltaVolume = -0.05; }
            if (keyRight) { deltaVolume = 0.05; }

            if (deltaVolume != 0) {
                setMASTER_VOLUME(global.SAVE.SETTINGS.MASTER_VOLUME + deltaVolume);
            }
        }
    break;

    case 1:
        if (selectedIndex == 0 && (keyLeft || keyRight || keyConfirm)) {
            toggleFULLSCREEN();
        }
    break;
}
