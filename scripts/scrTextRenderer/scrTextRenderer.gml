/// @description Parses a string with embedded tags into an array of tokens for rendering.
/// @param {string} _str The string to parse.
function text_parse(_str) {
	var _tokens = [];
	var _buffer = "";
	var _i = 1;
	var _len = string_length(_str);

	while (_i <= _len) {
		var _ch = string_char_at(_str, _i);

		if (_ch == "[") {
			var _end = _i + 1;

			while (_end <= _len && string_char_at(_str, _end) != "]") {
				_end++;
			}

			if (_end <= _len) {
				if (_buffer != "") {
					array_push(_tokens, { type: "TEXT", value: _buffer });
					_buffer = "";
				}

				var _tag = string_copy(_str, _i + 1, _end - _i - 1);
				array_push(_tokens, text_parse_tag(_tag));

				_i = _end + 1;
				continue;
			}
		}

		_buffer += _ch;
		_i++;
	}

	if (_buffer != "") {
		array_push(_tokens, { type: "TEXT", value: _buffer });
	}

	return _tokens;
}
/// @description Parses a tag string into a structured object representing the tag type and its arguments.
/// @param {string} _tag The tag string to parse (without the surrounding brackets).
function text_parse_tag(_tag) {
	_tag = string_trim(_tag);

	if (string_char_at(_tag, 1) == "/") {
		var _close = string_upper(string_trim(string_delete(_tag, 1, 1)));

		if (_close == "") _close = "ALL";

		return {
			type: "CLOSE",
			close: _close,
			args: []
		};
	}

	var _colon = string_pos(":", _tag);

	if (_colon <= 0) {
		return {
			type: string_upper(_tag),
			args: []
		};
	}

	var _type = string_upper(string_trim(string_copy(_tag, 1, _colon - 1)));
	var _arg_string = string_trim(string_copy(_tag, _colon + 1, string_length(_tag)));
	var _args = string_split(_arg_string, ",");

	for (var _i = 0; _i < array_length(_args); _i++) {
		_args[_i] = string_trim(_args[_i]);
	}

	return {
		type: _type,
		args: _args
	};
}
/// @description Returns a struct containing the default state values for text rendering, including color, alpha, scale, font, and various effects.
/// @returns {struct} A struct with default text rendering state values.
function text_default_state() {
	return {
		color: c_white,
		alpha: 1,

		gradient: false,
		gradient_colors: [c_white, c_white],
		gradient_start: 0,
		gradient_length: 1,
		gradient_direction: "RIGHT",
		xscale: 1,
		yscale: 1,
		font: variable_global_exists("TEXT_RENDERER_DEFAULT_FONT") ? global.TEXT_RENDERER_DEFAULT_FONT : -1,
		halign: fa_left,
		valign: fa_top,

		shadow_color: c_black,
		shadow_alpha: 0,
		shadow_x: 0,
		shadow_y: 0,

		outline_color: c_black,
		outline_alpha: 0,
		outline_size: 0,

		black_tint_enabled: false,
		black_tint_color: c_black,

		underline: false,
		underline_color: c_white,
		underline_use_text_color: true,
		underline_alpha: 1,
		underline_thickness: 1,
		underline_offset: 0,

		strike: false,
		strike_color: c_white,
		strike_use_text_color: true,
		strike_alpha: 1,
		strike_thickness: 1,
		strike_offset: 0,

		wave: false,
		wave_amp: 4,
		wave_speed: 0.008,
		wobble: false,
		wobble_amp: 8,
		wobble_speed: 0.01,
		shake: false,
		shake_amount: 1.5,
		bounce: false,
		bounce_amp: 6,
		bounce_speed: 0.006,
		rainbow: 0,
		angle: 0,

        sine_amp: 0,
        sine_speed: 0,

        jitter: 0,
        sway: 0,
        spin: 0,

        zoom: 0,
        fade: 0,

        hsv: 0,
        flash: 0,

        offset_x: 0,
        offset_y: 0,

        line_height_mul: 1,
        space_add: 0
	};
}
/// @description Creates a copy of a given text state struct, allowing for modifications without affecting the original state.
/// @param {struct} _s The text state struct to clone.
/// @returns {struct} A new struct with the same values as the input state.
function text_clone_state(_s) {
	var _clone = text_default_state();

	_clone.color = _s.color;
	_clone.alpha = _s.alpha;
	_clone.gradient = _s.gradient;
	_clone.gradient_colors = [];
	array_copy(_clone.gradient_colors, 0, _s.gradient_colors, 0, array_length(_s.gradient_colors));
	_clone.gradient_start = _s.gradient_start;
	_clone.gradient_length = _s.gradient_length;
	_clone.gradient_direction = _s.gradient_direction;
	_clone.xscale = _s.xscale;
	_clone.yscale = _s.yscale;
	_clone.font = _s.font;
	_clone.halign = _s.halign;
	_clone.valign = _s.valign;

	_clone.shadow_color = _s.shadow_color;
	_clone.shadow_alpha = _s.shadow_alpha;
	_clone.shadow_x = _s.shadow_x;
	_clone.shadow_y = _s.shadow_y;

	_clone.outline_color = _s.outline_color;
	_clone.outline_alpha = _s.outline_alpha;
	_clone.outline_size = _s.outline_size;
	_clone.black_tint_enabled = _s.black_tint_enabled;
	_clone.black_tint_color = _s.black_tint_color;

	_clone.underline = _s.underline;
	_clone.underline_color = _s.underline_color;
	_clone.underline_use_text_color = _s.underline_use_text_color;
	_clone.underline_alpha = _s.underline_alpha;
	_clone.underline_thickness = _s.underline_thickness;
	_clone.underline_offset = _s.underline_offset;

	_clone.strike = _s.strike;
	_clone.strike_color = _s.strike_color;
	_clone.strike_use_text_color = _s.strike_use_text_color;
	_clone.strike_alpha = _s.strike_alpha;
	_clone.strike_thickness = _s.strike_thickness;
	_clone.strike_offset = _s.strike_offset;

	_clone.wave = _s.wave;
	_clone.wave_amp = _s.wave_amp;
	_clone.wave_speed = _s.wave_speed;
	_clone.wobble = _s.wobble;
	_clone.wobble_amp = _s.wobble_amp;
	_clone.wobble_speed = _s.wobble_speed;
	_clone.shake = _s.shake;
	_clone.shake_amount = _s.shake_amount;
	_clone.bounce = _s.bounce;
	_clone.bounce_amp = _s.bounce_amp;
	_clone.bounce_speed = _s.bounce_speed;
	_clone.rainbow = _s.rainbow;
	_clone.angle = _s.angle;

	_clone.sine_amp = _s.sine_amp;
	_clone.sine_speed = _s.sine_speed;
	_clone.jitter = _s.jitter;
	_clone.sway = _s.sway;
	_clone.spin = _s.spin;
	_clone.zoom = _s.zoom;
	_clone.fade = _s.fade;
	_clone.hsv = _s.hsv;
	_clone.flash = _s.flash;
	_clone.offset_x = _s.offset_x;
	_clone.offset_y = _s.offset_y;
	_clone.line_height_mul = _s.line_height_mul;
	_clone.space_add = _s.space_add;

	return _clone;
}
/// @description Pushes a copy of the current text state onto a stack, allowing for nested state changes and easy restoration of previous states.
/// @param {array} _stack The stack to push the state onto.
/// @param {struct} _state The text state struct to push onto the stack.
function text_push_state(_stack, _state) {
	array_push(_stack, text_clone_state(_state));
}
/// @description Pops the last text state from a stack and returns it, allowing for restoration of previous states after temporary changes.
/// @param {array} _stack The stack to pop the state from.
/// @param {struct} _state The current text state struct, which will be replaced by the popped state.
/// @returns {struct} The new text state struct after popping from the stack
function text_pop_state(_stack, _state) {
	if (array_length(_stack) <= 0) return _state;

	var _last = array_length(_stack) - 1;
	var _new_state = _stack[_last];
	array_delete(_stack, _last, 1);

	return _new_state;
}
/// @description Applies a text tag token to the current text state, modifying the state based on the tag type and its arguments. This function handles various tags for color, scale, font, and effects.
/// @param {array} _stack The stack of text states for managing nested tags.
/// @param {struct} _state The current text state struct to be modified based on the tag token.
/// @param {struct} _token The tag token containing the type and arguments for the text modification.
/// @returns {struct} The modified text state struct after applying the tag token.
function text_apply_tag(_stack, _state, _token) {

	switch (_token.type) {

		case "CLOSE":
			_state = text_pop_state(_stack, _state);
		break;

		case "COLOR":
			text_push_state(_stack, _state);
			_state.color = text_color(_token.args[0]);

			if (array_length(_token.args) > 1) {
				var _arg_1 = _token.args[1];

				if (text_is_numeric_string(_arg_1)) {
					_state.alpha = real(_arg_1);

					if (array_length(_token.args) > 2 && _token.args[2] != "") {
						_state.black_tint_enabled = true;
						_state.black_tint_color = text_color(_token.args[2]);
					}
				}
				else if (_arg_1 != "") {
					_state.black_tint_enabled = true;
					_state.black_tint_color = text_color(_arg_1);

					if (array_length(_token.args) > 2 && text_is_numeric_string(_token.args[2])) {
						_state.alpha = real(_token.args[2]);
					}
				}
			}
		break;

		case "BLACK":
		case "INK":
			text_push_state(_stack, _state);
			_state.black_tint_enabled = true;
			_state.black_tint_color = (array_length(_token.args) > 0 && _token.args[0] != "") ? text_color(_token.args[0]) : c_black;
		break;

		case "GRADIENT":
			text_push_state(_stack, _state);
			_state.gradient = true;
			_state.gradient_colors = text_gradient_colors(_token.args);
			_state.gradient_start = 0;
			_state.gradient_length = 1;
		break;

		case "GRADIENT_DIRECTION":
		case "GRADIENTDIR":
		case "GRADIENT_DIR":
			text_push_state(_stack, _state);
			_state.gradient_direction = text_gradient_direction(_token.args[0]);
		break;

		case "SCALE":
			text_push_state(_stack, _state);

			var _s = real(_token.args[0]);
			_state.xscale = _s;
			_state.yscale = _s;
		break;

		case "XSCALE":
			text_push_state(_stack, _state);
			_state.xscale = real(_token.args[0]);
		break;

		case "YSCALE":
			text_push_state(_stack, _state);
			_state.yscale = real(_token.args[0]);
		break;

		case "FONT":
			text_push_state(_stack, _state);
			_state.font = text_font(_token.args[0]);
		break;

		case "HALIGN":
			text_push_state(_stack, _state);
			_state.halign = text_halign(_token.args[0]);
		break;

		case "VALIGN":
			text_push_state(_stack, _state);
			_state.valign = text_valign(_token.args[0]);
		break;

		case "ALIGN":
			text_push_state(_stack, _state);

			if (array_length(_token.args) > 0) {
				_state.halign = text_halign(_token.args[0]);
			}

			if (array_length(_token.args) > 1) {
				_state.valign = text_valign(_token.args[1]);
			}
		break;

		case "LEFT":
			text_push_state(_stack, _state);
			_state.halign = fa_left;
		break;

		case "CENTER":
		case "CENTRE":
			text_push_state(_stack, _state);
			_state.halign = fa_center;
		break;

		case "RIGHT":
			text_push_state(_stack, _state);
			_state.halign = fa_right;
		break;

		case "TOP":
			text_push_state(_stack, _state);
			_state.valign = fa_top;
		break;

		case "MIDDLE":
		case "MID":
			text_push_state(_stack, _state);
			_state.valign = fa_middle;
		break;

		case "BOTTOM":
			text_push_state(_stack, _state);
			_state.valign = fa_bottom;
		break;

		case "ALPHA":
			text_push_state(_stack, _state);
			_state.alpha = real(_token.args[0]);
		break;

		case "SHADOW":
			text_push_state(_stack, _state);
			_state.shadow_color = text_color(_token.args[0]);
			_state.shadow_x = (array_length(_token.args) > 1) ? real(_token.args[1]) : 1;
			_state.shadow_y = (array_length(_token.args) > 2) ? real(_token.args[2]) : _state.shadow_x;
			_state.shadow_alpha = (array_length(_token.args) > 3) ? real(_token.args[3]) : 1;
		break;

		case "OUTLINE":
			text_push_state(_stack, _state);
			_state.outline_color = text_color(_token.args[0]);
			_state.outline_size = (array_length(_token.args) > 1) ? abs(real(_token.args[1])) : 1;
			_state.outline_alpha = (array_length(_token.args) > 2) ? real(_token.args[2]) : 1;
		break;

		case "WAVE":
			text_push_state(_stack, _state);
			_state.wave = true;

			if (array_length(_token.args) > 0 && _token.args[0] != "") {
				_state.wave_amp = real(_token.args[0]);
			}

			if (array_length(_token.args) > 1 && _token.args[1] != "") {
				_state.wave_speed = real(_token.args[1]);
			}
		break;

		case "WOBBLE":
			text_push_state(_stack, _state);
			_state.wobble = true;

			if (array_length(_token.args) > 0 && _token.args[0] != "") {
				_state.wobble_amp = real(_token.args[0]);
			}

			if (array_length(_token.args) > 1 && _token.args[1] != "") {
				_state.wobble_speed = real(_token.args[1]);
			}
		break;

		case "SHAKE":
			text_push_state(_stack, _state);
			_state.shake = true;

			if (array_length(_token.args) > 0 && _token.args[0] != "") {
				_state.shake_amount = abs(real(_token.args[0]));
			}
		break;

		case "BOUNCE":
			text_push_state(_stack, _state);
			_state.bounce = true;

			if (array_length(_token.args) > 0 && _token.args[0] != "") {
				_state.bounce_amp = real(_token.args[0]);
			}

			if (array_length(_token.args) > 1 && _token.args[1] != "") {
				_state.bounce_speed = real(_token.args[1]);
			}
		break;

		case "UNDERLINE":
			text_push_state(_stack, _state);
			_state.underline = true;
			_state.underline_use_text_color = true;

			if (array_length(_token.args) > 0 && _token.args[0] != "") {
				_state.underline_color = text_color(_token.args[0]);
				_state.underline_use_text_color = false;
			}

			if (array_length(_token.args) > 1 && _token.args[1] != "") {
				_state.underline_thickness = max(1, abs(real(_token.args[1])));
			}

			if (array_length(_token.args) > 2 && _token.args[2] != "") {
				_state.underline_alpha = clamp(real(_token.args[2]), 0, 1);
			}

			if (array_length(_token.args) > 3 && _token.args[3] != "") {
				_state.underline_offset = real(_token.args[3]);
			}
		break;

		case "STRIKE":
		case "STRIKETHROUGH":
			text_push_state(_stack, _state);
			_state.strike = true;
			_state.strike_use_text_color = true;

			if (array_length(_token.args) > 0 && _token.args[0] != "") {
				_state.strike_color = text_color(_token.args[0]);
				_state.strike_use_text_color = false;
			}

			if (array_length(_token.args) > 1 && _token.args[1] != "") {
				_state.strike_thickness = max(1, abs(real(_token.args[1])));
			}

			if (array_length(_token.args) > 2 && _token.args[2] != "") {
				_state.strike_alpha = clamp(real(_token.args[2]), 0, 1);
			}

			if (array_length(_token.args) > 3 && _token.args[3] != "") {
				_state.strike_offset = real(_token.args[3]);
			}
		break;

		case "RAINBOW":
			text_push_state(_stack, _state);
			_state.rainbow = 1;

			if (array_length(_token.args) > 0) {
				_state.rainbow = real(_token.args[0]);
			}
		break;

		case "ROTATE":
		case "ANGLE":
			text_push_state(_stack, _state);
			_state.angle = real(_token.args[0]);
		break;

		case "RESET":
			_stack = [];
			_state = text_default_state();
		break;

		case "SPEED":
			// marker tag for external reveal logic
		break;

        case "PAUSE":
            // handled externally (store pause timer if you want)
        break;

        case "SINE":
            text_push_state(_stack, _state);
            _state.sine_amp = real(_token.args[0]);
            _state.sine_speed = (array_length(_token.args) > 1) ? real(_token.args[1]) : 1;
        break;

        case "JITTER":
            text_push_state(_stack, _state);
            _state.jitter = real(_token.args[0]);
        break;

        case "SWAY":
            text_push_state(_stack, _state);
            _state.sway = real(_token.args[0]);
        break;

        case "SPIN":
            text_push_state(_stack, _state);
            _state.spin = real(_token.args[0]);
        break;

        case "ZOOM":
            text_push_state(_stack, _state);
            _state.zoom = real(_token.args[0]);
        break;

        case "FADE":
            text_push_state(_stack, _state);
            _state.fade = real(_token.args[0]);
        break;

        case "HSV":
            text_push_state(_stack, _state);
            _state.hsv = real(_token.args[0]);
        break;

        case "FLASH":
            text_push_state(_stack, _state);
            _state.flash = real(_token.args[0]);
        break;

        case "OFFSET":
            text_push_state(_stack, _state);
            _state.offset_x = real(_token.args[0]);
            _state.offset_y = real(_token.args[1]);
        break;

		case "XOFFSET":
			text_push_state(_stack, _state);
			_state.offset_x = real(_token.args[0]);
		break;

		case "YOFFSET":
			text_push_state(_stack, _state);
			_state.offset_y = real(_token.args[0]);
		break;

        case "LINEHEIGHT":
		case "LEADING":
            text_push_state(_stack, _state);
            _state.line_height_mul = real(_token.args[0]);
        break;

        case "SPACE":
		case "LETTERSPACE":
		case "TRACKING":
            text_push_state(_stack, _state);
            _state.space_add = real(_token.args[0]);
        break;
	}

	return _state;
}
/// @description Counts the number of visible characters in an array of text tokens, accounting for both text and sprite tokens. This is used for reveal effects to determine how many characters should be shown.
/// @param {array} _tokens The array of text tokens to count visible characters from.
/// @returns {real} The total count of visible characters represented by the tokens.
function text_visible_count(_tokens) {
	var _count = 0;

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type == "TEXT") {
			_count += string_length(_token.value);
		}
		else if (_token.type == "SPRITE") {
			_count += 1;
		}
	}

	return _count;
}

