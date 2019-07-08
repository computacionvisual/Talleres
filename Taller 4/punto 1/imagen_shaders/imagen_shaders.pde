PShader edges;  
PShader blur;
PImage image;
PImage image2;
Boolean mouseClicked = false;
Long end = new Long(0), init = new Long(0);
void setup() {
  size(1280, 600, P2D);
  image = loadImage("tera.jpg");
  image2 = image;
  edges = loadShader("normal.glsl");
  blur = loadShader("edges.glsl");
  shader(edges);
  image(image, 0, 0, width/2, height);
  resetShader();
  image(image2, width/2 + 1, 0, width/2, height );
}

void draw() {
}
void mousePressed(){
  if(mouseClicked == false){
    mouseClicked = true;
    init = System.currentTimeMillis();
    resetShader();
    shader( blur );
    image( image2, width/2 + 1, 0, width/2, height );
    end = System.currentTimeMillis();
    System.out.println( end - init );
  }
}
