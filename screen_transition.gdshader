shader_type canvas_item;
render_mode unshaded;

uniform float amount : hint_range(0.0, 1.0);
uniform sampler2D image : hint_albedo;


void fragment()
{
	if (amount == 0.0) {
		// Show nothing when input 'amount' is 0.
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
	else if (amount == 1.0) {
		// Show black when input 'amount' is 1, others may want to change this.
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	}
	else {
		// It is easiest to modify ths input 'amount' in a linear (0..1) way through gdscript.
		// But this doesn't create a visually nice scaling of the input image, so
		// instead we convert to log-space with some reasonable upper and lower bounds,
		// then convert back.
		float amount_scaled = exp(log(1.0/16.0) + (log(128.0) - log(1.0/16.0)) * amount);
		
		// Scale out from the center of the image, and (arbitrarily) use the red channel.
		float value = texture(image, ((UV - vec2(0.5,0.5)) * amount_scaled + vec2(0.5,0.5))).r;
		
		// Flip this and set to the output alpha channel to create a silhouette.
		COLOR.a = 1.0 - value;
	}
}