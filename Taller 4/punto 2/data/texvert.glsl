uniform mat4 transform;
uniform mat4 texMatrix; // Data Sent by Sketch funciton texture()

attribute vec4 position; // Data Sent by Sketch funciton Vertex() with vec4 type
attribute vec4 color; // Data Sent by Sketch funciton Fill() Stroke()
attribute vec2 texCoord; // Data Sent by Sketch funciton Vertex()

varying vec4 vertColor; // Passing data among shaders by function stroke() fill()
varying vec4 vertTexCoord; // Passing data among shaders by function vertex()

void main() {
  gl_Position = transform * position;
  vertColor = color;
  // Bluish to image
  // vertColor = vec4(0, 0, 1, 1);
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}