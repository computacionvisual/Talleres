int LINE_STROKE = 2;
int LINE_SEPARATION = 10;
int OFFSET = 25;
int STARTING_SIZE = 200;

float x_center;
float y_center;

boolean sense = false;

public void settings() {
  fullScreen();
}

void setup() {

  x_center = width / 2 - STARTING_SIZE * 3 / 2;
  y_center = height / 2 - STARTING_SIZE * 3 / 2;

}

void draw() {
  background(255);

  // Base pattern (fractal)
  if(!mouseOver()) {

    for (int x = 0; x < 3; ++x) {
      sense = !sense;
      for (int y = 0; y < 3; ++y) {
      sense = !sense;
        
        for (int i = 0; i < 4; ++i) {
          squareCreate(
            x * STARTING_SIZE + OFFSET * i + x_center, 
            y * STARTING_SIZE + OFFSET * i + y_center, 
            STARTING_SIZE - 2 * i * OFFSET, 
            sense);
          sense = !sense;
        }

      }
    }

  }


  // Effect red squares
  push();
  
  stroke(255, 0, 0);
  strokeWeight(LINE_STROKE);
  noFill();

  for (int i = 0; i < 3; ++i) {
    square(
      x_center + STARTING_SIZE - OFFSET / 2 + OFFSET * i,
      y_center + STARTING_SIZE - OFFSET / 2 + OFFSET * i,
      STARTING_SIZE - (OFFSET / 2 + OFFSET * 2 * i)
    );
  }


  pop();
}

boolean mouseOver() {
  return (mouseX >= x_center && mouseX <= x_center + STARTING_SIZE * 3) && (mouseY >= y_center && mouseY <= y_center + STARTING_SIZE * 3);
}


void squareCreate(float x, float y, int size, boolean right) {
  float x_1 = x;
  float x_2 = x + size;
  float y_1 = y;
  float y_2 = y + size;

  push();

  noStroke();
  fill(255);
  square(x, y, size);

  stroke(0);
  strokeWeight(LINE_STROKE);
  float separation = LINE_SEPARATION; 

  for (int i = 1; i <= ceil(size / LINE_SEPARATION); ++i) {

    if(right) {
      // Lower lines
      line(x_1, y_2 - (separation * (i - 0.5)), x_2 - (separation * (i - 0.5)), y_1);  
      // Upper lines
      line(x_1 + (separation * (i - 0.5)), y_2, x_2, y_1 + (separation * (i - 0.5)));  
    } else {
      // Lower lines
      line(x_1, y_1 + (separation * (i - 0.5)), x_2 - (separation * (i - 0.5)), y_2);  
      // Upper lines
      line(x_1 + (separation * (i - 0.5)), y_1, x_2, y_2 - (separation * (i - 0.5)));  
    }
      
  }

  pop();
}