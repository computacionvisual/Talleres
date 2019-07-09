import processing.video.*;

Boolean mouseClicked = false;
Boolean greyKeyFlag = false, blurKeyFlag = false, edgeKeyFlag = false;
PShader edges; 
PShader normal; 
PShader blur;
Long end = new Long(0), init = new Long(0);
Movie video;
float lumaValue;
String path = "video.mp4";

void setup(){
  size(1280, 720, P2D);
  normal = loadShader("normal.glsl");
  blur = loadShader("blur.glsl");
  edges = loadShader("edges.glsl");
  video = new Movie(this, path);
  video.play();
}

void draw() {
  if( greyKeyFlag ){
    //shader( blur );
  }
  else if( blurKeyFlag ){
    shader( blur );
  }
  else if( edgeKeyFlag ){
    shader( edges );
  }
  else{
    shader( normal );
  }
  image(video, 0, 0, width, height);
  println( frameRate );
}
void movieEvent(Movie m){
  m.read();
}

void keyPressed(){
   if( key == 'g' && !greyKeyFlag ){
     resetShader();
     greyKeyFlag = true;
   }
   else if( key == 'b' && !blurKeyFlag ){
     resetShader();
     blurKeyFlag = true;
   }
   else if( key == 'e' && !edgeKeyFlag ){
     resetShader();
     edgeKeyFlag = true;
   }
   else{
     edgeKeyFlag = false;
     greyKeyFlag = false; 
     blurKeyFlag = false;
   }
}