function text_string_width_scaled(_text, _state) {
	if (_text == "") {
		return 0;
	}

	if (_state.font != -1) {
		draw_set_font(_state.font);
	}

	return string_width(_text) * _state.xscale + max(0, string_length(_text) - 1) * _state.space_add;
}

function text_modulate_color(_base_color, _blend_color) {
	if (_blend_color == c_white) {
		return _base_color;
	}

	return make_color_rgb(
		round(color_get_red(_base_color) * color_get_red(_blend_color) / 255),
		round(color_get_green(_base_color) * color_get_green(_blend_color) / 255),
		round(color_get_blue(_base_color) * color_get_blue(_blend_color) / 255)
	);
}

function text_apply_black_tint_shader(_main_color, _black_color) {
	var _shader = asset_get_index("shdTextBlackParts");
	static _cached_shader = -1;
	static _u_main_color = -1;
	static _u_black_color = -1;

	if (_shader == -1) {
		return false;
	}

	if (_cached_shader != _shader) {
		_cached_shader = _shader;
		_u_main_color = shader_get_uniform(_shader, "u_mainColor");
		_u_black_color = shader_get_uniform(_shader, "u_blackColor");
	}

	shader_set(_shader);
	shader_set_uniform_f(
		_u_main_color,
		color_get_red(_main_color) / 255,
		color_get_green(_main_color) / 255,
		color_get_blue(_main_color) / 255
	);
	shader_set_uniform_f(
		_u_black_color,
		color_get_red(_black_color) / 255,
		color_get_green(_black_color) / 255,
		color_get_blue(_black_color) / 255
	);

	return true;
}

function text_gradient_colors(_args) {
	var _colors = [];
	var _count = min(array_length(_args), 4);

	for (var _i = 0; _i < _count; _i++) {
		if (_args[_i] != "") {
			array_push(_colors, text_color(_args[_i]));
		}
	}

	if (array_length(_colors) <= 0) {
		array_push(_colors, c_white);
	}

	if (array_length(_colors) == 1) {
		array_push(_colors, _colors[0]);
	}

	return _colors;
}

function text_gradient_direction(_value) {
	var _dir = string_upper(string_trim(string(_value)));

	switch (_dir) {
		case "LEFT":
		case "RIGHT_TO_LEFT":
		case "RTL":
		case "REVERSE":
		case "HORIZONTAL_REVERSE":
			return "LEFT";

		case "DOWN":
		case "TOP_TO_BOTTOM":
		case "TTB":
		case "VERTICAL":
		case "Y":
			return "DOWN";

		case "LEFT_TO_RIGHT":
		case "LTR":
		case "HORIZONTAL":
		case "X":
		default:
			return "RIGHT";
	}
}

function text_gradient_amount(_state, _glyph_index, _line_index, _line_count) {
	var _amount = (_glyph_index - _state.gradient_start) / max(1, _state.gradient_length - 1);

	switch (_state.gradient_direction) {
		case "LEFT":
			return 1 - clamp(_amount, 0, 1);

		case "DOWN":
			return clamp(_line_index / max(1, _line_count - 1), 0, 1);

		case "UP":
			return 1 - clamp(_line_index / max(1, _line_count - 1), 0, 1);
	}

	return clamp(_amount, 0, 1);
}

function text_gradient_color(_colors, _amount) {
	var _count = array_length(_colors);

	if (_count <= 0) return c_white;
	if (_count == 1) return _colors[0];

	_amount = clamp(_amount, 0, 1);
	var _scaled = _amount * (_count - 1);
	var _index = floor(_scaled);

	if (_index >= _count - 1) {
		return _colors[_count - 1];
	}

	return merge_color(_colors[_index], _colors[_index + 1], frac(_scaled));
}

function text_visible_count_until_close(_tokens, _start_index, _close_type) {
	var _count = 0;
	var _depth = 0;
	_close_type = string_upper(_close_type);

	for (var _i = _start_index + 1; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type == _close_type) {
			_depth++;
		}
		else if (_token.type == "CLOSE") {
			var _close = variable_struct_exists(_token, "close") ? _token.close : "ALL";

			if (_close == _close_type || _close == "ALL") {
				if (_depth <= 0) {
					return max(1, _count);
				}

				_depth--;
			}
		}

		if (_token.type == "TEXT") {
			_count += string_length(_token.value);
		}
		else if (_token.type == "SPRITE") {
			_count += 1;
		}
	}

	return max(1, _count);
}

