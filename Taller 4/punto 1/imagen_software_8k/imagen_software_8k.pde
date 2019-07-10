Boolean greyKeyFlag = false, blurKeyFlag = false, edgeKeyFlag = false, focusKeyFlag = false;
PImage image;
float lumaValue;
int pixel;

float avgBlur[][] = {
    {0.111111,0.111111,0.111111},
    {0.111111,0.111111,0.111111},
    {0.111111,0.111111,0.111111}
  },
  edges[][] = {
    {-1.0,-1.0,-1.0},
    {-1.0,8.0,-1.0},
    {-1.0,-1.0,-1.0}
  },
  focus[][] = {
    {0,0,-1,0,0},
    {0,0,-1,0,0},
    {-1,-1,9,-1,-1},
    {0,0,-1,0,0},
    {0,0,-1,0,0},
  };

void setup() {
  noStroke();
  fullScreen();
  image = loadImage( "fuente.jpg" );
  image( image, 0, 0, width, height );
  fill( 0,0,0 );
  textSize(15);
}

void draw() {
}

PImage greyScale( PImage image ){
  PImage rImage = createImage(image.width, image.height, RGB);
  for( int i = 0; i < image.width; i++ ){
    for( int j = 0; j < image.height * 1; j++ ){
      pixel = image.get( i, j );
      lumaValue = 
        (0.2126 * red(pixel)) + 
        (0.7152 * green(pixel)) + 
        (0.0722 * blue(pixel));
      rImage.set( i, j, color( lumaValue, lumaValue, lumaValue ) );
    }
  }
  return rImage;
}

PImage applyMask( PImage image, float[][] mask, int matrixSize ){
  PImage rImage = createImage(image.width, image.height, RGB);
  for (int x = 0; x < image.width; x++) {
    for (int y = 0; y < image.height; y++ ) {
      color c = convolution(x, y, mask, matrixSize, image);
      rImage.set(x, y, c);
    }
  }
  return rImage;
}

void keyPressed(){
   if( key == 'g' && !greyKeyFlag ){
     long init = System.currentTimeMillis();
     image( greyScale( image ), 0, 0, width, height );
     long end = System.currentTimeMillis();
     fill( 255,255,255 );
     rect( 10, 20, 200, 25 );
     fill( 0,0,0 );
     text( "Tiempo: " + (end - init) + "ms", 25, 38 );
   }
   else if( key == 'b' && !blurKeyFlag ){
     long init = System.currentTimeMillis();
     image( applyMask( image, avgBlur, 3 ), 0, 0, width, height );
     long end = System.currentTimeMillis();
     fill( 255,255,255 );
     rect( 10, 20, 200, 25 );
     fill( 0,0,0 );
     text( "Tiempo: " + (end - init) + "ms", 25, 38 );
   }
   else if( key == 'e' && !edgeKeyFlag ){
     long init = System.currentTimeMillis();
     image( applyMask( image, edges, 3 ), 0, 0, width, height );
     long end = System.currentTimeMillis();
     fill( 255,255,255 );
     rect( 10, 20, 200, 25 );
     fill( 0,0,0 );
     text( "Tiempo: " + (end - init) + "ms", 25, 38 );
   }
   else if( key == 'f' && !focusKeyFlag ){
     long init = System.currentTimeMillis();
     image( applyMask( image, focus, 5 ), 0, 0, width, height );
     long end = System.currentTimeMillis();
     fill( 255,255,255 );
     rect( 10, 20, 200, 25 );
     fill( 0,0,0 );
     text( "Tiempo: " + (end - init) + "ms", 25, 38 );
   }
   else{
     image( image, 0, 0, 1366, 768 );
     focusKeyFlag = false;
     edgeKeyFlag = false;
     greyKeyFlag = false; 
     blurKeyFlag = false;
   }
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}
