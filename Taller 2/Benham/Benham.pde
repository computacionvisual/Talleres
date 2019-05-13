float ANGLE_LIMIT = 2;
float ANGLE_DELTA = 0.05; 
float angle_variation = 1;

int angleShift = -1;

public void settings() {
  fullScreen();
}

void setup() {
}

float angle = 0;

void draw() {
  background(255);
  
  circle(width / 2, height / 2, 500);

  // Start of arcs

  push();
  strokeWeight(4);
 
  for (int i = 0; i < 12; ++i) {
    if(i % 3 == 0) angleShift++;
    arc(width / 2, height / 2, 460 - i * 30, 460 - i * 30, PI / 4 * angleShift + angle, PI / 4 * (angleShift + 1) + angle);
  }

  pop();

  // End of arcs

  push();
  fill(0);
  arc(width / 2, height / 2, 500, 500, angle + PI, 2*PI + angle, CLOSE);

  fill(0, 0, 255);
  circle(width / 2, height / 2, 10);
  pop();


  angle += angle_variation;


  push();

  fill(32);
  textSize(32);
  text("Use UP and DOWN arrows to modify wheel's speed", 100, 100);

  pop();
}

void keyPressed() {

  if(keyCode == UP && angle_variation <= ANGLE_LIMIT) {
    angle_variation += ANGLE_DELTA;
    print("DOWN DIRECTION " + angle_variation + "\n");
  }

  if(keyCode == DOWN && angle_variation >= -ANGLE_LIMIT) {
    angle_variation -= ANGLE_DELTA;
    print("UP DIRECTION " + angle_variation + "\n");
  } 

}