function text_draw_decoration(_center_x, _center_y, _width, _angle, _local_y, _thickness, _color, _alpha) {
	if (_width <= 0 || _thickness <= 0 || _alpha <= 0) {
		return;
	}

	var _line_count = max(1, ceil(_thickness));
	var _start_x = _center_x + lengthdir_x(_width * 0.5, _angle + 180) + lengthdir_x(_local_y, _angle - 90);
	var _start_y = _center_y + lengthdir_y(_width * 0.5, _angle + 180) + lengthdir_y(_local_y, _angle - 90);
	var _end_x = _center_x + lengthdir_x(_width * 0.5, _angle) + lengthdir_x(_local_y, _angle - 90);
	var _end_y = _center_y + lengthdir_y(_width * 0.5, _angle) + lengthdir_y(_local_y, _angle - 90);
	var _half = (_line_count - 1) * 0.5;

	draw_set_alpha(_alpha);
	draw_set_color(_color);

	for (var _line = 0; _line < _line_count; _line++) {
		var _normal = _line - _half;
		var _ox = lengthdir_x(_normal, _angle + 90);
		var _oy = lengthdir_y(_normal, _angle + 90);

		draw_line(_start_x + _ox, _start_y + _oy, _end_x + _ox, _end_y + _oy);
	}
}
/// @description Calculates the x-coordinate for a line of text based on the specified horizontal alignment and bounding box width. This is used to position lines of text correctly when rendering with different alignments and optional bounding boxes.
/// @param {real} _x The base x-coordinate for the text.
/// @param {real} _line_width The width of the line of text being positioned.
/// @param {real} _halign The horizontal alignment for the text (fa_left, fa_center, fa_right).
/// @param {real} _box_w The width of the bounding box for the text. If -1, no bounding box is used.
function text_aligned_line_x(_x, _line_width, _halign, _box_w) {
	if (_box_w > 0) {
		switch (_halign) {
			case fa_center:
				return _x + (_box_w - _line_width) * 0.5;

			case fa_right:
				return _x + (_box_w - _line_width);
		}

		return _x;
	}

	switch (_halign) {
		case fa_center:
			return _x - _line_width * 0.5;

		case fa_right:
			return _x - _line_width;
	}

	return _x;
}
/// @description Calculates the y-coordinate for a line of text based on the specified vertical alignment and bounding box height. This is used to position lines of text correctly when rendering with different alignments and optional bounding boxes.
/// @param {real} _y The base y-coordinate for the text.
/// @param {real} _line_height The height of the line of text being positioned.
/// @param {real} _content_height The total height of the text content being rendered.
/// @param {real} _valign The vertical alignment for the text (fa_top, fa_middle, fa_bottom).
function text_aligned_line_y(_y, _line_height, _content_height, _valign) {
	switch (_valign) {
		case fa_middle:
			return _y + (_line_height - _content_height) * 0.5;

		case fa_bottom:
			return _y + (_line_height - _content_height);
	}

	return _y;
}

