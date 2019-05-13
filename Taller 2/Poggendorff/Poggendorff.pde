int LINE_OFFSET = 80;
int RECT_OFFSET = 160;
float rect_size = 0.5;

public void settings() {
  fullScreen();
}

void setup() {
}

void draw() {
  background(255);

  strokeWeight(4);
  stroke(0);
  
  for (int i = 0; i < width + ceil(width / 3); i += LINE_OFFSET) {
    push();
    
    rotate(PI * 15 / 180);
    line(i, -height / 2, i, height * 1.5);

    pop();
  }

  push();
    strokeWeight(0); 
    fill(255, 255, 0);

    for (int i = 0; i < floor(width / RECT_OFFSET); ++i) {
      rect(
        i * RECT_OFFSET,
        0,
        RECT_OFFSET * rect_size, 
        height);
    }
  pop();


  push(); 

  fill(0);
  textSize(32);
  text("Use UP and DOWN to increase or decrease the size of the yellow Rectangles", 100, 101);
  fill(255);
  text("Use UP and DOWN to increase or decrease the size of the yellow Rectangles", 101, 100);

  pop();
  
}

float PERCENTAGE_DELTA = 0.05;

void keyPressed() {

  if(keyCode == UP && rect_size <= 1) {
    rect_size += PERCENTAGE_DELTA;
  }

  if(keyCode == DOWN && rect_size >= 0) {
    rect_size -= PERCENTAGE_DELTA;
  } 
}