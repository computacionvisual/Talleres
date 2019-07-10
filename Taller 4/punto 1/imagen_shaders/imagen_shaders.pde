Boolean greyKeyFlag = false, blurKeyFlag = false, edgeKeyFlag = false, focusKeyFlag = false;
PShader edges, normal, blur, greyScale, focus; 
PImage image;

Long end = new Long(0), init = new Long(0);
void setup() {
  size( 1280, 600, P2D );
  image = loadImage("hoja.jpg");
  normal = loadShader("normal.glsl");
  edges = loadShader("edges.glsl");
  blur = loadShader("blur.glsl");
  focus = loadShader("focus.glsl");
  greyScale = loadShader("greyScale.glsl");
  shader(normal);
  image( image, 0, 0 );
  image( image, width/2+1, 0 );
  resetShader();

}

void draw() {
}

void keyPressed(){
   if( key == 'g' && !greyKeyFlag ){
      init = System.currentTimeMillis();
      resetShader();
      shader( greyScale );
      image( image, width/2+1, 0 );
      end = System.currentTimeMillis();
      System.out.println( end - init );
   }
   else if( key == 'b' && !blurKeyFlag ){
      init = System.currentTimeMillis();
      resetShader();
      shader( blur );
      image( image, width/2+1, 0 );
      end = System.currentTimeMillis();
      System.out.println( end - init );
   }
   else if( key == 'e' && !edgeKeyFlag ){
      init = System.currentTimeMillis();
      resetShader();
      shader( edges );
      image( image, width/2+1, 0 );
      end = System.currentTimeMillis();
      System.out.println( end - init );
   }
   else if( key == 'f' && !edgeKeyFlag ){
      init = System.currentTimeMillis();
      resetShader();
      shader( focus );
      image( image, width/2+1, 0 );
      end = System.currentTimeMillis();
      System.out.println( end - init );
   }
   else{
     resetShader();
     shader( normal );
     image( image, width/2+1, 0 );
     edgeKeyFlag = false;
     greyKeyFlag = false; 
     blurKeyFlag = false;
     focusKeyFlag = false;
   }
}