/// @description Measures the height of a line of text based on the current text state, including font and scale. This is used to determine line spacing and vertical positioning when rendering text.
/// @param {struct} _state The current text state struct containing font and scale information for measuring the line height.
function text_measure_state_height(_state) {
	if (_state.font != -1) {
		draw_set_font(_state.font);
	}

	return string_height("A") * _state.yscale * _state.line_height_mul;
}
/// @description Creates a struct containing information about a line of text, including its width, horizontal alignment, vertical alignment, and height based on the current text state. This is used to manage line layout when rendering text with multiple lines and varying states.
/// @param {struct} _state The current text state struct used to determine the line height and default alignments for the line info.
function text_make_line_info(_state) {
	return {
		width: 0,
		halign: _state.halign,
		valign: _state.valign,
		height: text_measure_state_height(_state)
	};
}
/// @description Measures the widths and heights of each line of text in an array of tokens when wrapped within a specified box width. This is used to determine how to position and wrap text when rendering with bounding boxes, accounting for both text and sprite tokens.
/// @param {array} _tokens The array of text tokens to measure line widths and heights from.
/// @param {real} _box_w The width of the bounding box for the text. If -1, no bounding box is used and lines are not wrapped.
/// @param {real} _halign The horizontal alignment for the text (fa_left, fa_center, fa_right), used to set line info alignment when a new line is started due to a tag change.
/// @param {real} _valign The vertical alignment for the text (fa_top, fa_middle, fa_bottom), used to set line info alignment when a new line is started due to a tag change.
function text_measure_lines_wrapped(_tokens, _box_w, _halign, _valign) {
	var _state = text_default_state();
	var _stack = [];

	_state.halign = _halign;
	_state.valign = _valign;

	var _lines = [text_make_line_info(_state)];
	var _line_index = 0;

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type != "TEXT" && _token.type != "SPRITE") {
			_state = text_apply_tag(_stack, _state, _token);

			if (_lines[_line_index].width <= 0) {
				_lines[_line_index].halign = _state.halign;
				_lines[_line_index].valign = _state.valign;
			}

			_lines[_line_index].height = max(_lines[_line_index].height, text_measure_state_height(_state));
			continue;
		}

		if (_token.type == "SPRITE") {
			var _spr = text_asset(_token.args[0]);
			var _spr_w = 0;
			var _spr_h = 0;

			if (_spr != -1) {
				_spr_w = sprite_get_width(_spr) * _state.xscale;
				_spr_h = sprite_get_height(_spr) * _state.yscale;
			}

			if (_box_w > 0 && _lines[_line_index].width + _spr_w > _box_w) {
				_line_index++;
				array_push(_lines, text_make_line_info(_state));
			}

			_lines[_line_index].width += _spr_w;
			_lines[_line_index].height = max(_lines[_line_index].height, _spr_h);
			continue;
		}

		_lines[_line_index].height = max(_lines[_line_index].height, text_measure_state_height(_state));

		var _txt = _token.value;
		var _word = "";

		for (var _c = 1; _c <= string_length(_txt); _c++) {
			var _char = string_char_at(_txt, _c);

			if (_char == "\n") {
				_lines[_line_index].width += text_string_width_scaled(_word, _state);
				_word = "";

				_line_index++;
				array_push(_lines, text_make_line_info(_state));
				continue;
			}

			if (_char == " ") {
				var _word_w = text_string_width_scaled(_word + " ", _state);

				if (_box_w > 0 && _lines[_line_index].width + _word_w > _box_w) {
					_line_index++;
					array_push(_lines, text_make_line_info(_state));
				}

				_lines[_line_index].width += _word_w;
				_word = "";
			}
			else {
				_word += _char;
			}
		}

		if (_word != "") {
			var _final_w = text_string_width_scaled(_word, _state);

			if (_box_w > 0 && _lines[_line_index].width + _final_w > _box_w) {
				_line_index++;
				array_push(_lines, text_make_line_info(_state));
			}

			_lines[_line_index].width += _final_w;
		}
	}

	return _lines;
}
/// @description Measures the widths of each line of text in an array of tokens when wrapped within a specified box width. This is used to determine how to position and wrap text when rendering with bounding boxes.
/// @param {array} _tokens The array of text tokens to measure line widths from.
/// @param {real} _box_w The width of the bounding box for the text. If -1, no bounding box is used and lines are not wrapped.
function text_measure_line_widths_wrapped(_tokens, _box_w) {
	var _state = text_default_state();
	var _stack = [];

	var _line_widths = [0];
	var _line_index = 0;

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type != "TEXT" && _token.type != "SPRITE") {
			_state = text_apply_tag(_stack, _state, _token);
			continue;
		}

		if (_token.type == "SPRITE") {
			var _spr = text_asset(_token.args[0]);
			var _spr_w = 0;

			if (_spr != -1) {
				_spr_w = sprite_get_width(_spr) * _state.xscale;
			}

			if (_box_w > 0 && _line_widths[_line_index] + _spr_w > _box_w) {
				_line_index++;
				array_push(_line_widths, 0);
			}

			_line_widths[_line_index] += _spr_w;
			continue;
		}

		if (_state.font != -1) draw_set_font(_state.font);

		var _txt = _token.value;
		var _word = "";

		for (var _c = 1; _c <= string_length(_txt); _c++) {
			var _char = string_char_at(_txt, _c);

			if (_char == "\n") {
				_line_widths[_line_index] += text_string_width_scaled(_word, _state);
				_word = "";

				_line_index++;
				array_push(_line_widths, 0);
				continue;
			}

			if (_char == " ") {
				var _word_w = text_string_width_scaled(_word + " ", _state);

				if (_box_w > 0 && _line_widths[_line_index] + _word_w > _box_w) {
					_line_index++;
					array_push(_line_widths, 0);
				}

				_line_widths[_line_index] += _word_w;
				_word = "";
			}
			else {
				_word += _char;
			}
		}

		if (_word != "") {
			var _final_w = text_string_width_scaled(_word, _state);

			if (_box_w > 0 && _line_widths[_line_index] + _final_w > _box_w) {
				_line_index++;
				array_push(_line_widths, 0);
			}

			_line_widths[_line_index] += _final_w;
		}
	}

	return _line_widths;
}
/// @description Draws an array of text tokens to the screen at a specified position, with options for alignment, bounding box, and reveal effects. This function handles the rendering of both text and sprite tokens based on the current text state.
/// @param {array} _tokens The array of text tokens to draw.
/// @param {real} _x The x-coordinate for the starting position of the text.
/// @param {real} _y The y-coordinate for the starting position of the text.
/// @param {real} _halign The horizontal alignment for the text (fa_left, fa_center, fa_right).
/// @param {real} _valign The vertical alignment for the text (fa_top, fa_middle, fa_bottom).
/// @param {real} _box_w The width of the bounding box for the text. If -1, no bounding box is used.
/// @param {real} _box_h The height of the bounding box for the text. If -1, the height is determined by the text content.
/// @param {bool} _box_draw Whether to draw the bounding box behind the text.
/// @param {real} _reveal The number of characters to reveal for the text, used for typewriter effects. If 999999, all characters are revealed.
/// @param {real} _blend_color The renderer-wide tint color multiplied against the final glyph and sprite colors.
/// @param {real} _blend_alpha The renderer-wide alpha multiplier applied to glyphs and sprites.
function text_draw_tokens(_tokens, _x, _y, _halign, _valign, _box_w, _box_h, _box_draw, _reveal, _blend_color, _blend_alpha) {

	var _state = text_default_state();
	var _stack = [];
	_state.halign = _halign;
	_state.valign = _valign;

	var _line_height = text_get_line_height(_tokens);
	var _lines = text_measure_lines_wrapped(_tokens, _box_w, _halign, _valign);
	var _total_width = text_measure_width_wrapped(_tokens, _box_w);
	var _total_height = array_length(_lines) * _line_height;

	var _box_x = _x;
	var _start_y = _y;

	if (_box_w > 0) {
		if (_halign == fa_center) _box_x -= _total_width * 0.5;
		if (_halign == fa_right)  _box_x -= _total_width;
	}

	if (_valign == fa_middle) _start_y -= _total_height * 0.5;
	if (_valign == fa_bottom) _start_y -= _total_height;

	if (_box_draw && _box_w > 0) {
		draw_set_alpha(0.25);
		draw_set_color(c_white);
		draw_rectangle(_box_x, _start_y, _box_x + _box_w, _start_y + max(_box_h, _total_height), false);
		draw_set_alpha(1);
	}

	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	var _line_index = 0;
	var _line_top_y = _start_y;
	var _cursor_x = text_aligned_line_x(_box_x, _lines[_line_index].width, _lines[_line_index].halign, _box_w);
	var _cursor_y = text_aligned_line_y(_line_top_y, _line_height, _lines[_line_index].height, _lines[_line_index].valign);
	var _line_used_width = 0;

	var _glyph_index = 0;
	var _visible_drawn = 0;

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type != "TEXT" && _token.type != "SPRITE") {
			_state = text_apply_tag(_stack, _state, _token);

			if (_token.type == "GRADIENT") {
				_state.gradient_start = _glyph_index;
				_state.gradient_length = text_visible_count_until_close(_tokens, _i, "GRADIENT");
			}

			continue;
		}

		if (_token.type == "SPRITE") {
			var _spr = text_asset(_token.args[0]);
			var _spr_w = 0;

			if (_spr != -1) {
				_spr_w = sprite_get_width(_spr) * _state.xscale;
			}

			if (_box_w > 0 && _line_used_width + _spr_w > _box_w) {
				_line_index++;
				_line_used_width = 0;
				_line_top_y += _line_height;
				_cursor_x = text_aligned_line_x(_box_x, _lines[_line_index].width, _lines[_line_index].halign, _box_w);
				_cursor_y = text_aligned_line_y(_line_top_y, _line_height, _lines[_line_index].height, _lines[_line_index].valign);
			}

			if (_visible_drawn < _reveal && _spr != -1) {
				var _img = 0;
				var _spd = 0;
				var _spr_offset_x = 0;
				var _spr_offset_y = 0;
				var _spr_angle = 0;

				if (array_length(_token.args) > 1) _img = real(_token.args[1]);
				if (array_length(_token.args) > 2) _spd = real(_token.args[2]);
				if (array_length(_token.args) > 3) _spr_offset_x = real(_token.args[3]);
				if (array_length(_token.args) > 4) _spr_offset_y = real(_token.args[4]);
				if (array_length(_token.args) > 5) _spr_angle = real(_token.args[5]);

				var _frame = _img;

				if (_spd != 0) {
					_frame = _img + current_time * 0.001 * _spd;
				}

				var _spr_color = _state.color;

				if (_state.gradient) {
					var _spr_t = text_gradient_amount(_state, _glyph_index, _line_index, array_length(_lines));
					_spr_color = text_gradient_color(_state.gradient_colors, _spr_t);
				}

				draw_sprite_ext(
					_spr,
					_frame,
					_cursor_x + _spr_offset_x,
					_cursor_y + _spr_offset_y,
					_state.xscale,
					_state.yscale,
					_spr_angle,
					text_modulate_color(_spr_color, _blend_color),
					clamp(_state.alpha * _blend_alpha, 0, 1)
				);
			}

			_cursor_x += _spr_w;
			_line_used_width += _spr_w;
			_visible_drawn++;
			_glyph_index++;
			continue;
		}

		var _txt = _token.value;
		var _word = "";

		for (var _c = 1; _c <= string_length(_txt); _c++) {
			var _char = string_char_at(_txt, _c);

			if (_char == "\n") {
				var _newline_w = text_string_width_scaled(_word, _state);

				text_draw_word(_word, _state, _cursor_x, _cursor_y, _glyph_index, _visible_drawn, _reveal, _blend_color, _blend_alpha, _line_index, array_length(_lines));
				_cursor_x += _newline_w;
				_line_used_width += _newline_w;
				_visible_drawn += string_length(_word);
				_glyph_index += string_length(_word);

				_word = "";
				_line_index++;
				_line_used_width = 0;
				_line_top_y += _line_height;
				_cursor_x = text_aligned_line_x(_box_x, _lines[_line_index].width, _lines[_line_index].halign, _box_w);
				_cursor_y = text_aligned_line_y(_line_top_y, _line_height, _lines[_line_index].height, _lines[_line_index].valign);
				continue;
			}

			if (_char == " ") {
				var _word_w = text_string_width_scaled(_word + " ", _state);

				if (_box_w > 0 && _line_used_width + _word_w > _box_w) {
					_line_index++;
					_line_used_width = 0;
					_line_top_y += _line_height;
					_cursor_x = text_aligned_line_x(_box_x, _lines[_line_index].width, _lines[_line_index].halign, _box_w);
					_cursor_y = text_aligned_line_y(_line_top_y, _line_height, _lines[_line_index].height, _lines[_line_index].valign);
				}

				text_draw_word(_word + " ", _state, _cursor_x, _cursor_y, _glyph_index, _visible_drawn, _reveal, _blend_color, _blend_alpha, _line_index, array_length(_lines));

				_cursor_x += _word_w;
				_line_used_width += _word_w;
				_visible_drawn += string_length(_word + " ");
				_glyph_index += string_length(_word + " ");

				_word = "";
			}
			else {
				_word += _char;
			}
		}

		if (_word != "") {
			var _final_w = text_string_width_scaled(_word, _state);

			if (_box_w > 0 && _line_used_width + _final_w > _box_w) {
				_line_index++;
				_line_used_width = 0;
				_line_top_y += _line_height;
				_cursor_x = text_aligned_line_x(_box_x, _lines[_line_index].width, _lines[_line_index].halign, _box_w);
				_cursor_y = text_aligned_line_y(_line_top_y, _line_height, _lines[_line_index].height, _lines[_line_index].valign);
			}

			text_draw_word(_word, _state, _cursor_x, _cursor_y, _glyph_index, _visible_drawn, _reveal, _blend_color, _blend_alpha, _line_index, array_length(_lines));

			_cursor_x += _final_w;
			_line_used_width += _final_w;
			_visible_drawn += string_length(_word);
			_glyph_index += string_length(_word);
		}
	}

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_alpha(1);
	draw_set_color(c_white);
}
/// @description Draws a single word to the screen with the specified text state and reveal effects. This function is called by text_draw_tokens to render each word based on the current state and how many characters should be revealed.
/// @param {string} _word The word to draw.
/// @param {struct} _state The current text state struct containing color, scale, font, and effects.
/// @param {real} _x The x-coordinate for the starting position of the word.
/// @param {real} _y The y-coordinate for the starting position of the word.
/// @param {real} _glyph_index The index of the first glyph of the word in the overall text, used for effects that depend on glyph position.
/// @param {real} _visible_drawn The number of characters that have already been drawn before this word, used for reveal effects.
/// @param {real} _reveal The total number of characters to reveal, used for typewriter effects. If 999999, all characters are revealed.
/// @param {real} _blend_color The renderer-wide tint color multiplied against the final glyph colors.
/// @param {real} _blend_alpha The renderer-wide alpha multiplier applied to glyphs.
/// @param {real} _line_index The current rendered line index, used by vertical gradient directions.
/// @param {real} _line_count The number of rendered lines, used by vertical gradient directions.
function text_draw_word(_word, _state, _x, _y, _glyph_index, _visible_drawn, _reveal, _blend_color, _blend_alpha, _line_index, _line_count) {
	if (_word == "") return;

	if (_state.font != -1) {
		draw_set_font(_state.font);
	}

	var _cursor_x = _x;

	for (var _i = 1; _i <= string_length(_word); _i++) {
		if (_visible_drawn >= _reveal) return;

		var _char = string_char_at(_word, _i);

		var _xx = _cursor_x;
		var _yy = _y;
		var _rot = _state.angle;

        // WAVE
		if (_state.wave) {
			_yy += sin(current_time * _state.wave_speed + _glyph_index * 0.45) * _state.wave_amp;
		}
        // WOBBLE
		if (_state.wobble) {
			_rot += sin(current_time * _state.wobble_speed + _glyph_index) * _state.wobble_amp;
		}
        // SHAKE
		if (_state.shake) {
			_xx += random_range(-_state.shake_amount, _state.shake_amount);
			_yy += random_range(-_state.shake_amount, _state.shake_amount);
		}
        // BOUNCE
		if (_state.bounce) {
			_yy += abs(sin(current_time * _state.bounce_speed + _glyph_index * 0.35)) * -_state.bounce_amp;
		}

		var _draw_color = _state.color;

		if (_state.gradient) {
			var _gradient_t = text_gradient_amount(_state, _glyph_index, _line_index, _line_count);
			_draw_color = text_gradient_color(_state.gradient_colors, _gradient_t);
		}

		if (_state.rainbow > 0) {
			var _h = frac(current_time * 0.0001 * _state.rainbow + _glyph_index * 0.035);
			_draw_color = make_color_hsv(_h * 255, 220, 255);
		}

        var t = current_time;

        _xx += _state.offset_x;
        _yy += _state.offset_y;

        // SINE
        if (_state.sine_amp != 0) {
            _yy += sin(t * 0.01 * _state.sine_speed + _glyph_index) * _state.sine_amp;
        }

        // SWAY
        if (_state.sway != 0) {
            _xx += sin(t * 0.01 + _glyph_index) * _state.sway;
        }

        // JITTER
        if (_state.jitter != 0) {
            _xx += random_range(-_state.jitter, _state.jitter);
            _yy += random_range(-_state.jitter, _state.jitter);
        }

        // SPIN
        _rot += _state.spin * t * 0.001;

        // ZOOM
        var _xs = _state.xscale;
        var _ys = _state.yscale;

        if (_state.zoom != 0) {
            var z = 1 + sin(t * 0.01 + _glyph_index) * _state.zoom;
            _xs *= z;
            _ys *= z;
        }

        // FADE
        var _alpha = _state.alpha;
        if (_state.fade != 0) {
            _alpha *= 0.5 + 0.5 * sin(t * 0.01 * _state.fade + _glyph_index);
        }
		_alpha = clamp(_alpha * _blend_alpha, 0, 1);

        // HSV
        if (_state.hsv != 0) {
            var h = frac(t * 0.0001 * _state.hsv + _glyph_index * 0.02);
            _draw_color = make_color_hsv(h * 255, 255, 255);
        }

        // FLASH
        if (_state.flash != 0) {
            if (sin(t * 0.02 * _state.flash) > 0) {
                _draw_color = c_white;
            }
        }

		var _shadow_color = text_modulate_color(_state.shadow_color, _blend_color);
		var _outline_color = text_modulate_color(_state.outline_color, _blend_color);
		_draw_color = text_modulate_color(_draw_color, _blend_color);
		var _black_tint_color = text_modulate_color(_state.black_tint_color, _blend_color);
		var _underline_color = _state.underline_use_text_color ? _draw_color : text_modulate_color(_state.underline_color, _blend_color);
		var _strike_color = _state.strike_use_text_color ? _draw_color : text_modulate_color(_state.strike_color, _blend_color);
		var _layout_glyph_w = string_width(_char) * _state.xscale;
		var _layout_glyph_h = string_height(_char) * _state.yscale;
		var _glyph_w = string_width(_char) * _xs;
		var _glyph_h = string_height(_char) * _ys;
		var _draw_x = _xx + _layout_glyph_w * 0.5;
		var _draw_y = _yy + _layout_glyph_h * 0.5;

		if (_state.shadow_alpha > 0 && (_state.shadow_x != 0 || _state.shadow_y != 0)) {
			draw_set_alpha(_alpha * _state.shadow_alpha);
			draw_set_color(_shadow_color);
			draw_text_transformed(_draw_x + _state.shadow_x, _draw_y + _state.shadow_y, _char, _xs, _ys, _rot);
		}

		if (_state.outline_alpha > 0 && _state.outline_size > 0) {
			var _outline_size = max(1, ceil(_state.outline_size));

			draw_set_alpha(_alpha * _state.outline_alpha);
			draw_set_color(_outline_color);

			for (var _ox = -_outline_size; _ox <= _outline_size; _ox++) {
				for (var _oy = -_outline_size; _oy <= _outline_size; _oy++) {
					if (_ox == 0 && _oy == 0) continue;
					draw_text_transformed(_draw_x + _ox, _draw_y + _oy, _char, _xs, _ys, _rot);
				}
			}
		}

		if (_state.underline) {
			text_draw_decoration(_draw_x, _draw_y, _glyph_w, _rot, _glyph_h * 0.5 + 1 + _state.underline_offset, _state.underline_thickness, _underline_color, _alpha * _state.underline_alpha);
		}

		if (_state.strike) {
			text_draw_decoration(_draw_x, _draw_y, _glyph_w, _rot, _state.strike_offset, _state.strike_thickness, _strike_color, _alpha * _state.strike_alpha);
		}

		draw_set_alpha(_alpha);

		if (_state.black_tint_enabled && text_apply_black_tint_shader(_draw_color, _black_tint_color)) {
			draw_set_color(c_white);
			draw_text_transformed(_draw_x, _draw_y, _char, _xs, _ys, _rot);
			shader_reset();
		}
		else {
        		draw_set_color(_draw_color);
        		draw_text_transformed(_draw_x, _draw_y, _char, _xs, _ys, _rot);
		}

		_cursor_x += string_width(_char) * _state.xscale;
		if (_i < string_length(_word)) {
			_cursor_x += _state.space_add;
		}
		_visible_drawn++;
		_glyph_index++;
	}
}
/// @description Calculates the height of a line of text based on the tokens and any font or scale tags that may be present. This is used to determine line spacing when rendering wrapped text.
/// @param {array} _tokens The array of text tokens to analyze for line height.
/// @returns {real} The calculated line height for the text.
function text_get_line_height(_tokens) {
	var _height = string_height("A");
	var _state = text_default_state();
	var _stack = [];

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type == "FONT") {
			_state = text_apply_tag(_stack, _state, _token);

			if (_state.font != -1) {
				draw_set_font(_state.font);
				_height = max(_height, string_height("A") * _state.yscale * _state.line_height_mul);
			}
		}

		if (_token.type == "SCALE" || _token.type == "YSCALE" || _token.type == "LINEHEIGHT" || _token.type == "LEADING") {
			_state = text_apply_tag(_stack, _state, _token);
			_height = max(_height, string_height("A") * _state.yscale * _state.line_height_mul);
		}
	}

	return _height;
}
/// @description Measures the width of a block of text based on the tokens and any wrapping that may occur due to a specified box width. This is used to determine how wide the text will be when rendered with wrapping.
/// @param {array} _tokens The array of text tokens to analyze for width measurement.
/// @param {real} _box_w The width of the bounding box for the text. If -1, no bounding box is used and the width is simply the total width of the text.
/// @returns {real} The calculated width of the text block, accounting for wrapping if a box width is specified.
function text_measure_width_wrapped(_tokens, _box_w) {
	if (_box_w > 0) return _box_w;

	var _state = text_default_state();
	var _stack = [];

	var _width = 0;
	var _line_width = 0;

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type != "TEXT" && _token.type != "SPRITE") {
			_state = text_apply_tag(_stack, _state, _token);
			continue;
		}

		if (_token.type == "TEXT") {
			if (_state.font != -1) draw_set_font(_state.font);

			var _txt = _token.value;

			for (var _c = 1; _c <= string_length(_txt); _c++) {
				var _char = string_char_at(_txt, _c);

				if (_char == "\n") {
					_width = max(_width, _line_width);
					_line_width = 0;
				}
				else {
					_line_width += string_width(_char) * _state.xscale;

					if (_c < string_length(_txt) && string_char_at(_txt, _c + 1) != "\n") {
						_line_width += _state.space_add;
					}
				}
			}
		}

		if (_token.type == "SPRITE") {
			var _spr = text_asset(_token.args[0]);

			if (_spr != -1) {
				_line_width += sprite_get_width(_spr) * _state.xscale;
			}
		}
	}

	_width = max(_width, _line_width);
	return _width;
}
/// @description Measures the height of a block of text based on the tokens and any wrapping that may occur due to a specified box width. This is used to determine how tall the text will be when rendered with wrapping.
/// @param {array} _tokens The array of text tokens to analyze for height measurement.
/// @param {real} _box_w The width of the bounding box for the text. If -1, no bounding box is used and the height is simply the line height of the text.
/// @param {real} _line_height The height of a single line of text, used to calculate total height when wrapping occurs.
/// @returns {real} The calculated height of the text block, accounting for wrapping if a box width is specified.
function text_measure_height_wrapped(_tokens, _box_w, _line_height) {
	var _state = text_default_state();
	var _stack = [];

	var _lines = 1;
	var _line_width = 0;

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type != "TEXT" && _token.type != "SPRITE") {
			_state = text_apply_tag(_stack, _state, _token);
			continue;
		}

		if (_token.type == "SPRITE") {
			var _spr = text_asset(_token.args[0]);
			var _spr_w = 0;

			if (_spr != -1) {
				_spr_w = sprite_get_width(_spr) * _state.xscale;
			}

			if (_box_w > 0 && _line_width + _spr_w > _box_w) {
				_lines++;
				_line_width = 0;
			}

			_line_width += _spr_w;
		}

		if (_token.type == "TEXT") {
			if (_state.font != -1) draw_set_font(_state.font);

			var _txt = _token.value;
			var _word = "";

			for (var _c = 1; _c <= string_length(_txt); _c++) {
				var _char = string_char_at(_txt, _c);

				if (_char == "\n") {
					_lines++;
					_line_width = 0;
					_word = "";
					continue;
				}

				if (_char == " ") {
					var _word_w = text_string_width_scaled(_word + " ", _state);

					if (_box_w > 0 && _line_width + _word_w > _box_w) {
						_lines++;
						_line_width = 0;
					}

					_line_width += _word_w;
					_word = "";
				}
				else {
					_word += _char;
				}
			}

			if (_word != "") {
				var _final_w = text_string_width_scaled(_word, _state);

				if (_box_w > 0 && _line_width + _final_w > _box_w) {
					_lines++;
					_line_width = 0;
				}

				_line_width += _final_w;
			}
		}
	}

	return _lines * _line_height;
}
/// @description Converts a string representing an asset name into the corresponding asset index. If the string can be converted to a real number, it returns that number instead, allowing for direct numeric asset references.
/// @param {string} _name The string representing the asset name or numeric index to convert.
/// @returns {real} The asset index corresponding to the input string, either from a named asset or directly from a real number conversion.
function text_is_numeric_string(_value) {
	_value = string_trim(string(_value));

	var _len = string_length(_value);
	if (_len <= 0) {
		return false;
	}

	var _has_digit = false;
	var _has_decimal = false;
	var _has_exponent = false;
	var _has_exponent_digit = false;

	for (var _i = 1; _i <= _len; _i++) {
		var _char = string_char_at(_value, _i);

		if ((_char == "+" || _char == "-") && (_i == 1 || string_upper(string_char_at(_value, _i - 1)) == "E")) {
			continue;
		}

		if (_char == "." && !_has_decimal && !_has_exponent) {
			_has_decimal = true;
			continue;
		}

		if ((_char == "e" || _char == "E") && !_has_exponent && _has_digit) {
			_has_exponent = true;
			continue;
		}

		if (_char >= "0" && _char <= "9") {
			_has_digit = true;

			if (_has_exponent) {
				_has_exponent_digit = true;
			}

			continue;
		}

		return false;
	}

	if (_has_exponent && !_has_exponent_digit) {
		return false;
	}

	return _has_digit;
}

