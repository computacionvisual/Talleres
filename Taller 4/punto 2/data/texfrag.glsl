#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture; // Data sent from Sketch by function texture()

varying vec4 vertColor;  // Passing data among shaders by function stroke() fill() [Interpolated]
varying vec4 vertTexCoord; // Passing data among shaders by function vertex() [Interpolated]

void main() {
  gl_FragColor =  texture2D(texture, vertTexCoord.st) * vertColor ;

  // Pixel image
  /* int si = int(vertTexCoord.s * 1000);
  int sj = int(vertTexCoord.t * 1000);
  gl_FragColor = texture2D(texture, vec2(float(si) / 1000, float(sj) / 1000)) * vertColor; */
}