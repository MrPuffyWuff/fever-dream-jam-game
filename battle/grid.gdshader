shader_type spatial;

uniform sampler2D material;
uniform sampler2D highlight_tex : source_color;
uniform vec2 dimensions;
//What ever number needs to be bigger thaan maximum number of possible movement tiles
uniform vec2 tiles[100];

void vertex() {
	
}

void fragment() {
	//SCREEN_TEXTURE
	ALBEDO = texture(material, UV).rgb;
	for(int i = 0; i < tiles.length();i++){
		if (tiles[i] == floor(UV * dimensions)){
			vec2 scaled_uv = (vec2(16.16) * dimensions * UV);
			vec2 mod_uv = vec2(float(int(scaled_uv.x) % 16)/16.0, float(int(scaled_uv.y) % 16)/16.0);
			ALBEDO = texture(highlight_tex, mod_uv).rgb;
		}
	}
	
	
	//ALPHA = 0.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
