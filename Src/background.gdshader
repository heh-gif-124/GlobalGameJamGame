// Made by ZiexDev.

shader_type canvas_item;

// === GRID CONFIG ===
uniform vec4 grid_color : source_color = vec4(0.04, 0.05, 0.12, 1.0);
uniform float grid_spacing = 50.0;
uniform float line_thickness = 1.0;

// === GRID WORLD POS/BOUNDS ===
uniform vec2 grid_visual_world_pos = vec2(0.0, 0.0);
uniform vec2 grid_visual_world_size = vec2(1920.0, 1080.0);
uniform float global_time_sec;

// === MAX PULSES ===
const int MAX_PULSES = 3;
uniform int active_pulse_count;

// === PULSE DATA ===
uniform vec2 ripple_origin_world[MAX_PULSES];
uniform float ripple_start_time[MAX_PULSES];

uniform vec2 implosion_origin_world[MAX_PULSES];
uniform float implosion_start_time[MAX_PULSES];

// === SHARED PULSE CONFIG ===
uniform float ripple_speed = 1200.0;
uniform float ripple_thickness = 70.0;
uniform float ripple_peak_strength = 45.0;

uniform float implosion_speed = 1000.0;
uniform float implosion_thickness = 80.0;
uniform float implosion_peak_strength = 60.0;

void fragment() {
	vec2 world_pos = grid_visual_world_pos + (UV * grid_visual_world_size);
	vec2 displacement = vec2(0.0);
	float effect_strength = 0.0;

	for (int i = 0; i < MAX_PULSES; i++) {
		if (i >= active_pulse_count) break;

		// === RIPPLE ===
		float dt_ripple = global_time_sec - ripple_start_time[i];
		if (dt_ripple > 0.0) {
			float dist = distance(world_pos, ripple_origin_world[i]);
			float wave_front = dt_ripple * ripple_speed;

			if (dist >= (wave_front - ripple_thickness) && dist <= wave_front) {
				float t = (dist - (wave_front - ripple_thickness)) / ripple_thickness;
				float strength = (t * t) * (1.0 - t);
				float fade = max(1.0 - dist / 1500.0, 0.0);
				vec2 dir = normalize(world_pos - ripple_origin_world[i]);
				displacement += dir * (strength * ripple_peak_strength * fade);
				effect_strength = max(effect_strength, strength * fade);
			}
		}

		// === IMPLOSION ===
		float dt_impl = global_time_sec - implosion_start_time[i];
		if (dt_impl > 0.0) {
			float dist = distance(world_pos, implosion_origin_world[i]);
			float wave_front = dt_impl * implosion_speed;

			if (dist >= (wave_front - implosion_thickness) && dist <= wave_front) {
				float t = (dist - (wave_front - implosion_thickness)) / implosion_thickness;
				float strength = (t * t) * (1.0 - t);
				float fade = max(1.0 - dist / 1800.0, 0.0);
				vec2 dir = normalize(world_pos - implosion_origin_world[i]);
				displacement -= dir * (strength * implosion_peak_strength * fade);
				effect_strength = max(effect_strength, strength * fade);
			}
		}
	}
	
	vec2 grid_coord = world_pos + displacement;
	float x_mod = mod(grid_coord.x, grid_spacing);
	float y_mod = mod(grid_coord.y, grid_spacing);
	
	float alpha = 0.0;
	if (x_mod < line_thickness || grid_spacing - x_mod < line_thickness ||
	    y_mod < line_thickness || grid_spacing - y_mod < line_thickness) {
		alpha = 1.0;
	}

	alpha *= (1.0 - (effect_strength * effect_strength));
	alpha = clamp(alpha, 0.0, 1.0);
	vec4 color = grid_color * (1.0 + effect_strength * 3.0);

	COLOR = mix(vec4(0.0), color, alpha);
}

// Made by ZiexDev.