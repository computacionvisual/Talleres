uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightAmbient[8];
uniform vec3 lightSpecular[8];

attribute vec4 position;
attribute vec4 color;
attribute vec4 ambient;
attribute vec4 specular;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec4 vertColor;


void main() {
  gl_Position = transform * position;
  vec3 ecPosition = vec3(modelview * position);  
  vec3 ecNormal = normalize(normalMatrix * normal);
  vec3 cameraDirection = normalize(0 - ecPosition);
  vec3 lightDirection = lightPosition.xyz - ecPosition;

  float lightAmbient = 0.1;
  float lightSpecular = pow(max(0.0, pow(dot(lightDirection, cameraDirection), 4)), 8);
  float lightDiffuse = 0.1;


  vec4 vertColorA = vec4( lightAmbient, lightAmbient, lightAmbient, 1 );
  vec4 vertColorSP = vec4( lightSpecular, lightSpecular, lightSpecular, 1 );
  vec4 vertColorD = vec4( lightDiffuse, lightDiffuse, lightDiffuse, 1 );

  vertColor = (vertColorA + vertColorSP + vertColorD) * color;
}
