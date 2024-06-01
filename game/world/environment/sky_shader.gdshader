shader_type canvas_item;

uniform vec3 horizon_color= vec3(0, 0, 1);
uniform vec3 atmo_color= vec3(0, 0, 0);
uniform float height;

uniform float y;



void fragment()
{
	COLOR= vec4(mix(horizon_color, atmo_color, max(0, -y / height)), 1.0);
}
	