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
// BrushShape [] brushes = new BrushShape[5000];

boolean isDrawing; // is the user inside the boundaries for drawing?

color currentDrawingColor;
float currentDepth;

PImage previousFrameDrawingImage;
PImage defaultCanvasImage;

ArrayList<Float> xHandCoordinates = new ArrayList<Float>();
ArrayList<Float> yHandCoordinates = new ArrayList<Float>();

String colorText;

void setup() {
  background(#161616);
  kinect = new Kinect2(this);
  kinect.initDepth();
  kinect.initDevice();
  fullScreen();
  // smooth();
  noStroke(); // get rid of strokes to whatever is being drawn
  img = createImage(kinect.depthWidth, kinect.depthHeight, RGB);
  defaultCanvasImage = get();
  previousFrameDrawingImage = createImage(width, height, RGB);
  createStars(); // only need to create the stars once, so do it in setup
  currentDrawingColor = color(255, 0, 0); // by default make the drawing color red with an alpha of 100
}

void draw() {
  image(previousFrameDrawingImage, 0, 0);
  drawBackground();
  processDepth(); // process the depth values given by the kinect, and draw the silhoutte if user inside boundaries (between min and max thresholds)
  updateHands(); // after processing the depth data, update the hands position
  updateColor(); // update the color depending on where the hands are at
  // drawHands(); // draw the hands
  getCurrentDrawingImage();
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
        currentDepth = d;
      }
      // if(d > (minSilhouetteThreshold) && d < maxSilhouetteThreshold) drawBrush(x, y, d);
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
  // if (_x * xProp < 150 && _y * yProp < 150) return; // there are some dots in tge upper left corner that are annoying, so just don't paint them. Alternatively, filter the noise
  rect(_x * xProp, _y * yProp, 5, 5); // create a rectangle for showing the silhoutte
  xHandCoordinates.add(_x * xProp);
  yHandCoordinates.add(_y * yProp);
  if( d < minDrawingThreshold) {
    fill(currentDrawingColor);
    rect(_x * xProp, _y * yProp, 5, 5); // create a rectangle for showing the hands
  }
}

void updateColor() {
  if (hand_y < 150) {
    // float value = map(hand_x, 0, width, 0, 255); // get the same RGB value equivalent to the position of the hand in the x axis
    // float value = random(1, 255);
    // currentDrawingColor = color(value, 0, value);
    currentDrawingColor = color(random(1, 255),random(1, 255),random(1, 255));
    // text of the color
    // textSize(32);
    fill(currentDrawingColor);
    rect(20, height - 50, 30, 15);
    // text(hex(currentDrawingColor), 20, height - 50);
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
  fill(currentDrawingColor);
  ellipse(hand_x, hand_y, 30, 30);
}

void getCurrentDrawingImage() {
  PImage currentCanvas = get();
  previousFrameDrawingImage.loadPixels();
  for (int x = 0; x < currentCanvas.width; x++) {
    for (int y = 0; y < currentCanvas.height; y++) {
      int loc = x + y * currentCanvas.width;
      // if the current pixel is not the same color as 150 in grayscale, then it means it is part of the silhouette, so paint that pixel to the same as the current canvas one
      if (color(currentCanvas.pixels[loc]) != color(255) && color(currentCanvas.pixels[loc]) != currentDrawingColor) previousFrameDrawingImage.pixels[loc] = currentCanvas.pixels[loc];
      else if(color(currentCanvas.pixels[loc]) == currentDrawingColor) previousFrameDrawingImage.pixels[loc] = currentDrawingColor;
    }
  }
  previousFrameDrawingImage.updatePixels();
}

void keyPressed() {
  if (keyCode == UP) {
    previousFrameDrawingImage.loadPixels();
    for (int x = 0; x < previousFrameDrawingImage.width; x++) {
      for (int y = 0; y < previousFrameDrawingImage.height; y++) {
        int loc = x + y * previousFrameDrawingImage.width;
        previousFrameDrawingImage.pixels[loc] = #161616;
      }
    }
    previousFrameDrawingImage.updatePixels();
  }
}
