import org.openkinect.processing.*;

Kinect2 kinect;
PImage img;

int minSilhouetteThreshold = 500;
int maxSilhouetteThreshold = 1500;
int minDrawingThreshold = 200;
int maxDrawingThreshold = 200;

int redColorCounter = 0;
int greenColorCounter = 0;
int blueColorCounter = 0;

float hand_x; 
float hand_y;

boolean isDrawing;

int drawingIndexCounter;
int sizeCounter;
ArrayList<Float> xDrawings = new ArrayList<Float>();
ArrayList<Float> yDrawings = new ArrayList<Float>();

float xFinalDrawing;
float yFinalDrawing;

void setup() {
  kinect = new Kinect2(this);
  kinect.initVideo();
  kinect.initDepth();
  kinect.initDevice();
  fullScreen();
  smooth();
  frameRate(30);
  noStroke();
  img = createImage(kinect.depthWidth, kinect.depthHeight, RGB);
}

void draw() {
  background(0);
  processDepth();
  createDrawing();
}

void processDepth() {
  // img.loadPixels();
  int [] depth = kinect.getRawDepth(); // get the depth values ranging from 0-4500 from the kinect
  noStroke(); // get rid of strokes to whatever is being drawn
  int skip = 1;
  for (int x = 0; x < kinect.depthWidth; x += skip) {
    for (int y = 0; y < kinect.depthHeight; y += skip) {
      int offset = x + y * kinect.depthWidth;
      int d = depth[offset]; // get the depth value corresponding to the current pixel
      if (d > minSilhouetteThreshold && d < maxSilhouetteThreshold) {
        // img.pixels[offset] = color(255);
        drawSilhouette(x, y, d); // increase the size with rectangles
      }
      // else if the depth value is not inside the boundaries (thresholds), draw the current pixel black
      else {
        // img.pixels[offset] = color(0);
      }
    }
  }
}

void drawSilhouette(int _x, int _y, int d) {
  fill(255);
  float yProp = 3; // y proportion
  // newWidth = newHeight * aspectRatio;
  float xProp = yProp * kinect.depthWidth / kinect.depthHeight; // x proprotion
  noStroke();
  // rect(_x * xProp, _y * YProp, _width, _height);
  rect(_x * xProp, _y * yProp, 5, 5);
  // point(_x * xProp, _y * YProp);
  // ellipse(_x * xProp, _y * YProp, 2, 2);
  if (d < 700) {
    // println("Drawing!!!");
    // fill(color(random(0, 255), random(0, 255), random(0, 255), 100));
    // fill(redColorCounter, greenColorCounter, redColorCounter, 100);
    isDrawing = true;
    // fill(255, 0, 0, 100);
    // if (xDrawings.size() < 70000) {
      if(sizeCounter < 10000) {
      // xDrawings[drawingIndexCounter] = _x * xProp;
      // yDrawings[drawingIndexCounter] = _y * yProp;
      // int sameCounterX = 0;
      xDrawings.add(_x * xProp);
      yDrawings.add(_y * yProp);
      sizeCounter+=1;
       /*
      for(int i = 0; i < xDrawings.size(); i++) {
        if((_x * xProp) == xDrawings.get(i)) {
          sameCounterX++;
        }
        if(sameCounterX == 0) {
          xDrawings.add(_x * xProp);
          yDrawings.add(_y * yProp);
          sizeCounter+=10;
        }
        // println("Size counter:" + sizeCounter);
        drawingIndexCounter++;
        
      }
      */
    }
    else {
      xDrawings.clear();
      yDrawings.clear();
      sizeCounter = 0;
    }
    // ellipse(_x * xProp, _y * yProp, 5, 5);
  } else isDrawing = false;
}

void createDrawing() {
  for (int i = 0; i < xDrawings.size(); i++) {
    // println("Drawing all of em");
    fill(255, 0, 0, 100);
    ellipse(xDrawings.get(i), yDrawings.get(i), 25, 25);
  }
}
