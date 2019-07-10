Boolean greyKeyFlag = false, blurKeyFlag = false, edgeKeyFlag = false, focusKeyFlag = false;
PShader edges, normal, blur, greyScale, focus; 
PImage image;

Long end = new Long(0), init = new Long(0);
void setup() {
  size(1366, 768, P2D);
  image = loadImage("fuente.jpg");
  normal = loadShader("normal.glsl");
  edges = loadShader("edges.glsl");
  blur = loadShader("blur.glsl");
  focus = loadShader("focus.glsl");
  greyScale = loadShader("greyScale.glsl");
  shader(normal);
  image(image, 0, 0, width, height);
  resetShader();

}

void draw() {
}

void keyPressed(){
   if( key == 'g' && !greyKeyFlag ){
      init = System.currentTimeMillis();
      resetShader();
      shader( greyScale );
      image( image, 0, 0, width, height );
      end = System.currentTimeMillis();
      System.out.println( end - init );
   }
   else if( key == 'b' && !blurKeyFlag ){
      init = System.currentTimeMillis();
      resetShader();
      shader( blur );
      image( image, 0, 0, width, height );
      end = System.currentTimeMillis();
      System.out.println( end - init );
   }
   else if( key == 'e' && !edgeKeyFlag ){
      init = System.currentTimeMillis();
      resetShader();
      shader( edges );
      image( image, 0, 0, width, height );
      end = System.currentTimeMillis();
      System.out.println( end - init );
   }
   else if( key == 'f' && !focusKeyFlag ){
      init = System.currentTimeMillis();
      resetShader();
      shader( focus );
      image( image, 0, 0, width, height );
      end = System.currentTimeMillis();
      System.out.println( end - init );
   }
   else{
     resetShader();
     shader( normal );
     image( image, 0, 0, width, height );
     edgeKeyFlag = false;
     greyKeyFlag = false; 
     blurKeyFlag = false;
     focusKeyFlag = false;
   }
}
