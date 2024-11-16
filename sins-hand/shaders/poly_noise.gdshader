shader_type canvas_item;

uniform float time_scale = 0.5;
uniform vec2 screen_size = vec2(1200.0, 1900.0);

vec3 palette( in float t)
{
	vec3 a = vec3(1.0, 0.5, 0.5);
	vec3 b = vec3(0.5, 0.5, 0.5);
	vec3 c = vec3(0.75, 1.0, 0.667);
	vec3 d = vec3(-0.8, 1.0, 0.333);

    return a + b*cos( 6.28318*(c*t+d) );
}

vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v){
  const vec4 C = vec4(0.211324865405187, 0.366025403784439,
           -0.577350269189626, 0.024390243902439);

  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
  + i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
    dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h ) + cos(sin(TIME)) * 0.25;
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}



float easeInOutCubic(float x) {
    return x < 0.5 ? 4.0 * x * x * x : 1.0 - pow(-2.0 * x + 2.0, 3.0) / 2.0;
}


void fragment() {
	vec2 uv = (UV*screen_size.y/screen_size.x) * 2.0 - screen_size.y/screen_size.x; // center UV originally (0.5, 0.5) and center UV (x2) so that (-1.0) will make the center UV be (0.0, 0.0)
	//vec2 uv = UV*2.0 - 1.0;
	uv /= 5.0;
	uv.y *= screen_size.y/screen_size.x;
	//uv.y *= 0.20;

	float uv0 = length(uv); //distance to center of screen

	float noise_frequency = 50.0;
	vec3 the_color = vec3(0.15);

	vec3 final_color = vec3(0.0);

	uv = vec2(
		uv.x * pow(abs(cos(TIME * time_scale)), 1.5 * exp(uv0)) - uv.y * pow(abs(sin(TIME * time_scale)), 1.5 * exp(uv0)),
		uv.x * pow(abs(sin(TIME * time_scale)), 1.5 * exp(uv0)) + uv.y * pow(abs(cos(TIME * time_scale)), 1.5 * exp(uv0))
	) * pow(exp(uv0), 1.05) ;

	vec2 noise_offset = vec2(
		sin(TIME*time_scale) + cos(TIME*time_scale), cos(TIME*time_scale) - sin(TIME*time_scale)
	) * pow(exp(uv0), 1.25) ;

	//uv = fract(uv);

	//if(
		//texture(noise_texture, uv + 0.5).x > 0.6 + pow(abs(sin(TIME*time_scale)/4.0), 1.2) &&
	 	//texture(noise_texture, uv + 0.5).x < 0.7 + pow(abs(sin(TIME*time_scale)/4.0), 1.2) ||
		//texture(noise_texture, uv + 0.5).x > 0.3 + pow(abs(sin(TIME*time_scale)/4.0), 1.2) &&
		//texture(noise_texture, uv + 0.5).x < 0.4 + pow(abs(sin(TIME*time_scale)/4.0), 1.2)){
		//COLOR = vec4(the_color, 1.0);
	//}
	////else if(
		////texture(noise_texture, vec2(uv.x - TEXTURE_PIXEL_SIZE.x/1.5, uv.y)).x > 0.6 + pow(abs(sin(TIME*time_scale)/4.0), 1.2) &&
	 	////texture(noise_texture, vec2(uv.x - TEXTURE_PIXEL_SIZE.x/1.5, uv.y)).x < 0.7 + pow(abs(sin(TIME*time_scale)/4.0), 1.2) ||
		////texture(noise_texture, vec2(uv.x - TEXTURE_PIXEL_SIZE.x/1.5, uv.y)).x > 0.3 + pow(abs(sin(TIME*time_scale)/4.0), 1.2) &&
		////texture(noise_texture, vec2(uv.x - TEXTURE_PIXEL_SIZE.x/1.5, uv.y)).x < 0.4 + pow(abs(sin(TIME*time_scale)/4.0), 1.2))
	////{
		////// CHROMATIC ABBERATION, IF PIXEL TO LEFT IS IN VALID RANGE THEN RED
		////COLOR = vec4(1.0, 0.0, 0.0, 1.0);
	////}
	////else if(
		////texture(noise_texture, vec2(uv.x + TEXTURE_PIXEL_SIZE.x/1.5, uv.y)).x > 0.6 + pow(abs(sin(TIME*time_scale)/4.0), 1.2) &&
	 	////texture(noise_texture, vec2(uv.x + TEXTURE_PIXEL_SIZE.x/1.5, uv.y)).x < 0.7 + pow(abs(sin(TIME*time_scale)/4.0), 1.2) ||
		////texture(noise_texture, vec2(uv.x + TEXTURE_PIXEL_SIZE.x/1.5, uv.y)).x > 0.3 + pow(abs(sin(TIME*time_scale)/4.0), 1.2) &&
		////texture(noise_texture, vec2(uv.x + TEXTURE_PIXEL_SIZE.x/1.5, uv.y)).x < 0.4 + pow(abs(sin(TIME*time_scale)/4.0), 1.2))
	////{
		////// CHROMATIC ABBERATION, IF PIXEL TO LEFT IS IN VALID RANGE THEN RED
		////COLOR = vec4(0.0, 0.75, 1.0, 1.0);
	////}
	//else{
		//COLOR = vec4(vec3(0.0), 1.0);
	//}
	//COLOR = vec4(vec3(uv, 0.0), 1.0);

	//modify UV on noise
	uv += snoise(uv * noise_frequency + noise_offset * time_scale * 1.5) / 35.0;

	uv.y += TIME*time_scale/2.5;

	float outline_size = 80.0 + sin(TIME*time_scale) * 30.0;
	if(
		snoise(uv * noise_frequency + noise_offset * time_scale * 1.5) > 0.6 + abs(sin(TIME*time_scale)/4.0) &&
		snoise(uv * noise_frequency + noise_offset * time_scale * 1.5) < 0.7 + abs(sin(TIME*time_scale)/4.0) ||
		snoise(uv * noise_frequency + noise_offset * time_scale * 1.5) > 0.025 + abs(sin(TIME*time_scale)/4.0) &&
		snoise(uv * noise_frequency + noise_offset * time_scale * 1.5) < 0.2 + abs(sin(TIME*time_scale)/4.0)){
		final_color += the_color;
	}
	//else if(
		//snoise(vec2(uv.x - TEXTURE_PIXEL_SIZE.x/outline_size, uv.y) * noise_frequency + noise_offset * time_scale * 1.5) > 0.2 + abs(sin(TIME*time_scale)/4.0) &&
		//snoise(vec2(uv.x - TEXTURE_PIXEL_SIZE.x/outline_size, uv.y) * noise_frequency + noise_offset * time_scale * 1.5) < 0.325 + abs(sin(TIME*time_scale)/4.0) ||
		//snoise(vec2(uv.x - TEXTURE_PIXEL_SIZE.x/outline_size, uv.y) * noise_frequency + noise_offset * time_scale * 1.5) > 0.05 + abs(sin(TIME*time_scale)/4.0) &&
		//snoise(vec2(uv.x - TEXTURE_PIXEL_SIZE.x/outline_size, uv.y) * noise_frequency + noise_offset * time_scale * 1.5) < 0.1 + abs(sin(TIME*time_scale)/4.0))
	//{
		//// CHROMATIC ABBERATION, IF PIXEL TO LEFT IS IN VALID RANGE THEN red
		//final_color += vec3(1.325, 75.0/255.0, 110.0/255.0);
		////final_color += vec3(1.0,0.0,0.0);
	//}
	//else if(
		//snoise(vec2(uv.x + TEXTURE_PIXEL_SIZE.x/outline_size, uv.y) * noise_frequency + noise_offset * time_scale * 1.5) > 0.2 + abs(sin(TIME*time_scale)/4.0) &&
		//snoise(vec2(uv.x + TEXTURE_PIXEL_SIZE.x/outline_size, uv.y) * noise_frequency + noise_offset * time_scale * 1.5) < 0.325 + abs(sin(TIME*time_scale)/4.0) ||
		//snoise(vec2(uv.x + TEXTURE_PIXEL_SIZE.x/outline_size, uv.y) * noise_frequency + noise_offset * time_scale * 1.5) > 0.05 + abs(sin(TIME*time_scale)/4.0) &&
		//snoise(vec2(uv.x + TEXTURE_PIXEL_SIZE.x/outline_size, uv.y) * noise_frequency + noise_offset * time_scale * 1.5) < 0.1 + abs(sin(TIME*time_scale)/4.0))
	//{
		//// CHROMATIC ABBERATION, IF PIXEL TO LEFT IS IN VALID RANGE THEN blue
		//final_color += vec3(0.55, 1.25, 1.75);
	//}
	else{
		final_color += vec3(11.0/255.0, 8.0/255.0, 13.0/255.0);
	}


	float center_gradient = 0.55;
	vec2 screen_centered_uv = SCREEN_UV - 0.5;
	COLOR = vec4(final_color * smoothstep(0.0, 0.5, abs(screen_centered_uv.x)) * center_gradient, 1.0);
}
