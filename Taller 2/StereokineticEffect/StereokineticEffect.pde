int circleAmount = 0;
int [] startFill = { 255, 255, 0 };
int [] secondFill  = { 0, 0, 255 };
float [] startCenterReference = new float[2];

ArrayList<Circle> circleList = new ArrayList<Circle>();

public void settings() {
  fullScreen();
}

void setup() {
  startCenterReference[0] = width / 2;
  startCenterReference[1] = height / 2;

  circleList.add(new Circle(270, startFill, 150, startCenterReference));
  circleList.add(new Circle(240, secondFill, 150, startCenterReference));
  circleList.add(new Circle(210, startFill, 150, startCenterReference));
  circleList.add(new Circle(180, secondFill, 150, startCenterReference));
  circleList.add(new Circle(150, startFill, 150, startCenterReference));

  int lastRadius = 150 - circleList.get(circleList.size() - 1).radius;
  circleList.add(new Circle(130, secondFill, 130, startCenterReference));
  circleList.add(new Circle(100, startFill, 100, startCenterReference));
  circleList.add(new Circle(70, secondFill, 70, startCenterReference));
  circleList.add(new Circle(40, startFill, 40, startCenterReference));
}


void draw() {
  background(255);

  push();
  fill(0, 0, 255);
  noStroke();
  float mainCenter = -centerBox(300);

  translate(width / 2, height / 2);
  circle(0, 0, 300);

  pop();

  for (Circle o : circleList) {
    o.run();
  }

  // Mini center
  // fill(255, 0, 0);
  // noStroke();
  // circle(width / 2, height / 2, 5);
}

public class Circle {
  int radius;
  int [] colorFill;
  int referenceRadius;
  float [] referenceCenter;

  float angle = 0;

  public Circle(int radius, int [] colorFill, int referenceRadius, float [] referenceCenter) {
    this.radius = radius;
    this.colorFill = colorFill;
    this.referenceRadius = referenceRadius;
    this.referenceCenter = referenceCenter;

    print(referenceCenter[0]);
    print(referenceCenter[1]);
  }

  void display() {
    push();
    float center = -centerBox(radius);
    noStroke();
    translate(referenceCenter[0], referenceCenter[1]);

    int r = referenceRadius - radius / 2;
    float x = r * cos(angle);
    float y = r * sin(angle);

    fill(colorFill[0], colorFill[1], colorFill[2]);
    circle(x, y, radius);
    pop();
  }

  void update() {
    angle = angle + PI / 80;
  }

  void run() {
    update();
    display();
  }

  float centerBox(int dimentions) {
    return dimentions / 2.0;
  }
}

float centerBox(int dimentions) {
  return dimentions / 2.0;
}