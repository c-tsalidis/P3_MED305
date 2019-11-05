import org.openkinect.processing.*;

Kinect2 kinect;
PImage img;

int minSilhouetteThreshold = 700;
int maxSilhouetteThreshold = 1500;

int minDrawingThreshold = 800;

int minHandThreshold = 700;
int maxHandThreshold = 1000;

float hand_x; 
float hand_y;

Star [] myStars = new Star[1200]; // the stars for the background
BrushShape [] brushes = new BrushShape[5000];

boolean isDrawing; // is the user inside the boundaries for drawing?

color currentDrawingColor;

PImage drawingImage;

ArrayList<Float> xHandCoordinates = new ArrayList<Float>();
ArrayList<Float> yHandCoordinates = new ArrayList<Float>();

String colorText;

void setup() {
  kinect = new Kinect2(this);
  kinect.initVideo();
  kinect.initDepth();
  kinect.initDevice();
  fullScreen();
  smooth();
  frameRate(120);
  noStroke(); // get rid of strokes to whatever is being drawn
  img = createImage(kinect.depthWidth, kinect.depthHeight, RGB);
  drawingImage = createImage(width, height, RGB);
  createStars(); // only need to create the stars once, so do it in setup
  createBrushes();
  currentDrawingColor = color(255, 0, 0, 100); // by default make the drawing color red with an alpha of 100
}

void draw() {
  image(drawingImage, 0, 0);
  drawBackground();
  processDepth(); // process the depth values given by the kinect, and draw the silhoutte if user inside boundaries (between min and max thresholds)
  updateHands(); // after processing the depth data, update the hands position
  updateColor(); // update the color depending on where the hands are at
  createDrawing(); // show the drawing of the player every frame
  drawHands(); // draw the hands
  // text of the color
  textSize(32);
  text(hex(currentDrawingColor), 20, height - 50);
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
      }
    }
  }
}

void createStars() {
  for (int i = 0; i < myStars.length; i++) {
    myStars[i] = new Star();
  }
}

void createBrushes() {
  for (int i = 0; i < brushes.length; i++) {
    brushes[i] = new BrushShape();
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
  if (_x * xProp < 150 && _y * yProp < 150) return; // there are some dots in tge upper left corner that are annoying, so just don't paint them. Alternatively, filter the noise
  rect(_x * xProp, _y * yProp, 5, 5); // create a rectangle for showing the silhoutte
  updateDrawingCoordinates(d, _x, _y, xProp, yProp);
  xHandCoordinates.add(_x * xProp);
  yHandCoordinates.add(_y * yProp);
  // if(d < maxHandThreshold) updateHands();
}

void createDrawing() {
  for (int i = 0; i < brushes.length; i++) {
    brushes[i].display();
  }
}

void updateDrawingCoordinates(int depth, float _x, float _y, float xProp, float yProp) {
  if (depth < minDrawingThreshold) {
    // int minDist = 3;
    isDrawing = true;
    brushes[0].x = _x * xProp;
    brushes[0].y = _y * yProp;
    // savedX[0] = _x * xProp;
    // savedY[0] = _y * yProp;
    for (int i = brushes.length - 1; i > 0; i--) {
      brushes[i].x = brushes[i-1].x;
      brushes[i].y = brushes[i-1].y;
    }
  } else isDrawing = false;
}

void updateColor() {
  if (hand_y < 150) {
    float value = map(hand_x, 0, width, 0, 255); // get the same RGB value equivalent to the position of the hand in the x axis
    currentDrawingColor = color(value, 0, value, 100);
  }
}

void updateHands() {
  // get the center position of the hands by calculating the average position of all the x and y coordinates
  // the best way for calculating the center position of the hands is by calculating the median instead of the average, but for now I'll do it with the average
  int counter = 0;
  float avgX = 0;
  float avgY = 0;
  for (int i = 0; i < xHandCoordinates.size(); i++) {
    float x = xHandCoordinates.get(i);
    float y = yHandCoordinates.get(i);
    avgX += x;
    avgY += y;
    counter++;
  }
  if (counter > 25) { // only update the hand coordinates if the counter is higher than this number so as to avoid possible noises that interfere with the hand tracking
    hand_x = avgX / counter;
    hand_y = avgY / counter;
  } else {
    hand_x = width;
    hand_y = height;
  }
  xHandCoordinates.clear();
  yHandCoordinates.clear();
}

void drawHands() {
  fill(currentDrawingColor, 255);
  ellipse(hand_x, hand_y, 30, 30);
}
