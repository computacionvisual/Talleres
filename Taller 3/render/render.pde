import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

// 1. Nub objects
Scene scene;
Node node;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;
boolean fillTriangle = true;
boolean showSubpixels = false;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

// 4. Window dimension
int dim = 10;

void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
}

void setup() {
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);

  // not really needed here but create a spinning task
  // just to illustrate some nub.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the node instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  node = new Node();
  node.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(node);
  triangleRaster();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the node system which has a dimension of 2^n
void triangleRaster() {
  // node.location converts points from world to node
  // here we convert v1 to illustrate the idea
  int [] box = triangleBox();
  Vector middle_point = new Vector(0, 0);

  int subpixels_count = 4;
  float subpixel_step = 1.0 / subpixels_count;
  float subpixel_half = subpixel_step / 2.0;

  if (fillTriangle) {
    int subpixels_valid;

    for (int i = box[0]; i < box[2]; ++i) {
      for (int j = box[1]; j < box[3]; ++j) {
        
        subpixels_valid = 0;
        int r_global = 0;
        int g_global = 0;
        int b_global = 0;

        for (float k = 0.0; k < 1; k = k + subpixel_step) {
          for (float l = 0.0; l < 1; l = l + subpixel_step) {
            middle_point.setX(i + k + subpixel_half);
            middle_point.setY(j + l + subpixel_half);

            Vector vaux1 = new Vector(node.location(v1).x(), node.location(v1).y());
            Vector vaux2 = new Vector(node.location(v2).x(), node.location(v2).y());
            Vector vaux3 = new Vector(node.location(v3).x(), node.location(v3).y());

            boolean inside = true;
            float area = edgeFunction(vaux1, vaux2, vaux3);
            float w0 = edgeFunction(vaux1, vaux2, middle_point);
            float w1 = edgeFunction(vaux2, vaux3, middle_point);
            float w2 = edgeFunction(vaux3, vaux1, middle_point);

            w0 /= area;
            w1 /= area;
            w2 /= area;

            inside &= w0 >= 0;
            inside &= w1 >= 0;
            inside &= w2 >= 0;

            int r = round(255 * w0);
            int g = round(255 * w1);
            int b = round(255 * w2);

            if (inside) {
              r_global += r;
              g_global += g;
              b_global += b;
              subpixels_valid++;
            }

            if (showSubpixels) {
              pushStyle();
              fill(0);
              strokeWeight(subpixel_half / 4.0);
              square(i + k, j + l, subpixel_step);
              popStyle();
            }

          }
        }

        if(subpixels_valid > 0) {
          pushStyle();
          noStroke();
          fill(floor(r_global / pow(subpixels_count, 2)), floor(g_global / pow(subpixels_count, 2)), floor(b_global / pow(subpixels_count, 2)));
          square(i, j, 1);
          popStyle();
        }

      }
    }
  }

  if (debug) {
    pushStyle();
    stroke(255, 255, 0, 125);
    point(round(node.location(v1).x()), round(node.location(v1).y()));
    popStyle();
  }
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

float edgeFunction(Vector a, Vector b, Vector p) {
  return ((p.x() - a.x()) * (b.y() - a.y()) - (p.y() - a.y()) * (b.x() - a.x()));
}

int [] triangleBox() {
  int minX = floor(min(
    node.location(v1).x(),
    node.location(v2).x(),
    node.location(v3).x()
  ));
  int minY = floor(min(
    node.location(v1).y(),
    node.location(v2).y(),
    node.location(v3).y()
  ));
  int maxX = ceil(max(
    node.location(v1).x(),
    node.location(v2).x(),
    node.location(v3).x()
  ));
  int maxY = ceil(max(
    node.location(v1).y(),
    node.location(v2).y(),
    node.location(v3).y()
  ));

  // int [] results = { floor(minX / pow(2, n)), floor(minY / pow(2, n)), ceil(maxX / pow(2, n)), ceil(maxY / pow(2, n)) };
  int [] results = { 
    minX, 
    minY,
    maxX, 
    maxY
  };

  return results;
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void keyPressed() {
  if (key == 'f')
    fillTriangle = !fillTriangle;
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == 's')
    showSubpixels = !showSubpixels;
  if (key == '+') {
    n = n < 8 ? n+1 : 2;
    node.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n > 2 ? n-1 : 8;
    node.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}
