int BASE_SIZE = 400;
int nSquares = 3;

int x_center;
int y_center;

public void settings() {
  fullScreen();
}

void setup() {
  x_center = (width - BASE_SIZE) / 2;
  y_center = (height - BASE_SIZE) / 2;
}

void draw() {
  int colorStep = floor(255 / nSquares);
  float sizeStep = BASE_SIZE / nSquares;
  
  for (int i = 0; i < nSquares; ++i) {

    push();

    noStroke();
    fill(i * colorStep);
    square(x_center + sizeStep / 2 * i, y_center + sizeStep / 2 * i, BASE_SIZE - sizeStep * i);
    
    pop();
  }

  push(); 

  fill(0);
  textSize(32);
  text("Use UP and DOWN to increase or decrease the amount of squares", 100, 101);
  fill(255);
  text("Use UP and DOWN to increase or decrease the amount of squares", 101, 100);

  pop();

}

void keyPressed() {

  if(keyCode == UP && nSquares < 254) {
    nSquares++;
  }

  if(keyCode == DOWN && nSquares > 1) {
    nSquares--;
  } 

}