function text_asset(_name) {
	_name = string_trim(string(_name));

	if (text_is_numeric_string(_name)) {
		return real(_name);
	}

	return asset_get_index(_name);
}

function text_font(_name) {
	_name = string_trim(string(_name));

	if (!variable_global_exists("FONT_LOOKUP")) {
		var _font_bootstrap = asset_get_index("font");

		if (_font_bootstrap != -1) {
			script_execute(_font_bootstrap);
		}
	}

	if (text_is_numeric_string(_name)) {
		return real(_name);
	}

	if (variable_global_exists("FONT_LOOKUP")) {
		var _lookup = variable_global_get("FONT_LOOKUP");

		if (variable_struct_exists(_lookup, _name)) {
			return variable_struct_get(_lookup, _name);
		}

		var _upper_name = string_upper(_name);

		if (variable_struct_exists(_lookup, _upper_name)) {
			return variable_struct_get(_lookup, _upper_name);
		}
	}

	var _asset = asset_get_index(_name);

	if (_asset != -1 && asset_get_type(_asset) == asset_font) {
		return _asset;
	}

	return -1;
}
/// @description Converts a string representing a color name into the corresponding color value. This function supports a predefined set of color names (e.g., "c_red", "c_blue") and returns the associated color constant. If the string does not match any known color name, it attempts to convert it to a real number, allowing for direct color values to be used as well.
/// @param {string} _name The string representing the color name or value to convert.
/// @returns {real} The color value corresponding to the input string, either from a predefined color name or directly from a real number conversion.
function text_color(_name) {
	_name = string_lower(string_trim(string(_name)));

	switch (_name) {
		case "c_white": return c_white;
		case "c_black": return c_black;
		case "c_red": return c_red;
		case "c_green": return c_green;
		case "c_blue": return c_blue;
		case "c_yellow": return c_yellow;
		case "c_orange": return c_orange;
		case "c_purple": return c_purple;
		case "c_aqua": return c_aqua;
		case "c_fuchsia": return c_fuchsia;
		case "c_lime": return c_lime;
		case "c_gray": return c_gray;
		case "c_grey": return c_gray;
		case "c_silver": return c_silver;
		case "c_maroon": return c_maroon;
		case "c_navy": return c_navy;
		case "c_pink": return c_pink;
	}

	if (text_is_numeric_string(_name)) {
		return real(_name);
	}

	return c_white;
}

function text_halign(_value) {
	if (is_real(_value)) {
		return _value;
	}

	_value = string_lower(string_trim(string(_value)));

	switch (_value) {
		case "fa_left":
		case "left":
			return fa_left;

		case "fa_center":
		case "center":
		case "centre":
		case "middle":
			return fa_center;

		case "fa_right":
		case "right":
			return fa_right;
	}

	if (text_is_numeric_string(_value)) {
		return real(_value);
	}

	return fa_left;
}

function text_valign(_value) {
	if (is_real(_value)) {
		return _value;
	}

	_value = string_lower(string_trim(string(_value)));

	switch (_value) {
		case "fa_top":
		case "top":
			return fa_top;

		case "fa_middle":
		case "middle":
		case "mid":
		case "center":
		case "centre":
			return fa_middle;

		case "fa_bottom":
		case "bottom":
			return fa_bottom;
	}

	if (text_is_numeric_string(_value)) {
		return real(_value);
	}

	return fa_top;
}

function text_make_sprite_token(_asset, _frame, _speed, _offset_x, _offset_y, _angle) {
	return {
		type: "SPRITE",
		args: [
			_asset,
			is_undefined(_frame) ? 0 : _frame,
			is_undefined(_speed) ? 0 : _speed,
			is_undefined(_offset_x) ? 0 : _offset_x,
			is_undefined(_offset_y) ? 0 : _offset_y,
			is_undefined(_angle) ? 0 : _angle
		]
	};
}

