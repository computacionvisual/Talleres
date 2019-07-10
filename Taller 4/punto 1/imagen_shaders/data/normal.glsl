#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

varying vec4 vertColor;
varying vec4 vertTexCoord;
uniform sampler2D texture;
uniform vec2 texOffset;

void main(void) {
  // Grouping texcoord variables in order to make it work in the GMA 950. See post #13
  // in this thread:
  // http://www.idevgames.com/forums/thread-3467.html

  vec2 tc = vertTexCoord.st + vec2(0.0, 0.0);
  vec4 col = texture2D(texture, tc);
  vec4 sum = col; 
  
  gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;
}