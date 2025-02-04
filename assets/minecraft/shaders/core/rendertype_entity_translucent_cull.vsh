#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform float FogStart;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec2 texCoord2;
out vec4 normal;

const vec2[4] corners = vec2[4](vec2(-1, 1), vec2(-1, -1), vec2(1, -1), vec2(1, 1));

void main() {
    //gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
	
	vertexColor = vec4(0);
    #moj_import <flat_item.glsl>

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    
	//vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color) * texelFetch(Sampler2, UV2 / 16, 0);
    // written by shmoobalizer
	if (fzyEqlV3(Color.rgb,frmHex(0xA06540),0.004)) { // leather
		// sample lightmap directly for custom color + tint.
		vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, vec4(0.7765,0.3608,0.2078,1)) * minecraft_sample_lightmap(Sampler2, UV2);
	} else {
		// sample lightmap directly for custom color.
		vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color) * minecraft_sample_lightmap(Sampler2, UV2);
    }
	
	texCoord0 = UV0;
    texCoord1 = UV1;
    texCoord2 = UV2;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
