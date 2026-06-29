///@desc States

resetACTION_STATE = function() {
    attackApplied = false;
    chargeFrames = 0;
    currentAttackPower = ATTACK.POWER;
    haloThrown = false;
};

stateFREE = new stateFUNCS(function() {    
    // Movement logic
    SP.H = keyRIGHT - keyLEFT;
    SP.H *= keyRUN ? SP.RUN : SP.WALK;
    
    // Check if pushing something
    var dir = sign(SP.H);
    if (dir != 0 && array_length(PUSHABLE) > 0) {
        for (var i = 0; i < array_length(PUSHABLE); i += 1) {
            var pushInst = instance_place(x + (dir * 8), y, PUSHABLE[i]);
            if (pushInst != noone) {
                state = statePUSH;
                return;
            }
        }
    }
    
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
        if (keyJUMP) {
            SP.V = -SP.JUMP;
            state = stateJUMPING;
        }
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    move_and_collide(SP.H, SP.V, COLLISIONS);

    var isWALKING = (SP.H != 0);
    var isRUNNING = (isWALKING && keyRUN);
    var isLOOKING_UP = keyUP && !isWALKING;
    var isLOOKING_DOWN = keyDOWN && !isWALKING;

    if (isRUNNING) {
        if (sprite_index != SPRITES.RUN) {
            sprite_index = SPRITES.RUN;
            image_index = 0;
        }
    }
    else if (isWALKING) {
        if (sprite_index != SPRITES.WALK) {
            sprite_index = SPRITES.WALK;
            image_index = 0;
        }
    }
    else if (isLOOKING_UP) {
        if (sprite_index != SPRITES.LOOK.UP) {
            sprite_index = SPRITES.LOOK.UP;
            image_index = 0;
        }
    }
    else if (isLOOKING_DOWN) {
        if (sprite_index != SPRITES.LOOK.DOWN) {
            sprite_index = SPRITES.LOOK.DOWN;
            image_index = 0;
        }
    }
    else {
        if (sprite_index != SPRITES.IDLE) {
            sprite_index = SPRITES.IDLE;
            image_index = 0;
        }
    }
    if (SP.H != 0) {
        image_xscale = sign(SP.H);
    }

    if (keyFLY) {
        state = stateFLYING;
    }
    else if (keyHALO_PRESSED && !(haloInstanceId != noone)) {
        beginHALO_THROW();
    }
    else if (keyPUNCH_PRESSED) {
        chargeFrames = 0;
        state = isRUNNING ? stateSPIN_ATTACK : statePUNCH_CHARGING;
    }
    else if (keyPOSE) {
        state = stateGOOBER_POSE_SCARE;
    }
});

stateJUMPING = new stateFUNCS(function() {
    SP.H = keyRIGHT - keyLEFT;
    SP.H *= keyboard_check(vk_shift) ? SP.RUN : SP.WALK;
	
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;   
		audio_play_sound(SOUNDS.HIT_LANDED, 0, false);
		state = stateFREE;
		return;
    }
	
    if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
	
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if sprite_index != SPRITES.JUMP {
        sprite_index = SPRITES.JUMP;
        image_index = 0;
		audio_play_sound(SOUNDS.JUMP, 0, false);
    }
	if (SP.H != 0) {
        image_xscale = sign(SP.H);
    }
});

stateFLYING = new stateFUNCS(function() {
    SP.H = keyRIGHT - keyLEFT;
    SP.V = keyDOWN - keyUP;
    SP.H *= SP.FLY;
    SP.V *= SP.FLY;

    move_and_collide(SP.H, SP.V, COLLISIONS);

    // Transition to flying state
    if sprite_index != SPRITES.FLY {
        sprite_index = SPRITES.FLY;
        image_index = 0;
		audio_play_sound(SOUNDS.FLY, 0, false);
    }

    if !keyFLY {
        state = stateFREE;
    }
});

