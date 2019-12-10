import org.openkinect.processing.*;

Kinect2 kinect;

// silhouette thresholds
int minSilhouetteThreshold = 1000;
int maxSilhouetteThreshold = 2000;

// drawing threshold
int minDrawingThreshold = 500;
int maxDrawingThreshold = 1500;

color currentDrawingColor;
color previousColor;
color silhouetteColor = color(255);

PImage backgroundImage;
color backgroundColor = color(#161616);

ArrayList<Float> xSilhouetteCoordinates = new ArrayList<Float>();
ArrayList<Float> ySilhouetteCoordinates = new ArrayList<Float>();

float centerOfMass_x; 
float centerOfMass_y;

boolean isMouseControlled = false;

int noiseFilter = 50;

Toolbar toolbar;
boolean isErasing = false, showToolbar = false;

// runs once
void setup() {
  background(backgroundColor);
  kinect = new Kinect2(this);
  kinect.initDepth();
  kinect.initDevice();
  fullScreen();
  smooth(8);
  noStroke(); // get rid of strokes to whatever is being drawn
  backgroundImage = createImage(width, height, RGB);
  currentDrawingColor = color(255, 0, 0); // by default make the drawing color red
  toolbar = new Toolbar();
}

// runs every frame --> 60fps by default
void draw() {
  colorMode(RGB);
  image(backgroundImage, 0, 0);
  processDepth(); // process the depth values given by the kinect, and draw the silhoutte if user inside boundaries (between min and max thresholds)
  updateBackgroundImage(); // get the current image and save it, and replace the white silhouette with the background
  toolbar.update();

  // we clear the array lists, as there is a new silhouette every frame, and we only to keep track of the latest silhouette coordinates, not of the entire history of silhouettes
  xSilhouetteCoordinates.clear();
  ySilhouetteCoordinates.clear();
  centerOfMass_x = width * 2;
  centerOfMass_y = height * 2;
}

void processDepth() {
  int [] depth = kinect.getRawDepth(); // get the depth values ranging from 0-4500 from the kinect
  depth = cleanDepthValues(depth); // for cleaning the values that are causing noise
  int skip = 1;
  for (int x = 0; x < kinect.depthWidth; x += skip) {
    for (int y = 0; y < kinect.depthHeight; y += skip) {
      int offset = x + y * kinect.depthWidth;
      int d = depth[offset]; // get the depth value corresponding to the current pixel
      // adjusting x and y to the correct ratio of the screen
      float _x = map(x, 0, kinect.depthWidth, 0, width);
      float _y = map(y, 0, kinect.depthHeight, 0, height);
      if (d > minSilhouetteThreshold && d < maxSilhouetteThreshold) drawSilhouette(_x, _y);
      else if (d > minDrawingThreshold && d < maxDrawingThreshold) makeDrawing(_x, _y);
    }
  }
}

void drawSilhouette(float x, float y) {
  xSilhouetteCoordinates.add(x);
  ySilhouetteCoordinates.add(y);
  fill(silhouetteColor);
  rect(x, y, 1, 1); // create a rectangle for showing the silhoutte of the user
}

void makeDrawing(float x, float y) {
  fill(currentDrawingColor);
  ellipse(x, y, 5, 5); // create an ellipse for showing the hands (what the user is currently drawing)
}

void updateBackgroundImage() {
  PImage currentCanvas = get(); // get the current frame image
  backgroundImage.loadPixels(); // load the background image pixels
  for (int x = 0; x < currentCanvas.width; x++) {
    for (int y = 0; y < currentCanvas.height; y++) {
      int loc = x + y * currentCanvas.width;
      // if the current canvas's pixel color is the same color as the currentDrawingColor (i.e --> red), then it will paint that pixel on the background image to red
      if (color(currentCanvas.pixels[loc]) == currentDrawingColor) backgroundImage.pixels[loc] = currentDrawingColor;
    }
  }
  backgroundImage.updatePixels(); // update the previous image pixels
}

int [] cleanDepthValues(int [] depth) {
  int amountValuesToCompare = 5;
  int skip = int(amountValuesToCompare / 2);
  for (int i = skip; i < (depth.length - skip); i++) {
    int [] a = new int[amountValuesToCompare];
    int median = 0, max = 0;
    a[0] = depth[i - 2];
    a[1] = depth[i - 1];
    a[2] = depth[i];
    a[3] = depth[i + 1];
    a[4] = depth[i + 2];
    for (int j = 0; j < a.length - 1; j++) {
      if(a[j] > max) {
        max = a[j];
      }
    }
    a = sort(a);
    median = a[skip];
   if(max > (median * 5)) {
     depth[i] = median;
   }
  }
  return depth;
}

void keyPressed() {
  // if the user presses the 'UP' key on the keyboard, then replace every pixel of the canvas with the background color
  if (keyCode == UP) {
    backgroundImage.loadPixels();
    for (int x = 0; x < backgroundImage.width; x++) {
      for (int y = 0; y < backgroundImage.height; y++) {
        int loc = x + y * backgroundImage.width;
        backgroundImage.pixels[loc] = backgroundColor;
      }
    }
    backgroundImage.updatePixels();
  }
  // if the user presses the 'RIGHT' key on the keyboard, then save the current frame to the device as a .png file
  if (keyCode == RIGHT) saveFrame("data/Drawing-######.png");
}
