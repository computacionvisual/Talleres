PImage colorImage1, colorImage2, colorImage3, colorImage4, colorImage5;
PShape can;
float angle;
char directionX = ' ', directionY = ' ';

int image = 1;

void setup() {
  size(700, 700, P3D);  
  colorImage1 = loadImage("sofa.jpg");

  colorImage2 = loadImage("papel.jpg");

  colorImage3 = loadImage("grietas.jpg");

  colorImage4 = loadImage("alien.jpg");

  colorImage5 = loadImage("metal.jpg");
}

void draw() {    
  background(0);

  switch (image) {
  case 1 :
    can = createCan(150, 300, 32, colorImage1);
    break;	
  case 2 :
    can = createCan(150, 300, 32, colorImage2);
    break;	
  case 3 :
    can = createCan(150, 300, 32, colorImage3);
    break;
  case 4 :
    can = createCan(150, 300, 32, colorImage4);
    break;
  case 5 :
    can = createCan(150, 300, 32, colorImage5);
    break;
  }

  pointLight(255, 255, 255, width/2, height/2, 20); 

  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
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
}
