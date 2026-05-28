#macro jsonNAME "angelkid.json"
#macro compatibilityVERSION 0

function defaultSETTINGS()
{
	return {
		MASTER_VOLUME: 1.0,
		FULLSCREEN: false
	};
}

function applySETTINGS(settings)
{
	if (is_undefined(settings) || !is_struct(settings)) {
		settings = defaultSETTINGS();
	}

	settings.MASTER_VOLUME = clamp(settings.MASTER_VOLUME, 0, 1);
	audio_master_gain(settings.MASTER_VOLUME);

	if (window_get_fullscreen() != settings.FULLSCREEN) {
		window_set_fullscreen(settings.FULLSCREEN);
	}
}

function saveSETTINGS()
{
	if (!variable_global_exists("SAVE") || !is_struct(global.SAVE)) {
		return;
	}

	if (!variable_struct_exists(global.SAVE, "SETTINGS") || !is_struct(global.SAVE.SETTINGS)) {
		global.SAVE.SETTINGS = defaultSETTINGS();
	}

	applySETTINGS(global.SAVE.SETTINGS);
	jsonSAVE();
}

function defaultSAVE()
{
	var struct =
	{
		COMPATIBILITY_VERSION: compatibilityVERSION,
		
		WORLD: 0,
		STAGE: 0,
		CLEARED_WORLDS: [],
		CLEARED_STAGES: [],
		SETTINGS: defaultSETTINGS()
	};
	
	for (var i = 0; i < worlds.count; i++) { struct.CLEARED_STAGES[i] = []; }
	
	return struct;
}

function jsonSAVE(data = global.SAVE, fileName = jsonNAME)
{
    var save_string = json_stringify(data, true);
    var save_buffer = buffer_create(string_byte_length(save_string) + 1, buffer_fixed, 1);
	
    buffer_write(save_buffer, buffer_string, save_string);
    buffer_save(save_buffer, fileName);
    buffer_delete(save_buffer);
}

function jsonLOAD(fileName = jsonNAME) 
{
    if !file_exists(fileName) return;
   
    var load_buffer = buffer_load(fileName);
	if load_buffer == -1 { return {}; }
	
    var load_string = buffer_read(load_buffer, buffer_string);
	
    buffer_delete(load_buffer);
	return json_parse(load_string);
}