statePUNCH_CHARGING = new stateFUNCS(function() {
    SP.H = 0;
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    move_and_collide(SP.H, SP.V, COLLISIONS);
	
	chargeFrames++;
    if (sprite_index != SPRITES.PUNCH_CHARGE) {
        sprite_index = SPRITES.PUNCH_CHARGE;
        image_index = 0;
		audio_play_sound(SOUNDS.PUNCH_HOLD, 0, false);
    }

    if (keyPUNCH_RELEASED) {
        beginPUNCH();
    }
});

statePUNCHING = new stateFUNCS(function() {
    // Movement logic
    SP.H = 0;
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    move_and_collide(SP.H, SP.V, COLLISIONS);

    // Transition to punching state
    if sprite_index != SPRITES.PUNCH {
        sprite_index = SPRITES.PUNCH;
        image_index = 0;
    }
	
	var bonus = chargeFrames > ATTACK.CHARGE_TIME;
	var handWidth = sprite_get_width(sAK_PunchHand) * punchHandScale;
	var handHeight = sprite_get_height(sAK_PunchHand) * punchHandScale;
	if image_index >= 1
	{
		punchHandOffset = lerp(punchHandOffset, image_index >= 3 ?
			0 : image_xscale * (30 + bonus * 5), 0.2);
		
		punchHandScale = lerp(punchHandScale, image_index >= 3 ?
			0 : 1 + bonus * 3, 0.2);
	}
	
	var targets = [
        collision_rectangle(x + punchHandOffset, y - handHeight/2,
			x + punchHandOffset + handWidth, y + handHeight/2, oCageTemplate, false, true),
        collision_rectangle(x + punchHandOffset, y - handHeight/2,
			x + punchHandOffset + handWidth, y + handHeight/2, oEnemyTemplate, false, true)
    ];
	playerHIT_TARGETS(targets);
	
    if image_index >= image_number - 1 {
        chargeFrames = 0;
        currentAttackPower = ATTACK.POWER;
        state = stateFREE;
    }
}, function() {
	draw_self();
	if image_index < 1 || image_index >= 4 { return; }
	
	draw_sprite_ext(sAK_PunchHand, 0, x + punchHandOffset, y,
		punchHandScale * image_xscale, punchHandScale, 0, c_white, 1);
});

stateSPIN_ATTACK = new stateFUNCS(function()
{
	if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
	
	move_and_collide(SP.H, SP.V, COLLISIONS);
	
	var targets = [
        instance_place(x, y, oCageTemplate),
        instance_place(x, y, oEnemyTemplate),
    ];

    playerHIT_TARGETS(targets);
	
	if (sprite_index != SPRITES.SPIN_ATTACK) {
        sprite_index = SPRITES.SPIN_ATTACK;
        image_index = 0;
        image_speed = 1;
    }
	
	if image_index >= image_number - 1 {
        currentAttackPower = ATTACK.POWER;
        state = stateFREE;
    }
});

stateHALO_THROW = new stateFUNCS(function() {
    SP.H = 0;
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if (sprite_index != SPRITES.HALO_THROW) {
        sprite_index = SPRITES.HALO_THROW;
        image_index = 0;
        image_speed = 1;
    }
    else if (image_speed == 0) {
        image_speed = 1;
    }

    // Throw at specific frame (feels responsive)
	if (!haloThrown && image_index >= 13) {
	    haloThrown = true;
	    throwHALO();
	}

	// End animation
	if (image_index >= image_number - 1) {
	    state = stateFREE;
	}
});

stateAIR_TO_GROUND = new stateFUNCS(function() {
    // Movement logic
    SP.H = 0;
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    move_and_collide(SP.H, SP.V, COLLISIONS);

    // Transition from air to ground
    if sprite_index != SPRITES.IDLE {
        sprite_index = SPRITES.IDLE;
        image_index = 0;
		audio_play_sound(SOUNDS.HIT_LANDED, 0, false);
    }
    if image_index >= image_number - 1 {
        state = stateFREE;
    }
});

stateGOOBER_POSE_SCARE = new stateFUNCS(function() {
    SP.H = 0;
    SP.V = 0;
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if sprite_index != SPRITES.GOOBER_POSE_SCARE {
        sprite_index = SPRITES.GOOBER_POSE_SCARE;
        image_index = 0;
		audio_play_sound(SOUNDS.GOOBER_SCARE, 0, false);
    }
    if image_index >= image_number - 1 {
        state = stateFREE;
    }
});

