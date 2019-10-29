import org.openkinect.processing.*;

Kinect2 kinect;
PImage img;

int minSilhouetteThreshold = 700;
int maxSilhouetteThreshold = 1500;

float hand_x; 
float hand_y;

int numCircles = 5000;
float [] x; // keeping track of all the x coordinates of all the circles
float [] y; // keeping track of all the y coordinates of all the circles

Star [] myStars = new Star [1200];

boolean isDrawing; // is the user inside the boundaries for drawing?

void setup() {
  kinect = new Kinect2(this);
  kinect.initVideo();
  kinect.initDepth();
  kinect.initDevice();
  fullScreen();
  smooth();
  // frameRate(30);
  noStroke(); // get rid of strokes to whatever is being drawn
  img = createImage(kinect.depthWidth, kinect.depthHeight, RGB);
  x = new float [numCircles];
  y = new float [numCircles];
  createStars();
}

void draw() {
  // background(0);
  drawBackground();
  processDepth(); // process the depth values given by the kinect, and draw the silhoutte if user inside boundaries (between min and max thresholds)
  createDrawing(); // show the drawing of the player every frame
  /*
  for (int i = 0; i < numCircles; i++) {
    println(x[i], y[i]);
  }
  */
}

void processDepth() {
  int [] depth = kinect.getRawDepth(); // get the depth values ranging from 0-4500 from the kinect
  int skip = 1;
  for (int x = 0; x < kinect.depthWidth; x += skip) {
    for (int y = 0; y < kinect.depthHeight; y += skip) {
      int offset = x + y * kinect.depthWidth;
      int d = depth[offset]; // get the depth value corresponding to the current pixel
      if (d > minSilhouetteThreshold && d < maxSilhouetteThreshold) {
        drawSilhouette(x, y, d); 
        // updateDrawingCoordinates(d);
      }
    }
  }
}

void createStars() {
  for (int i = 0; i < myStars.length; i++) {
    myStars[i] = new Star();
  }
}

void drawBackground() {
  translate(width/2, height/2);
  background(#161616); 
  for (int i = 0; i < myStars.length; i++) {
    myStars[i].show();
    myStars[i].pulsate();
  }
  translate(-width/2, -height/2);
}

void drawSilhouette(int _x, int _y, int d) {
  fill(255);
  float yProp = 3; // y proportion
  // newWidth = newHeight * aspectRatio;
  float xProp = yProp * (kinect.depthWidth / kinect.depthHeight); // x proportion
  rect(_x * xProp, _y * yProp, 5, 5); // create a rectangle for showing the silhoutte
  updateDrawingCoordinates(d, _x, _y, xProp, yProp);
}

void createDrawing() {
  for (int i = 0; i < numCircles; i++) {
    fill(255, 0, 0, 100);
    // ellipse(xDrawings.get(i), yDrawings.get(i), 25, 25);
    ellipse(x[i], y[i], 25, 25);
  }
}

void updateDrawingCoordinates(int depth, float _x, float _y, float xProp, float yProp) {
  if (depth < (minSilhouetteThreshold + 100)) {
    // int minDist = 3;
    isDrawing = true;
    x[0] = _x * xProp;
    y[0] = _y * yProp;
      for(int i = numCircles - 1; i > 0; i--) {
        // if(abs(x[i] - x[i-1]) >= minDist && abs(y[i] - y[i-1]) >= minDist) {
          x[i] = x[i-1];
          y[i] = y[i-1];
        // }
      }
  } else isDrawing = false;
}
