shader_type canvas_item;
uniform vec2 resol = vec2(1680, 1050);
uniform float red_bands = 1;
uniform float green_bands = 1;
uniform float blue_bands = 1;

float dither4x4(vec2 position, float brightness, float bands)
{
	float x = floor(mod(position.x, 4));
	float y = floor(mod(position.y, 4));
	float index = floor(x + y * 4.0);
	float limit = 0.0;
	float stepp = 1.0 / bands;
	if(x < 8.0)
	{
		// this is not elegant, but neccessery due to Godots GLSL limitations on array usage
		if (index == float(0))  { limit = 0.0625; }
		if (index == float(1))  { limit = 0.5625; }
		if (index == float(2))  { limit = 0.1875; }
		if (index == float(3))  { limit = 0.6875; }
		if (index == float(4))  { limit = 0.8125; }
		if (index == float(5))  { limit = 0.3125; }
		if (index == float(6))  { limit = 0.9375; }
		if (index == float(7))  { limit = 0.4375; }
		if (index == float(8))  { limit = 0.25;   }
		if (index == float(9))  { limit = 0.75;   }
		if (index == float(10)) { limit = 0.125;  }
		if (index == float(11)) { limit = 0.625;  }
		if (index == float(12)) { limit = 1.0;    }
		if (index == float(13)) { limit = 0.5;    }
		if (index == float(14)) { limit = 0.875;  }
		if (index == float(15)) { limit = 0.375;  } 
	}
	float a = brightness - mod(brightness,stepp);
	float b = brightness - mod(brightness,stepp)+stepp;
	limit = limit/bands + a;
	float _out = a;
	if (brightness > limit) { _out = b; }
	return _out;
}

vec3 dither4x4xvec3(vec2 pos, vec4 col)
{
	return vec3(dither4x4(pos, col.x, red_bands),dither4x4(pos, col.y, green_bands),dither4x4(pos, col.z, blue_bands));
}

void fragment()
{
	vec4 col = texture(TEXTURE, UV);
	COLOR = vec4(dither4x4xvec3(resol*UV, col),1);
}


