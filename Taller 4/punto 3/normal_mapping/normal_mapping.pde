PImage normalImage1, colorImage1,
 normalImage2, colorImage2, 
 normalImage3, colorImage3,
 normalImage4, colorImage4,
 normalImage5, colorImage5 ;
PShape can;
float angleY, angleX;
char directionY = ' ', directionX = ' ';
int image = 1;

PShader texShader;

void setup() {
  size(700, 700, P3D);  
  normalImage1 = loadImage("sofaMap.jpg");
  colorImage1 = loadImage("sofa.jpg");

  normalImage2 = loadImage("papelMap.jpg");
  colorImage2 = loadImage("papel.jpg");

  normalImage3 = loadImage("grietasMap.jpg");
  colorImage3 = loadImage("grietas.jpg");
  
  normalImage4 = loadImage("alienMap.jpg");
  colorImage4 = loadImage("alien.jpg");
  
  normalImage5 = loadImage("metalMap.jpg");
  colorImage5 = loadImage("metal.jpg");

  texShader = loadShader("texfrag.glsl", "texvert.glsl");
}

void draw() {    
  background(0);

  switch (image) {
  case 1 :
    can = createCan(150, 300, 32, colorImage1);
    texShader.set("normalMap", normalImage1);
    break;	
  case 2 :
    can = createCan(150, 300, 32, colorImage2);
    texShader.set("normalMap", normalImage2);
    break;	
  case 3 :
    can = createCan(150, 300, 32, colorImage3);
    texShader.set("normalMap", normalImage3);
    break;
  case 4 :
    can = createCan(150, 300, 32, colorImage4);
    texShader.set("normalMap", normalImage4);
    break;
  case 5 :
    can = createCan(150, 300, 32, colorImage5);
    texShader.set("normalMap", normalImage5);
    break;
  }

  shader(texShader); 

  pointLight(255, 255, 255, width/2, height/2, 200); 

  translate(width/2, height/2);
  rotateY(angleY); 
  rotateX(angleX);
  shape(can);  
  if( directionY == 'r' )
    angleY += 0.01;
  else if( directionY == 'l' )
    angleY -= 0.01;
  if( directionX == 'u' )
    angleX += 0.01;
  else if( directionX == 'd' )
    angleX -= 0.01;
}

PShape createCan(float r, float h, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);
  }
  sh.endShape(); 
  return sh;
}

void keyPressed() {
  if (key == 'a')
    image = 1;
  else if (key == 's')
    image = 2;
  else if (key == 'd')
    image = 3;
  else if (key == 'f')
    image = 4;
  else if (key == 'g')
    image = 5;
  
  else if(keyCode == RIGHT)
    directionY = 'r';
  
  else if(keyCode == LEFT)
    directionY = 'l';
  
  else if(keyCode == UP)
    directionX = 'u';
  
  else if(keyCode == DOWN)
    directionX = 'd';
  
  else if(keyCode == BACKSPACE){
    directionY = ' ';
    directionX = ' ';
  }

}