function text_apply_tag_transform(_token, _transform) {
	var _args = [];

	for (var _i = 0; _i < array_length(_token.args); _i++) {
		array_push(_args, _token.args[_i]);
	}

	switch (_token.type) {
		case "OFFSET":
			if (array_length(_args) > 0) _args[0] = real(_args[0]) + _transform.offset_x;
			if (array_length(_args) > 1) _args[1] = real(_args[1]) + _transform.offset_y;
		break;

		case "XOFFSET":
			if (array_length(_args) > 0) _args[0] = real(_args[0]) + _transform.offset_x;
		break;

		case "YOFFSET":
			if (array_length(_args) > 0) _args[0] = real(_args[0]) + _transform.offset_y;
		break;

		case "ANGLE":
		case "ROTATE":
			if (array_length(_args) > 0) _args[0] = real(_args[0]) + _transform.angle;
		break;
	}

	return {
		type: _token.type,
		close: variable_struct_exists(_token, "close") ? _token.close : undefined,
		args: _args
	};
}

function text_apply_transform(_tokens, _transform) {
	var _new_tokens = [];

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type == "TEXT") {
			array_push(_new_tokens, _token);
		}
		else if (_token.type == "SPRITE") {
			var _args = [];
			array_copy(_args, 0, _token.args, 0, array_length(_token.args));

			if (array_length(_args) < 6) {
				array_resize(_args, 6);
				for (var _j = 0; _j < 6; _j++) {
					if (is_undefined(_args[_j])) {
						_args[_j] = 0;
					}
				}
			}

			_args[3] += _transform.offset_x;
			_args[4] += _transform.offset_y;

			if (_transform.angle != 0) {
				_args[5] += _transform.angle;
			}

			array_push(_new_tokens, text_make_sprite_token(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5]));
		}
		else {
			var _new_token = text_apply_tag_transform(_token, _transform);
			array_push(_new_tokens, _new_token);
		}
	}

	return _new_tokens;
}

