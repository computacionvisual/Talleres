Boolean greyKeyFlag = false, blurKeyFlag = false, edgeKeyFlag = false;
PShader edges; 
PShader normal; 
PShader blur;
PImage image;
PImage image2;
Boolean mouseClicked = false;
Long end = new Long(0), init = new Long(0);
void setup() {
  size(1280, 600, P2D);
  image = loadImage("hoja.jpg");
  image2 = image;
  normal = loadShader("normal.glsl");
  edges = loadShader("edges.glsl");
  blur = loadShader("blur.glsl");
  shader(normal);
  image(image, 0, 0, width/2, height);
  resetShader();
  image(image2, width/2 + 1, 0, width/2, height );
}

void draw() {
}

void keyPressed(){
   if( key == 'g' && !greyKeyFlag ){
      init = System.currentTimeMillis();
      resetShader();
      shader( blur );
      image( image2, width/2 + 1, 0, width/2, height );
      end = System.currentTimeMillis();
      System.out.println( end - init );
   }
   else if( key == 'b' && !blurKeyFlag ){
      init = System.currentTimeMillis();
      resetShader();
      shader( blur );
      image( image2, width/2 + 1, 0, width/2, height );
      end = System.currentTimeMillis();
      System.out.println( end - init );
   }
   else if( key == 'e' && !edgeKeyFlag ){
      init = System.currentTimeMillis();
      resetShader();
      shader( edges );
      image( image2, width/2 + 1, 0, width/2, height );
      end = System.currentTimeMillis();
      System.out.println( end - init );
   }
   else{
     edgeKeyFlag = false;
     greyKeyFlag = false; 
     blurKeyFlag = false;
   }
}
