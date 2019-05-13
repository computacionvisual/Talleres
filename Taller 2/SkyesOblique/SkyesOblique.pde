int rowNumber = 16;
int squareSpace; 
ArrayList<Chess> tileList = new ArrayList<Chess>();
boolean horizontalState = true;

Chess tile; 

public void settings() {
  fullScreen();
}

void setup() {
  squareSpace = width / rowNumber;

  float [] center = { width / 2, height / 2 };
  tile = new Chess(center);

  for (int i = 1; i < height / squareSpace; ++i) {
    for (int j = 1; j < rowNumber; ++j) {
      float [] tileCenter = { j * squareSpace, i * squareSpace };
      tileList.add(new Chess(tileCenter));
    }
  }
}

void draw() {
  // Vertical lines
  strokeWeight(0);

  for (int i = 0; i < rowNumber; ++i) {
    push();

    if(i % 2 == 0) {
      fill(127, 127, 127);
    } else {
      fill(221, 232, 252);
    }

    rect(i * squareSpace, 0, squareSpace, height);
    pop();
  }


  for (int i = 0; i < floor(height / squareSpace); ++i) {
    push();

    if(i % 2 != 0) {
      fill(149, 179, 231);
      rect(0, i * squareSpace, width, squareSpace);
    }

    fill(255, 0, 0);
    pop();
  }


  for (Chess tileElement : tileList) {
    tileElement.display();
  }

  push();

  fill(0);
  textSize(32);
  text("Press BACKSPACE to toggle the effect", 100, 101);
  fill(255);
  text("Press BACKSPACE to toggle the effect", 101, 100);

  pop();
}

void keyPressed() {
  if (keyCode == BACKSPACE) {

    int count = 1;
    for (Chess tileElement : tileList) {
      if(++count % 2 == 0) tileElement.toggleOrientation();
    }

  }
}

public class Chess {
  float [] center;
  boolean isHorizontal = false;

  public Chess(float [] center) {
    this.center = center;
  }

  void display() {
    push();

    strokeWeight(0);
    translate(center[0], center[1]);

    if(isHorizontal) {
      rotate(PI / 4.0);
    } else {
      rotate(- PI / 4.0);
    }

    int size = 30;
    fill(255);
    square(-floor(size / 2), -floor(size / 2), size);

    fill(0);
    square(0, 0, size / 2);
    square(-floor(size / 2), -floor(size / 2), size / 2);

    pop();
  }

  void toggleOrientation() {
    isHorizontal = !isHorizontal;
  }

}
