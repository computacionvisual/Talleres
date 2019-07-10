import processing.video.*;

int pixel;
Boolean greyKeyFlag = false, blurKeyFlag = false, edgeKeyFlag = false, focusKeyFlag = false;
int counter = 0;
Boolean mouseClicked = false;
Double CPUTotal = new Double(0);
Double CPUTotalPorc = new Double(0);


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

Movie video, secVideo;
float lumaValue;
String path = "video.mp4";
void setup(){
  size(1280, 720);
  video = new Movie(this, path);
  video.play();
}

void draw(){
  if (video.available()) {
    video.read();
  }
  if( greyKeyFlag )
    image(greyScale( video ), 0, 0);
  else if( blurKeyFlag )
    image( applyMask( video, avgBlur, 3 ), 0, 0);
  else if( edgeKeyFlag )
    image( applyMask( video, edges, 3 ), 0, 0);
  else if( focusKeyFlag )
    image( applyMask( video, focus, 5 ), 0, 0);
  else
    image(video, 0, 0);
  text("Frames por segundo: " + frameRate + " FPS", 50, 60);
}

PImage greyScale( Movie video ){
  Movie rVideo = video;
  for( int i = 0; i < video.width; i++ ){
    for( int j = 0; j < video.height * 1; j++ ){
      pixel = video.get( i, j );
      lumaValue = (0.2126 * red(pixel)) + (0.7152 * green(pixel)) + (0.0722 * blue(pixel));
      rVideo.set( i, j, color( lumaValue, lumaValue, lumaValue ) );
    }
  }
  return rVideo;
}

PImage applyMask( Movie video, float[][] mask, int matrixSize ){
  PImage rVideo = createImage(video.width, video.height, RGB);
  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++ ) {
      color c = convolution(x, y, mask, matrixSize, video);
      rVideo.set(x, y, c);
    }
  }
  return rVideo;
}

void keyPressed(){
   if( key == 'g' && !greyKeyFlag ){
     greyKeyFlag = true;
   }
   else if( key == 'b' && !blurKeyFlag ){
     blurKeyFlag = true;
   }
   else if( key == 'e' && !edgeKeyFlag ){
     edgeKeyFlag = true;
   }
   else if( key == 'f' && !focusKeyFlag ){
     focusKeyFlag = true;
   }
   else{
     focusKeyFlag = false;
     edgeKeyFlag = false;
     greyKeyFlag = false; 
     blurKeyFlag = false;
   }
}

color convolution(int x, int y, float[][] matrix, int matrixsize, Movie img)
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
