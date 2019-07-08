import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;


float angle;
PImage image;
PImage image2;
int R = 0, G = 1, B = 2;
float lumaValue;
int pixel;
Boolean mouseClicked = false;
Double CPUTotal = new Double( 0 );
Double CPUTotalPorc = new Double( 0 );
int counter = 0;

void setup() {
  noStroke();
  size( 1280, 600 );
  image = loadImage( "tera.jpg" );
  image2 = image;
  image( image, 0, 0, width/2, height );
  image( image2, width/2 + 1, 0, width/2, height );
  rect( 10, 20, 300, 25 );
  rect( 10, 50, 350, 25 );
  fill( 0,0,0 );
  textSize(15);
}

void draw() {
  fill( 255,255,255 );
  //rect( 20, 20, 150, 40 );
  rect( 10, 50, 350, 25 );
  fill( 0,0,0 );
  CPUTotal += printUsage();
  CPUTotalPorc = CPUTotal/counter;
  text( "Uso del procesador: " + CPUTotalPorc.toString() + "%", 25, 68 );
}

private void greyScale( ){
  for( int i = 0; i < image.width; i++ ){
    for( int j = 0; j < image.height * 1; j++ ){
      pixel = image.get( i, j );
      lumaValue = (0.2126 * red(pixel)) + (0.7152 * green(pixel)) + (0.0722 * blue(pixel));
      image2.set( i, j, color( lumaValue, lumaValue, lumaValue ) );
    }
  }
}

void avgBlur(){
  Float avgBlur[][] = {
    {0.111111,0.111111,0.111111},
    {0.111111,0.111111,0.111111},
    {0.111111,0.111111,0.111111}
  };
  for( int i = 0; i < image2.width; i++ ){
    for( int j = 0; j < image2.height; j++ ){
      pixel = get( i, j );
      int redColor = (int)( avgBlur[0][0]* red(image2.get(i-1, j-1)) +
        avgBlur[0][1]*red(image2.get(i-1, j)) +
        avgBlur[0][2]*red(image2.get(i-1, j+1)) + 
        avgBlur[1][0]*red(image2.get(i, j-1)) + 
        avgBlur[1][1]*red(image2.get(i, j)) + 
        avgBlur[1][2]*red(image2.get(i, j+1)) + 
        avgBlur[2][0]*red(image2.get(i+1, j-1)) + 
        avgBlur[2][1]*red(image2.get(i+1, j)) + 
        avgBlur[2][2]*red(image2.get(i+1, j+1)));
      int greenColor = (int)( avgBlur[0][0]* green(image2.get(i-1, j-1)) +
        avgBlur[0][1]*green(image2.get(i-1, j)) +
        avgBlur[0][2]*green(image2.get(i-1, j+1)) + 
        avgBlur[1][0]*green(image2.get(i, j-1)) + 
        avgBlur[1][1]*green(image2.get(i, j)) + 
        avgBlur[1][2]*green(image2.get(i, j+1)) + 
        avgBlur[2][0]*green(image2.get(i+1, j-1)) + 
        avgBlur[2][1]*green(image2.get(i+1, j)) + 
        avgBlur[2][2]*green(image2.get(i+1, j+1)));
      int blueColor = (int)( avgBlur[0][0]* blue(image2.get(i-1, j-1)) +
        avgBlur[0][1]*blue(image2.get(i-1, j)) +
        avgBlur[0][2]*blue(image2.get(i-1, j+1)) + 
        avgBlur[1][0]*blue(image2.get(i, j-1)) + 
        avgBlur[1][1]*blue(image2.get(i, j)) + 
        avgBlur[1][2]*blue(image2.get(i, j+1)) + 
        avgBlur[2][0]*blue(image2.get(i+1, j-1)) + 
        avgBlur[2][1]*blue(image2.get(i+1, j)) + 
        avgBlur[2][2]*blue(image2.get(i+1, j+1)));

      image2.set( i, j, color( redColor, greenColor, blueColor ) );
    }
  }
}

void edges(){
  image.loadPixels();
  Float avgBlur[][] = {
    {-1.0,-1.0,-1.0},
    {-1.0,8.0,-1.0},
    {-1.0,-1.0,-1.0}
  };
  for( int i = 0; i < image.height ; i++ ){
    for( int j = 0; j < image.width ; j++ ){
      color redColor = (color)
      ( avgBlur[0][0]*red(image.get(j-1, i-1)) +
        avgBlur[0][1]*red(image.get(j-1, i)) +
        avgBlur[0][2]*red(image.get(j-1, i+1)) + 
        avgBlur[1][0]*red(image.get(j, i-1)) + 
        avgBlur[1][1]*red(image.get(j, i)) + 
        avgBlur[1][2]*red(image.get(j, i+1)) + 
        avgBlur[2][0]*red(image.get(j+1, i-1)) + 
        avgBlur[2][1]*red(image.get(j+1, i)) + 
        avgBlur[2][2]*red(image.get(j+1, i+1))
        );
      color greenColor = (color)
      ( avgBlur[0][0]*green(image.get(j-1, i-1)) +
        avgBlur[0][1]*green(image.get(j-1, i)) +
        avgBlur[0][2]*green(image.get(j-1, i+1)) + 
        avgBlur[1][0]*green(image.get(j, i-1)) + 
        avgBlur[1][1]*green(image.get(j, i)) + 
        avgBlur[1][2]*green(image.get(j, i+1)) + 
        avgBlur[2][0]*green(image.get(j+1, i-1)) + 
        avgBlur[2][1]*green(image.get(j+1, i)) + 
        avgBlur[2][2]*green(image.get(j+1, i+1))
        );
      color blueColor = (color)
      ( avgBlur[0][0]*blue(image.get(j-1, i-1)) +
        avgBlur[0][1]*blue(image.get(j-1, i)) +
        avgBlur[0][2]*blue(image.get(j-1, i+1)) + 
        avgBlur[1][0]*blue(image.get(j, i-1)) + 
        avgBlur[1][1]*blue(image.get(j, i)) + 
        avgBlur[1][2]*blue(image.get(j, i+1)) + 
        avgBlur[2][0]*blue(image.get(j+1, i-1)) + 
        avgBlur[2][1]*blue(image.get(j+1, i)) + 
        avgBlur[2][2]*blue(image.get(j+1, i+1))
        );

      image2.set( j, i, color(redColor, greenColor, blueColor) );
      //println(image2.pixels.length);
    }
  }
  //image2.updatePixels();
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
        
        //text( resultString, 47, 47 );
        //System.out.println(method.getName() + " = " + value);
    } // if
  } // for
  return result;
}

void mousePressed(){
   if( mouseClicked == false ){
     mouseClicked = true;
     long init = System.currentTimeMillis();
     avgBlur();
     image( image2, width/2 + 1, 0, width/2, height );
     long end = System.currentTimeMillis();
     text( "Tiempo: " + (end - init) + "ms", 25, 38 );
   }
   else{
     mouseClicked = false; 
   }
  
}

color getValue(int x,int y, float[][] matrix){
  
  color result;
  float r = 0.0;
  float g = 0.0;
  float b = 0.0;
  
  for(int wi = -1; wi <= 1; wi++){
   
    for(int hi = -1; hi <= 1; hi++){
      
      int new_x = x + wi, new_y = y + hi;
      color temp_color = get(new_x, new_y);
      
      
      float val_mat = matrix[wi + 1][hi + 1];
      r += (red(temp_color) * val_mat);
      g += (green(temp_color) * val_mat);
      b += (blue(temp_color) * val_mat);
      
    }
    
  }
  result = color(r,g,b);
  
  return result;
}
