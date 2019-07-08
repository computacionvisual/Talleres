import processing.video.*;
import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import processing.video.*;

int pixel;
Boolean greyKeyFlag = false, blurKeyFlag = false;
int counter = 0;
Boolean mouseClicked = false;
Double CPUTotal = new Double(0);
Double CPUTotalPorc = new Double(0);

Movie video;
float lumaValue;
String path = "video.mp4";
void setup(){
  size(1280, 720);
  video = new Movie(this, path);
  video.play();
}

void draw(){
  image(video, 0, 0, width, height);
  CPUTotal += printUsage();
  text("Frames por segundo: " + frameRate + " FPS", 50, 60);
}

void greyScale(){
  for( int i = 0; i < video.width; i++ ){
    for( int j = 0; j < video.height * 1; j++ ){
      pixel = video.get( i, j );
      lumaValue = (0.2126 * red(pixel)) + (0.7152 * green(pixel)) + (0.0722 * blue(pixel));
      video.set( i, j, color( lumaValue, lumaValue, lumaValue ) );
    }
  }
}

void avgBlur(){
  Float avgBlur[][] = {
    {0.111111,0.111111,0.111111},
    {0.111111,0.111111,0.111111},
    {0.111111,0.111111,0.111111}
  };
  for( int i = 1; i < video.width - 1; i++ ){
    for( int j = 1; j < video.height - 1; j++ ){
      pixel = get( i, j );
      int redColor = (int)( avgBlur[0][0]* red(video.get(i-1, j-1)) +
        avgBlur[0][1]*red(video.get(i-1, j)) +
        avgBlur[0][2]*red(video.get(i-1, j+1)) + 
        avgBlur[1][0]*red(video.get(i, j-1)) + 
        avgBlur[1][1]*red(video.get(i, j)) + 
        avgBlur[1][2]*red(video.get(i, j+1)) + 
        avgBlur[2][0]*red(video.get(i+1, j-1)) + 
        avgBlur[2][1]*red(video.get(i+1, j)) + 
        avgBlur[2][2]*red(video.get(i+1, j+1)));
      int greenColor = (int)( avgBlur[0][0]* green(video.get(i-1, j-1)) +
        avgBlur[0][1]*green(video.get(i-1, j)) +
        avgBlur[0][2]*green(video.get(i-1, j+1)) + 
        avgBlur[1][0]*green(video.get(i, j-1)) + 
        avgBlur[1][1]*green(video.get(i, j)) + 
        avgBlur[1][2]*green(video.get(i, j+1)) + 
        avgBlur[2][0]*green(video.get(i+1, j-1)) + 
        avgBlur[2][1]*green(video.get(i+1, j)) + 
        avgBlur[2][2]*green(video.get(i+1, j+1)));
      int blueColor = (int)( avgBlur[0][0]* blue(video.get(i-1, j-1)) +
        avgBlur[0][1]*blue(video.get(i-1, j)) +
        avgBlur[0][2]*blue(video.get(i-1, j+1)) + 
        avgBlur[1][0]*blue(video.get(i, j-1)) + 
        avgBlur[1][1]*blue(video.get(i, j)) + 
        avgBlur[1][2]*blue(video.get(i, j+1)) + 
        avgBlur[2][0]*blue(video.get(i+1, j-1)) + 
        avgBlur[2][1]*blue(video.get(i+1, j)) + 
        avgBlur[2][2]*blue(video.get(i+1, j+1)));
        if( redColor < 0 ){
          redColor = 0; 
        }
        if( greenColor < 0 ){
          redColor = 0; 
        }
        if( blueColor < 0 ){
          redColor = 0; 
        }
      video.set( i, j, color( redColor, greenColor, blueColor ) );
    }
  }
}

void movieEvent(Movie m){
  m.read();
  if( greyKeyFlag ){
    greyScale();
  }
  else if( blurKeyFlag ){
    avgBlur();
  }
}

void keyPressed(){
   if( key == 'g' && !greyKeyFlag){
     greyKeyFlag = true;
   }
   else if( key == 'b' && !blurKeyFlag){
     blurKeyFlag = true;
   }
   else{
     greyKeyFlag = false; 
     blurKeyFlag = false;
   }
}

private Double printUsage() {
  counter++;
  OperatingSystemMXBean operatingSystemMXBean = ManagementFactory.getOperatingSystemMXBean();
  Double result = new Double( 0 );
  String resultString;
  for (Method method : operatingSystemMXBean.getClass().getDeclaredMethods()) {
    method.setAccessible(true);
    if (method.getName().contains("getProcessCpuLoad")
        && Modifier.isPublic(method.getModifiers())) {
            Object value;
        try {
            value = method.invoke(operatingSystemMXBean);
        } catch (Exception e) {
            value = 0.0;
        } // try
        result = Double.valueOf( value.toString() ) * 100;
        try{
          resultString = result.toString().substring(0,5);
        }
        catch( Exception e ){
          resultString = result.toString().substring(0,2);
        }
        
        text( "Uso de CPU: " + resultString + "%", 50, 45 );
    } // if
  } // for
  return result;
}

//void edgeDetection(){
//    Float avgBlur[][] = {
//    {-0.1,-0.1,-0.1},
//    {-0.1,0.8,-0.1},
//    {-0.1,-0.1,-0.1}
//  };
//  for( int i = 1; i < video.width - 1; i++ ){
//    for( int j = 1; j < video.height - 1; j++ ){
//      int redColor = (int)( avgBlur[0][0]* red( video.get(i-1, j-1) ) +
//        avgBlur[0][1]*red(video.get(i-1, j)) +
//        avgBlur[0][2]*red(video.get(i-1, j+1)) + 
//        avgBlur[1][0]*red(video.get(i, j-1)) + 
//        avgBlur[1][1]*red(video.get(i, j)) + 
//        avgBlur[1][2]*red(video.get(i, j+1)) + 
//        avgBlur[2][0]*red(video.get(i+1, j-1)) + 
//        avgBlur[2][1]*red(video.get(i+1, j)) + 
//        avgBlur[2][2]*red(video.get(i+1, j+1)))%255;
//      int greenColor = (int)( avgBlur[0][0]* green(video.get(i-1, j-1)) +
//        avgBlur[0][1]*green(video.get(i-1, j)) +
//        avgBlur[0][2]*green(video.get(i-1, j+1)) + 
//        avgBlur[1][0]*green(video.get(i, j-1)) + 
//        avgBlur[1][1]*green(video.get(i, j)) + 
//        avgBlur[1][2]*green(video.get(i, j+1)) + 
//        avgBlur[2][0]*green(video.get(i+1, j-1)) + 
//        avgBlur[2][1]*green(video.get(i+1, j)) + 
//        avgBlur[2][2]*green(video.get(i+1, j+1)))%255;
//      int blueColor = (int)( avgBlur[0][0]* blue(video.get(i-1, j-1)) +
//        avgBlur[0][1]*blue(video.get(i-1, j)) +
//        avgBlur[0][2]*blue(video.get(i-1, j+1)) + 
//        avgBlur[1][0]*blue(video.get(i, j-1)) + 
//        avgBlur[1][1]*blue(video.get(i, j)) + 
//        avgBlur[1][2]*blue(video.get(i, j+1)) + 
//        avgBlur[2][0]*blue(video.get(i+1, j-1)) + 
//        avgBlur[2][1]*blue(video.get(i+1, j)) + 
//        avgBlur[2][2]*blue(video.get(i+1, j+1)))%255;

//      video.set( i, j, color( redColor, greenColor, blueColor ) );
//    }
//  }
  
//}