function TextRenderer(_string) constructor {

	/*==========* * VARIABLES * *==========*/
		STRING = _string;
		TOKENS = text_parse(_string);

		HALIGN = fa_left;
		VALIGN = fa_top;
		
		ANGLE = 0;
		
		OFFSET_X = 0;
		OFFSET_Y = 0;

		BLEND_COLOR = c_white;
		BLEND_ALPHA = 1;

		BOX_W = -1;
		BOX_H = -1;
		BOX_DRAW = false;

		REVEAL = 999999;
		REVEAL_SPEED = 1;

		GRADIENT = [c_white, c_white];
		GRADIENT_DIRECTION = 0;

		RAINBOW = 0;
		
		WAVE = false;
		WAVE_SPEED = 1;
		WAVE_AMP = 5;
		
		WOBBLE = false;
		WOBBLE_SPEED = 1;
		WOBBLE_AMP = 5;
		
		SHAKE = false;
		SHAKE_AMOUNT = 5;
		
		BOUNCE = false;
		BOUNCE_SPEED = 1;
		BOUNCE_AMP = 5;
		
		SINE_AMP = 0;
		SINE_SPEED = 1;
		
		SWAY = 0;
		JITTER = 0;
		SPIN = 0;
		ZOOM = 0;
		FADE = 0;
		HSV = 0;
		FLASH = 0;

		SHADOW_X = 0;
		SHADOW_Y = 0;
		SHADOW_COLOR = c_black;
		SHADOW_ALPHA = 0;

		OUTLINE_SIZE = 0;
		OUTLINE_COLOR = c_black;
		OUTLINE_ALPHA = 0;

		UNDERLINE = false;
		UNDERLINE_COLOR = c_black;
		UNDERLINE_ALPHA = 0;
		UNDERLINE_USE_TEXT_COLOR = false;
		UNDERLINE_OFFSET = 0;
		UNDERLINE_THICKNESS = 2;

		STRIKE = false;
		STRIKE_COLOR = c_black;
		STRIKE_ALPHA = 0;
		STRIKE_USE_TEXT_COLOR = false;
		STRIKE_OFFSET = 0;
		STRIKE_THICKNESS = 2;

	/*========* METHODS *========*/

		/// @description Draws the text to the screen at the specified coordinates, applying all formatting, effects, and reveal settings. This method should be called within a draw event to render the text object.
		/// @param {real | struct.vector2D | array} _x The x-coordinate for the starting position of the text block.
		/// @param {real} _y The y-coordinate for the starting position of the text block. (Ignored if _x is a struct.vector2D or array with two elements)
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		draw = function(_x, _y = 0) {
			if (is_struct(_x) && variable_struct_exists(_x, "x") && variable_struct_exists(_x, "y")) {
				var _position = _x;
				_x = _position.x;
				_y = _position.y;
			} 
			else if (is_array(_x) && array_length(_x) >= 2) {
				var _position = _x;
				_x = _position[0];
				_y = _position[1];
			}
			else {
				_x = _x;
				_y = _y;
			}
			text_draw_tokens(TOKENS, _x, _y, HALIGN, VALIGN, BOX_W, BOX_H, BOX_DRAW, REVEAL, BLEND_COLOR, BLEND_ALPHA);
			return self;
		}
		/// @description Sets the blend color and alpha for the text renderer, which will be multiplied against the colors of all glyphs when drawn. This allows for tinting and fading effects to be applied to the entire text block.
		/// @param {real} _COLOR The color value to use as the blend color.
		/// @param {real} _ALPHA The alpha value (0 to 1) to use as the blend alpha.
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setBLEND = function(_COLOR, _ALPHA) {
			BLEND_COLOR = is_undefined(_COLOR) ? c_white : _COLOR;
			BLEND_ALPHA = is_undefined(_ALPHA) ? 1 : clamp(_ALPHA, 0, 1);
			return self;
		}
		/// @description Sets the horizontal and vertical alignment for the text renderer. This will affect how the text is positioned relative to the coordinates specified in the draw method. The alignment can be set using predefined constants (fa_left, fa_center, fa_right for horizontal; fa_top, fa_middle, fa_bottom for vertical) or by using string values ("left", "center", "right", "top", "middle", "bottom").
		/// @param {string|real} _halign The horizontal alignment value or string.
		/// @param {string|real} _valign The vertical alignment value or string.
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setALIGN = function(_halign, _valign) {
			HALIGN = text_halign(_halign);
			VALIGN = text_valign(_valign);
			return self;
		}
		///	@description Sets the horizontal alignment for the text renderer. This will affect how the text is positioned horizontally relative to the coordinates specified in the draw method. The alignment can be set using predefined constants (fa_left, fa_center, fa_right) or by using string values ("left", "center", "right").
		/// @param {string|real} _h The horizontal alignment value or string.
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setHALIGN = function(_h) {
			HALIGN = text_halign(_h);
			return self;
		}
		/// @description Sets the vertical alignment for the text renderer. This will affect how the text is positioned vertically relative to the coordinates specified in the draw method. The alignment can be set using predefined constants (fa_top, fa_middle, fa_bottom) or by using string values ("top", "middle", "bottom").
		/// @param {string|real} _v The vertical alignment value or string.
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setVALIGN = function(_v) {
			VALIGN = text_valign(_v);
			return self;
		}
		/// @description Applies a transformation to the text renderer, modifying the positions and angles of any relevant tags (e.g., OFFSET, ANGLE) and sprite tokens. This allows for easy application of effects like shaking or rotation to the entire text block by adjusting the underlying tokens.
		/// @param {real} _xscale The amount to scale the text in the x-axis (default is 1 for no scaling).
		/// @param {real} _yscale The amount to scale the text in the y-axis (default is 1 for no scaling).
		/// @param {real} _angle The amount to rotate the text in degrees (default is 0 for no rotation).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		transform = function(_xscale, _yscale, _angle) {
			var _state = text_default_state();
			_state.xscale = _xscale;
			_state.yscale = _yscale;
			_state.angle = _angle;

			TOKENS = text_apply_transform(TOKENS, _state);
			return self;
		}
		/// @description Sets the dimensions of the bounding box for the text renderer. If a positive width is specified, the text will wrap to fit within that width. If a positive height is specified, the text will be clipped to fit within that height. Setting either dimension to -1 disables that constraint. The BOX_DRAW property can be set to true to draw a visible outline of the bounding box for debugging purposes.
		/// @param {real} _w The width of the bounding box (set to -1 for no width constraint).
		/// @param {real} _h The height of the bounding box (set to -1 for no height constraint).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setBOX = function(_w, _h = -1) {
			BOX_W = _w;
			BOX_H = _h;
			return self;
		}
		/// @description Sets whether to draw a visible outline of the bounding box for the text renderer. This is useful for debugging purposes to see where the text is wrapping and clipping based on the specified box dimensions.
		/// @param {bool} _draw Whether to draw the bounding box outline.
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setBOX_DRAW = function(_draw) {
			BOX_DRAW = _draw;
			return self;
		}
		/// @description Sets the number of characters to reveal when drawing the text. This is used for typewriter-style effects where the text is revealed gradually. Setting this to a specific number will reveal that many characters, while setting it to 999999 will reveal all characters.
		/// @param {real} _chars The number of characters to reveal (set to 999999 for all characters).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setREVEAL = function(_chars) {
			REVEAL = _chars;
			return self;
		}
		/// @description Sets the speed at which characters are revealed when using the stepREVEAL method. This value determines how many characters are added to the reveal count each time stepREVEAL is called, allowing for control over the pacing of the reveal effect.
		/// @param {real} _speed The number of characters to add to the reveal count each time stepREVEAL is called (default is 1).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setREVEAL_SPEED = function(_speed) {
			REVEAL_SPEED = _speed;
			return self;
		}
		/// @description Sets the colors to be used for a gradient effect on the text. The gradient will transition between the specified colors across the text, with the direction of the gradient determined by the GRADIENT_DIRECTION property. Colors can be specified as color values or as strings representing color names.
		/// @param {real|string} _color_a The first color in the gradient (can be a color value or a string representing a color name).
		/// @param {real|string} _color_b The second color in the gradient (can be a color value or a string representing a color name).
		/// @param {real|string} _color_c The third color in the gradient (optional, can be a color value or a string representing a color name, default is c_white).
		/// @param {real|string} _color_d The fourth color in the gradient (optional, can be a color value or a string representing a color name, default is c_white).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining
		setGRADIENT = function(_color_a, _color_b, _color_c = c_white, _color_d = c_white) {
			GRADIENT = [_color_a, _color_b, _color_c, _color_d];
			return self;
		}
		/// @description Sets the direction of the gradient effect applied to the text. The direction determines how the colors specified in the GRADIENT property transition across the text. Valid directions include "horizontal" (left to right), "vertical" (top to bottom), "right" (left to right), "down" (top to bottom), "left" (right to left), and "up" (bottom to top). Aliases for these directions are also supported.
		/// @param {string} _direction The direction of the gradient (e.g., "horizontal", "vertical", "right", "down", "left", "up").
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setGRADIENT_DIRECTION = function(_direction) {
			_direction = string_lower(string_trim(string(_direction)));
			switch (_direction) {
				case "horizontal":
				case "right":
				case "ltr":
					GRADIENT_DIRECTION = 0;
				break;

				case "vertical":
				case "down":
				case "ttb":
					GRADIENT_DIRECTION = 1;
				break;

				case "left":
				case "rtl":
					GRADIENT_DIRECTION = 2;
				break;

				case "up":
				case "btt":
					GRADIENT_DIRECTION = 3;
				break;
			}
			return self;
		}
		/// @description Sets the speed of the rainbow effect applied to the text. The rainbow effect cycles through hues over time, creating a colorful animation. The speed value determines how quickly the colors change, with higher values resulting in faster color cycling.
		/// @param {real} _speed The speed of the rainbow effect (default is 0 for no rainbow effect).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setRAINBOW = function(_speed) {
			RAINBOW = _speed;
			return self;
		}
		/// @description Sets the parameters for a wave effect applied to the text. The wave effect creates a sinusoidal distortion of the text, making it appear to wave back and forth. The amplitude parameter controls how far the characters move from their original position, while the speed parameter controls how quickly the wave oscillates.
		/// @param {real} _amp The amplitude of the wave effect, determining how far the characters move from their original position (default is 5).
		/// @param {real} _speed The speed of the wave effect, determining how quickly the wave oscillates (default is 1).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setWAVE = function(_amp, _speed) {
			WAVE = true;
			WAVE_AMP = _amp;
			WAVE_SPEED = _speed;
			return self;
		}
		/// @description Sets the parameters for a wobble effect applied to the text. The wobble effect creates a random jittering motion of the characters, making them appear to wobble around their original position. The amplitude parameter controls how far the characters move from their original position, while the speed parameter controls how quickly the wobble changes.
		/// @param {real} _amp The amplitude of the wobble effect, determining how far the characters move from their original position (default is 5).
		/// @param {real} _speed The speed of the wobble effect, determining how quickly the wobble changes (default is 1).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setWOBBLE = function(_amp, _speed) {
			WOBBLE = true;
			WOBBLE_AMP = _amp;
			WOBBLE_SPEED = _speed;
			return self;
		}
		/// @description Sets the parameters for a shake effect applied to the text. The shake effect creates a rapid, random movement of the characters, making them appear to shake around their original position. The amount parameter controls how far the characters move from their original position during the shake.
		/// @param {real} _amount The intensity of the shake effect, determining how far the characters move from their original position during the shake (default is 5).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setSHAKE = function(_amount) {
			SHAKE = true;
			SHAKE_AMOUNT = _amount;
			return self;
		}
		/// @description Sets the parameters for a bounce effect applied to the text. The bounce effect creates a vertical bouncing motion of the characters, making them appear to bounce up and down. The amplitude parameter controls how high the characters bounce from their original position, while the speed parameter controls how quickly the bounce oscillates.
		/// @param {real} _amp The amplitude of the bounce effect, determining how high the characters bounce from their original position (default is 5).
		/// @param {real} _speed The speed of the bounce effect, determining how quickly the bounce oscillates (default is 1).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setBOUNCE = function(_amp, _speed) {
			BOUNCE = true;
			BOUNCE_AMP = _amp;
			BOUNCE_SPEED = _speed;
			return self;
		}
		/// @description Sets the parameters for a sine wave effect applied to the text. The sine wave effect creates a smooth, sinusoidal distortion of the text, making it appear to flow in a wave-like motion. The amplitude parameter controls how far the characters move from their original position, while the speed parameter controls how quickly the sine wave oscillates.
		/// @param {real} _amp The amplitude of the sine wave effect, determining how far the characters move from their original position (default is 0 for no sine wave effect).
		/// @param {real} _speed The speed of the sine wave effect, determining how quickly the sine wave oscillates (default is 1).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setSINE = function(_amp, _speed) {
			SINE_AMP = _amp;
			SINE_SPEED = _speed;
			return self;
		}
		/// @description Sets the intensity of a sway effect applied to the text. The sway effect creates a smooth, oscillating horizontal movement of the characters, making them appear to sway back and forth. The amount parameter controls how far the characters move from their original position during the sway.
		/// @param {real} _amount The intensity of the sway effect, determining how far the characters move from their original position during the sway (default is 0 for no sway effect).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setSWAY = function(_amount) {
			SWAY = _amount;
			return self;
		}
		/// @description Sets the intensity of a jitter effect applied to the text. The jitter effect creates a random, erratic movement of the characters, making them appear to jitter around their original position. The amount parameter controls how far the characters move from their original position during the jitter.
		/// @param {real} _amount The intensity of the jitter effect, determining how far the characters move from their original position during the jitter (default is 0 for no jitter effect).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setJITTER = function(_amount) {
			JITTER = _amount;
			return self;
		}
		/// @description Sets the speed of a spinning effect applied to the text. The spin effect creates a rotation of the characters around their center point, making them appear to spin. The speed parameter controls how quickly the characters rotate, with higher values resulting in faster spinning.
		/// @param {real} _speed The speed of the spin effect (default is 0 for no spin effect).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setSPIN = function(_speed) {
			SPIN = _speed;
			return self;
		}
		/// @description Sets the intensity of a zoom effect applied to the text. The zoom effect creates a scaling transformation of the characters, making them appear to grow larger or smaller. The amount parameter controls how much the characters are scaled from their original size, with positive values making them larger and negative values making them smaller.
		/// @param {real} _amount The intensity of the zoom effect, determining how much the characters are scaled from their original size (default is 0 for no zoom effect).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setZOOM = function(_amount) {
			ZOOM = _amount;
			return self;
		}
		/// @description Sets the speed of a fading effect applied to the text. The fade effect creates a gradual change in the alpha of the characters, making them appear to fade in or out. The speed parameter controls how quickly the characters fade, with higher values resulting in faster fading.
		/// @param {real} _speed The speed of the fade effect (default is 0 for no fade effect).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setFADE = function(_speed) {
			FADE = _speed;
			return self;
		}
		/// @description Sets the speed of an HSV cycling effect applied to the text. The HSV effect creates a cycling of colors through the hue spectrum, making the text appear to change colors over time. The speed parameter controls how quickly the colors cycle, with higher values resulting in faster color changes.
		/// @param {real} _speed The speed of the HSV effect (default is 0 for no HSV effect).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setHSV = function(_speed) {
			HSV = _speed;
			return self;
		}
		/// @description Sets the speed of a flashing effect applied to the text. The flash effect creates a rapid toggling of the characters' visibility, making them appear to flash on and off. The speed parameter controls how quickly the characters flash, with higher values resulting in faster flashing.
		/// @param {real} _speed The speed of the flash effect (default is 0 for no flash effect).
		/// @returns {struct.TextRenderer} Returns the text renderer
		setFLASH = function(_speed) {
			FLASH = _speed;
			return self;
		}
		/// @description Sets the parameters for a shadow effect applied to the text. The shadow effect draws a shadow behind the characters, creating a sense of depth. The color parameter specifies the color of the shadow, while the x and y parameters specify the offset of the shadow from the original text position. The alpha parameter controls the transparency of the shadow, with higher values resulting in a more opaque shadow.
		/// @param {real|string} _color The color of the shadow (can be a color value or a string representing a color name).
		/// @param {real} _x The horizontal offset of the shadow from the original text position (default is 0).
		/// @param {real} _y The vertical offset of the shadow from the original text position (default is 0).
		/// @param {real} _alpha The alpha value (0 to 1) for the shadow's transparency (default is 0 for no shadow).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setSHADOW = function(_color, _x, _y, _alpha) {
			SHADOW_COLOR = is_undefined(_color) ? c_black : _color;
			SHADOW_X = is_undefined(_x) ? 0 : _x;
			SHADOW_Y = is_undefined(_y) ? 0 : _y;
			SHADOW_ALPHA = is_undefined(_alpha) ? 0 : clamp(_alpha, 0, 1);
			return self;
		}
		/// @description Sets the parameters for an outline effect applied to the text. The outline effect draws a border around the characters, making them stand out more. The color parameter specifies the color of the outline, while the size parameter specifies how thick the outline should be. The alpha parameter controls the transparency of the outline, with higher values resulting in a more opaque outline.
		/// @param {real|string} _color The color of the outline (can be a color value or a string representing a color name).
		/// @param {real} _size The thickness of the outline (default is 0 for no outline).
		/// @param {real} _alpha The alpha value (0 to 1) for the outline's transparency (default is 0 for no outline).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setOUTLINE = function(_color, _size, _alpha) {
			OUTLINE_COLOR = is_undefined(_color) ? c_black : _color;
			OUTLINE_SIZE = is_undefined(_size) ? 0 : _size;
			OUTLINE_ALPHA = is_undefined(_alpha) ? 0 : clamp(_alpha, 0, 1);
			return self;
		}
		/// @description Sets the parameters for an underline effect applied to the text. The underline effect draws a line beneath the characters, which can be used for emphasis. The color parameter specifies the color of the underline, while the thickness parameter specifies how thick the underline should be. The alpha parameter controls the transparency of the underline, with higher values resulting in a more opaque underline. If UNDERLINE_USE_TEXT_COLOR is set to true, the underline will use the current text color instead of the specified color. The offset parameter allows for adjusting the vertical position of the underline relative to the text.
		/// @param {real|string} _color The color of the underline (can be a color value or a string representing a color name).
		/// @param {real} _thickness The thickness of the underline (default is 2).
		/// @param {real} _alpha The alpha value (0 to 1) for the underline's transparency (default is 0 for no underline).
		/// @param {real} _offset The vertical offset of the underline from its default position (default is 0).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setUNDERLINE = function(_color, _thickness, _alpha, _offset) {
			UNDERLINE_COLOR = is_undefined(_color) ? c_black : _color;
			UNDERLINE_THICKNESS = is_undefined(_thickness) ? 2 : _thickness;
			UNDERLINE_ALPHA = is_undefined(_alpha) ? 0 : clamp(_alpha, 0, 1);
			UNDERLINE_OFFSET = is_undefined(_offset) ? 0 : _offset;
			return self;
		}
		/// @description Sets the parameters for a strike-through effect applied to the text. The strike-through effect draws a line through the middle of the characters, which can be used to indicate deletion or emphasis. The color parameter specifies the color of the strike-through, while the thickness parameter specifies how thick	 the strike-through should be. The alpha parameter controls the transparency of the strike-through, with higher values resulting in a more opaque strike-through. If STRIKE_USE_TEXT_COLOR is set to true, the strike-through will use the current text color instead of the specified color. The offset parameter allows for adjusting the vertical position of the strike-through relative to the text.
		/// @param {real|string} _color The color of the strike-through (can be a color value or a string representing a color name).
		/// @param {real} _thickness The thickness of the strike-through (default is 2).
		/// @param {real} _alpha The alpha value (0 to 1) for the strike-through's transparency (default is 0 for no strike-through).
		/// @param {real} _offset The vertical offset of the strike-through from its default position (default is 0).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		setSTRIKE = function(_color, _thickness, _alpha, _offset) {
			STRIKE_COLOR = is_undefined(_color) ? c_black : _color;
			STRIKE_THICKNESS = is_undefined(_thickness) ? 2 : _thickness;
			STRIKE_ALPHA = is_undefined(_alpha) ? 0 : clamp(_alpha, 0, 1);
			STRIKE_OFFSET = is_undefined(_offset) ? 0 : _offset;
			return self;
		}

		/// @description Increments the number of characters to reveal by a specified speed value. This can be called repeatedly (e.g., in a step event) to create a gradual reveal effect over time.
		/// @param {real} _speed The number of characters to add to the reveal count (default is 1).
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		stepREVEAL = function(_speed = 1) {
			REVEAL += _speed;
			return self;
		}
		/// @description Resets the reveal count to 0, hiding all characters. This can be used to restart a typewriter effect from the beginning.
		/// @returns {struct.TextRenderer} Returns the text renderer instance to allow for method chaining.
		resetREVEAL = function() {
			REVEAL = 0;
			return self;
		}
		/// @description Checks whether the reveal effect has finished revealing all characters in the text. This returns true if the current reveal count is greater than or equal to the total number of characters in the text, indicating that all characters are now visible.
		/// @returns {bool} Returns true if the reveal effect is finished, false otherwise.
		isFINISHED = function() {
			return REVEAL >= text_visible_count(TOKENS);
		}
}

