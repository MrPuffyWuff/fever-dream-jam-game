shader_type spatial;

uniform sampler2D material;
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
			ALBEDO = vec3(0.0, 0.0, 1.0);
		}
	}
	
	
	//ALPHA = 0.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
