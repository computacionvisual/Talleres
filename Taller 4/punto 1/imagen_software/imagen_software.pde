Boolean greyKeyFlag = false, blurKeyFlag = false, edgeKeyFlag = false;
PImage image, image2;
float lumaValue;
int pixel;

void setup() {
  noStroke();
  size( 1280, 600 );
  image = loadImage( "hoja.jpg" );
  image2 = image;
  image( image, 0, 0 );
  image( image2, width/2, 0 );
  rect( 10, 20, 200, 25 );
  fill( 0,0,0 );
  textSize(15);
}

void draw() {
}

private void greyScale( ){
  for( int i = 0; i < image.width; i++ ){
    for( int j = 0; j < image.height * 1; j++ ){
      pixel = image.get( i, j );
      lumaValue = 
        (0.2126 * red(pixel)) + 
        (0.7152 * green(pixel)) + 
        (0.0722 * blue(pixel));
      image2.set( i, j, color( lumaValue, lumaValue, lumaValue ) );
    }
  }
}

void avgBlur( PImage image ){

  float avgBlur[][] = {
    {0.111111,0.111111,0.111111},
    {0.111111,0.111111,0.111111},
    {0.111111,0.111111,0.111111}
  };
  

  loadPixels();
  for (int x = width/2; x < width; x++) {
    for (int y = 0; y < height; y++ ) {
      color c = convolution(x, y, avgBlur, 3, image);
      int loc = x + y * width;
      try{
      pixels[loc] = c;
      }
      catch(Exception e){
        println( "here", width );
        println( x, y );
        throw e;
      }
    }
  }
  updatePixels();
}

void edges( PImage image ){
  float edges[][] = {
    {-1.0,-1.0,-1.0},
    {-1.0,8.0,-1.0},
    {-1.0,-1.0,-1.0}
  };
  

  loadPixels();
  for (int x = width/2; x < width; x++) {
    for (int y = 0; y < height; y++ ) {
      color c = convolution(x, y, edges, 3, image);
      int loc = x + y * width;
      try{
      pixels[loc] = c;
      }
      catch(Exception e){
        println( "here", width );
        println( x, y );
        throw e;
      }
    }
  }
  updatePixels();
}

void keyPressed(){
   if( key == 'g' && !greyKeyFlag ){
     long init = System.currentTimeMillis();
     greyScale( );
     image( image2, width/2, 0 );
     long end = System.currentTimeMillis();
     fill( 255,255,255 );
     rect( 10, 20, 300, 25 );
     fill( 0,0,0 );
     text( "Tiempo: " + (end - init) + "ms", 25, 38 );
   }
   else if( key == 'b' && !blurKeyFlag ){
     long init = System.currentTimeMillis();
     avgBlur( image );
     long end = System.currentTimeMillis();
     fill( 255,255,255 );
     rect( 10, 20, 300, 25 );
     fill( 0,0,0 );
     text( "Tiempo: " + (end - init) + "ms", 25, 38 );
   }
   else if( key == 'e' && !edgeKeyFlag ){
     long init = System.currentTimeMillis();
     edges( image );
     long end = System.currentTimeMillis();
     fill( 255,255,255 );
     rect( 10, 20, 300, 25 );
     fill( 0,0,0 );
     text( "Tiempo: " + (end - init) + "ms", 25, 38 );
   }
   else{
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