/// @description Convenience wrapper for creating a text renderer without calling the constructor directly.
/// @param {string} _string The string to be rendered by the text object.
/// @returns {struct.TextRenderer}
function text(_string) {
	return new TextRenderer(_string);
}

/// @description Reads an optional field from a struct, falling back when the struct or field is missing.
/// @param {struct} _options The options struct to read from.
/// @param {string} _name The field name.
/// @param {*} _fallback The fallback value when the field is unavailable.
/// @returns {*}
function text_option_get(_options, _name, _fallback) {
	if (is_struct(_options) && variable_struct_exists(_options, _name)) {
		return variable_struct_get(_options, _name);
	}

	return _fallback;
}

/// @description Draws a compact rounded label bubble sized from textRENDERER tokens, similar to an event mini label.
/// @param {string} _string Markup-enabled label text.
/// @param {real|struct.vector2D|array} _x The label anchor x-coordinate, or a position struct / array.
/// @param {real|struct} _y The label anchor y-coordinate, or the options struct if _x is a position struct / array.
/// @param {struct} _options Optional settings: box_w, padding_x, padding_y, halign, valign, text_halign, text_valign, offset_x, offset_y, background_color, background_alpha, outline_color, outline_alpha, shadow_color, shadow_alpha, shadow_x, shadow_y, text_color, text_alpha.
/// @returns {struct} The drawn label bounds and measured content size.
function text_draw_mini_label(_string, _x, _y = 0, _options = undefined) {
	if (is_struct(_x) && variable_struct_exists(_x, "x") && variable_struct_exists(_x, "y")) {
		var _position = _x;
		_options = _y;
		_x = _position.x;
		_y = _position.y;
	}
	else if (is_array(_x) && array_length(_x) >= 2) {
		var _position = _x;
		_options = _y;
		_x = _position[0];
		_y = _position[1];
	}

	var _markup = is_undefined(_string) ? "" : string(_string);
	if (_markup == "") {
		return {
			left: _x,
			top: _y,
			right: _x,
			bottom: _y,
			width: 0,
			height: 0,
			text_width: 0,
			text_height: 0
		};
	}

	var _box_w = text_option_get(_options, "box_w", -1);
	if (_box_w <= 0) {
		_box_w = -1;
	}
	var _box_h = text_option_get(_options, "box_h", -1);
	if (_box_h <= 0) {
		_box_h = -1;
	}

	var _padding_x = max(0, text_option_get(_options, "padding_x", 10));
	var _padding_y = max(0, text_option_get(_options, "padding_y", 5));
	var _offset_x = text_option_get(_options, "offset_x", 0);
	var _offset_y = text_option_get(_options, "offset_y", 0);
	var _halign = text_halign(text_option_get(_options, "halign", fa_center));
	var _valign = text_valign(text_option_get(_options, "valign", fa_bottom));
	var _text_halign = text_halign(text_option_get(_options, "text_halign", fa_center));
	var _text_valign = text_valign(text_option_get(_options, "text_valign", fa_middle));

	var _background_color = text_color(text_option_get(_options, "background_color", c_black));
	var _background_alpha = clamp(text_option_get(_options, "background_alpha", 0.8), 0, 1);
	var _outline_color = text_color(text_option_get(_options, "outline_color", c_white));
	var _outline_alpha = clamp(text_option_get(_options, "outline_alpha", 0.18), 0, 1);
	var _shadow_color = text_color(text_option_get(_options, "shadow_color", c_black));
	var _shadow_alpha = clamp(text_option_get(_options, "shadow_alpha", 0.28), 0, 1);
	var _shadow_x = text_option_get(_options, "shadow_x", 2);
	var _shadow_y = text_option_get(_options, "shadow_y", 2);
	var _text_color = text_color(text_option_get(_options, "text_color", c_white));
	var _text_alpha = clamp(text_option_get(_options, "text_alpha", 1), 0, 1);

	_x += _offset_x;
	_y += _offset_y;

	var _tokens = text_parse(_markup);
	var _line_height = text_get_line_height(_tokens);
	var _content_w = max(1, text_measure_width_wrapped(_tokens, _box_w));
	var _content_h = max(1, text_measure_height_wrapped(_tokens, _box_w, _line_height));
	var _draw_box_w = (_box_w > 0) ? _box_w : _content_w;
	var _label_w = _draw_box_w + (_padding_x * 2);
	var _label_h = _content_h + (_padding_y * 2);

	var _left = _x;
	switch (_halign) {
		case fa_center:
			_left -= _label_w * 0.5;
		break;

		case fa_right:
			_left -= _label_w;
		break;
	}

	var _top = _y;
	switch (_valign) {
		case fa_middle:
			_top -= _label_h * 0.5;
		break;

		case fa_bottom:
			_top -= _label_h;
		break;
	}

	var _right = _left + _label_w;
	var _bottom = _top + _label_h;
	var _content_x = _left + _padding_x;
	var _content_y = _top + _padding_y;
	var _text_x = _content_x;
	var _text_y = _content_y;
	var _previous_color = draw_get_color();
	var _previous_alpha = draw_get_alpha();

	switch (_text_halign) {
		case fa_center:
			_text_x += _draw_box_w * 0.5;
		break;

		case fa_right:
			_text_x += _draw_box_w;
		break;
	}

	switch (_text_valign) {
		case fa_middle:
			_text_y += _content_h * 0.5;
		break;

		case fa_bottom:
			_text_y += _content_h;
		break;
	}

	if (_shadow_alpha > 0) {
		draw_set_color(_shadow_color);
		draw_set_alpha(_shadow_alpha);
		draw_roundrect(_left + _shadow_x, _top + _shadow_y, _right + _shadow_x, _bottom + _shadow_y, false);
	}

	draw_set_color(_background_color);
	draw_set_alpha(_background_alpha);
	draw_roundrect(_left, _top, _right, _bottom, false);

	if (_outline_alpha > 0) {
		draw_set_color(_outline_color);
		draw_set_alpha(_outline_alpha);
		draw_roundrect(_left, _top, _right, _bottom, true);
	}

	var _label_text = new TextRenderer(_markup);
	_label_text.setALIGN(_text_halign, _text_valign);
	_label_text.setBOX(_draw_box_w, -1);
	_label_text.setBLEND(_text_color, _text_alpha);
	_label_text.draw(_text_x, _text_y);

	draw_set_color(_previous_color);
	draw_set_alpha(_previous_alpha);

	return {
		left: _left,
		top: _top,
		right: _right,
		bottom: _bottom,
		width: _label_w,
		height: _label_h,
		text_width: _draw_box_w,
		text_height: _content_h
	};
}

/*Example Usage*/
/*
TAGS:
[COLOR: c_colorname or colorvalue, alpha or ink color, optional ink color or alpha] - Changes text color, with optional alpha and optional black/ink color in the same tag
[BLACK: color] - Changes the black source pixels inside the font to the specified color
[GRADIENT: color_a, color_b, color_c (optional), color_d (optional)] - Applies a gradient over the tagged text, with color_c and color_d optional
[GRADIENT_DIRECTION: right|left|down|up] - Sets the gradient direction. Aliases include horizontal, vertical, ltr, rtl, ttb, and btt
[ALPHA: value] - Changes text alpha
[SHADOW: color, x, y, alpha] - Draws a shadow behind the text
[OUTLINE: color, size, alpha] - Draws an outline around the text
[SCALE: value] - Changes both x and y scale
[XSCALE: value] - Changes x scale
[YSCALE: value] - Changes y scale
[FONT: assetname, macro name, or assetindex] - Changes font
[/FONT] - Reverts to the default font set by text_renderer_set_default_font(...)
[ALIGN: horizontal, vertical] - Sets horizontal and vertical alignment for subsequent lines
[HALIGN: left|center|right or fa_*] - Sets horizontal alignment for subsequent lines
[VALIGN: top|middle|bottom or fa_*] - Sets vertical alignment for subsequent lines
[LEFT], [CENTER], [RIGHT] - Shorthand horizontal alignment tags
[TOP], [MIDDLE], [BOTTOM] - Shorthand vertical alignment tags
[WAVE: amplitude, speed] - Applies a wave effect to the text, with optional amplitude and speed parameters
[WOBBLE: amount, speed] - Applies a wobble effect to the text, with optional angle amount and speed parameters
[SHAKE: amount] - Applies a shake effect to the text, with optional intensity parameter
[BOUNCE: height, speed] - Applies a bounce effect to the text, with optional height and speed parameters
[UNDERLINE: color, thickness, alpha, offset] - Draws an underline using the text color by default
[STRIKE: color, thickness, alpha, offset] - Draws a strike-through using the text color by default
[RAINBOW: speed] - Applies a rainbow color effect to the text, with optional speed parameter
[ROTATE, ANGLE: angle] - Rotates the text by a fixed angle
[RESET] - Resets all text effects and formatting to default
[SPEED: value] - Marks reveal speed for external reveal logic
[PAUSE: value] - Pauses the reveal effect for a certain duration (handled externally)
[SINE: amplitude, speed] - Applies a sine wave effect to the text with specified amplitude and speed
[JITTER: amount] - Applies a jitter effect to the text with specified intensity
[SWAY: amount] - Applies a sway effect to the text with specified intensity
[SPIN: speed] - Applies a spinning effect to the text with specified speed
[ZOOM: amount] - Applies a zoom effect to the text with specified intensity
[FADE: speed] - Applies a fading effect to the text with specified speed
[HSV: speed] - Applies a cycling HSV color effect to the text with specified speed
[FLASH: speed] - Applies a flashing effect to the text with specified speed
[OFFSET: x, y] - Applies a positional offset to the text with specified x and y values
[XOFFSET: value] - Applies a positional offset only on the x-axis
[YOFFSET: value] - Applies a positional offset only on the y-axis
[LINEHEIGHT: multiplier] - Multiplies the line height by the specified value
[LEADING: multiplier] - Alias for LINEHEIGHT
[SPACE: amount] - Adds extra spacing between characters with the specified value
[LETTERSPACE, TRACKING: amount] - Alias for SPACE
[SPRITE: assetname or assetindex, frame, speed, offset_x, offset_y, angle] - Draws a sprite inline with optional frame, animation speed, offset, and angle parameters
[WAIT: value] - Pauses the reveal effect for a certain duration.
[/COLOR], [/BLACK], [/WAVE], etc. - Closes the corresponding tag effect

var myText;
myText = text("Hello [color:c_red,c_black][underline]World[/underline][/color]!\nThis is a [gradient:c_red,c_yellow,c_blue]text renderer[/gradient] [strike]example[/strike].")
	.setALIGN(fa_center, fa_middle)
	.setBOX(200, 100)
	.setBOX_DRAW(true)
	.setREVEAL(0);

myText.draw(room_width * 0.5, room_height * 0.5);
*/