stateHIT = new stateFUNCS(function() {
    if (sprite_index != SPRITES.HIT) {
        sprite_index = SPRITES.HIT;
        image_index = 0;
    }

    if (place_meeting(x, y + 2, COLLISIONS) && hurtVsp >= 0) {
        hurtVsp = 0;
    }
    else if (hurtVsp < SP.MAX_FALL) {
        hurtVsp += SP.GRV;
    }

    move_and_collide(hurtHsp, hurtVsp, COLLISIONS);

    hurtHsp = lerp(hurtHsp, 0, 0.2);
    if (abs(hurtHsp) < 0.05) {
        hurtHsp = 0;
    }

    hitstunFrames -= 1;
    if (hitstunFrames <= 0 && place_meeting(x, y + 2, COLLISIONS)) {
        hurtHsp = 0;
        hurtVsp = 0;
        state = stateFREE;
    }
});

stateDEAD = new stateFUNCS(function() {
    SP.H = 0;
    SP.V = 0;
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if sprite_index != SPRITES.DEATH {
        sprite_index = SPRITES.DEATH;
        image_index = 0;
    }

    if image_index >= image_number - 1 {
        recoverFROM_DEATH();
    }
});

stateVICTORY_DANCE = new stateFUNCS(function() {
    SP.H = 0;
    SP.V = 0;
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if sprite_index != SPRITES.VICTORY_DANCE {
        sprite_index = SPRITES.VICTORY_DANCE;
        image_index = 0;
    }
});

stateSWIMMING = new stateFUNCS(function() {
    // 4-directional swimming movement (similar to DK Country)
    SP.H = keyRIGHT - keyLEFT;
    SP.V = keyDOWN - keyUP;
    SP.H *= SP.SWIM;
    SP.V *= SP.SWIM;

    move_and_collide(SP.H, SP.V, COLLISIONS);

    // Transition to swimming state
    var isMoving = (SP.H != 0 || SP.V != 0);
    
    if (isMoving) {
        if (sprite_index != SPRITES.SWIM.MOVE) {
            sprite_index = SPRITES.SWIM.MOVE;
            image_index = 0;
        }
    } else {
        if (sprite_index != SPRITES.SWIM.IDLE) {
            sprite_index = SPRITES.SWIM.IDLE;
            image_index = 0;
        }
    }
    
    // Update sprite direction based on movement
    if (SP.H != 0) {
        image_xscale = sign(SP.H);
    }
});

statePUSH = new stateFUNCS(function() {
    // Push state - moving while pushing an object
    SP.H = keyRIGHT - keyLEFT;
    SP.H *= keyRUN ? SP.RUN : SP.WALK;
    
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
        if (keyJUMP) {
            SP.V = -SP.JUMP;
            state = stateJUMPING;
            return;
        }
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    
    // Push the object
    var dir = sign(SP.H);
    var pushing = false;
    if (dir != 0) {
        for (var i = 0; i < array_length(PUSHABLE); i += 1) {
            var inst = instance_place(x + (dir * 8), y, PUSHABLE[i]);
            if (inst != noone) {
                inst.x += dir;
                pushing = true;
                break;
            }
        }
    }
    
    // If not pushing anymore, return to free state
    if (!pushing) {
        state = stateFREE;
        return;
    }
    
    move_and_collide(SP.H, SP.V, COLLISIONS);

    var isRUNNING = (SP.H != 0 && keyRUN);
    
    if (isRUNNING) {
        if (sprite_index != SPRITES.RUN) {
            sprite_index = SPRITES.RUN;
            image_index = 0;
        }
    }
    else if (SP.H != 0) {
        if (sprite_index != SPRITES.PUSH) {
            sprite_index = SPRITES.PUSH;
            image_index = 0;
        }
    }
    else {
        if (sprite_index != SPRITES.IDLE) {
            sprite_index = SPRITES.IDLE;
            image_index = 0;
        }
    }
    
    if (SP.H != 0) {
        image_xscale = sign(SP.H);
    }
});

state = stateFREE;