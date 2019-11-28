import org.openkinect.processing.*;

Kinect2 kinect;

// silhouette thresholds
int minSilhouetteThreshold = 700;
int maxSilhouetteThreshold = 1500;

// drawing threshold
int minDrawingThreshold = 25;
int maxDrawingThreshold = 900;

color currentDrawingColor;
color previousColor;
color silhouetteColor = color(255);

PImage backgroundImage;
color backgroundColor = color(#161616);

ArrayList<Float> xSilhouetteCoordinates = new ArrayList<Float>();
ArrayList<Float> ySilhouetteCoordinates = new ArrayList<Float>();

IntList closestDepths = new IntList();

ArrayList<Float> xClosestDepthCoord = new ArrayList<Float>();
ArrayList<Float> yClosestDepthCoord = new ArrayList<Float>();

float centerOfMass_x; 
float centerOfMass_y;

int numColors = 6;
int [] xColorPalette = new int[numColors];
int [] yColorPalette = new int[numColors];
color [] drawingColors = new color[numColors];
int colorPaletteHeight = 100;
int eraserWidth = 50;
int colorPalettesWidth;

boolean isMouseControlled = false;

int noiseFilter = 50;

Toolbar toolbar;

String feedback = "feedback";

boolean isErasing = false, isPipetting = false, showToolbar = false;

float pipetX, pipetY;

color pipetColor;

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
  currentDrawingColor = color(0, 255, 0); // by default make the drawing color red
  previousColor = currentDrawingColor;
  toolbar = new Toolbar();
}

// runs every frame --> 60fps by default
void draw() {
  colorMode(RGB);
  image(backgroundImage, 0, 0);
  processDepth(); // process the depth values given by the kinect, and draw the silhoutte if user inside boundaries (between min and max thresholds)
  showCenterOfMass(); // draw the center of mass - for testing purposes 
  updateBackgroundImage(); // get the current image and save it, and replace the white silhouette with the background
  /*
  calculatePipetCenterOfMass();
  if(isPipetting) {
    pipetColor = color(get((int)pipetX, (int)pipetY));
    previousColor = currentDrawingColor;
    currentDrawingColor = pipetColor;// pixel color corresponding to x and y
  }
  float r  = red(currentDrawingColor);
  float g  = green(currentDrawingColor);
  float b  = blue(currentDrawingColor);
  // println(r,g,b);
  // else currentDrawingColor = previousColor;
  */
  toolbar.update();
  // ellipse(pipetX, pipetY, 30, 30); // show pipette center of mass
  // we clear the array lists, as there is a new silhouette every frame, and we only to keep track of the latest silhouette coordinates, not of the entire history of silhouettes
  xSilhouetteCoordinates.clear();
  ySilhouetteCoordinates.clear();
  closestDepths.clear();
  xClosestDepthCoord.clear();
  yClosestDepthCoord.clear();
  centerOfMass_x = width * 2;
  centerOfMass_y = height * 2;
  
  // feedback for tool slected
  fill(255);
  rect(50, height - 50, 100, 50);
  fill(0);
  // textAlign(CENTER);
  text(feedback, 50, height - 50, 50, 25);
}

void processDepth() {
  int [] depth = kinect.getRawDepth(); // get the depth values ranging from 0-4500 from the kinect
  int skip = 1;
  int closestCounter = 0; // for counting the closest depth values to the kinect
  for (int x = 0; x < kinect.depthWidth; x += skip) {
    for (int y = 0; y < kinect.depthHeight; y += skip) {
      int offset = x + y * kinect.depthWidth;
      int d = depth[offset]; // get the depth value corresponding to the current pixel
      // adjusting x and y to the correct ratio of the screen
      float _x = map(x, 0, kinect.depthWidth, 0, width);
      float _y = map(y, 0, kinect.depthHeight, 0, height);
      if (d > minSilhouetteThreshold && d < maxSilhouetteThreshold) drawSilhouette(_x, _y);
      else if (d > minDrawingThreshold && d < maxDrawingThreshold) {
        makeDrawing(_x, _y);
        if(closestCounter > noiseFilter) {
          closestDepths.append(d);
          xClosestDepthCoord.add(_x);
          yClosestDepthCoord.add(_y);
        }
        closestCounter++;
      }
    }
  }
}

void drawSilhouette(float x, float y) {
  xSilhouetteCoordinates.add(x);
  ySilhouetteCoordinates.add(y);
  fill(silhouetteColor);
  rect(x, y, 2, 2); // create a rectangle for showing the silhoutte of the user
}

void makeDrawing(float x, float y) {
  if(isPipetting) return;
  fill(currentDrawingColor);
  ellipse(x, y, 5, 5); // create an ellipse for showing the hands (what the user is currently drawing)
}

void showCenterOfMass() {
  fill(currentDrawingColor);
  ellipse(centerOfMass_x, centerOfMass_y, 30, 30);
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

void updateCurrentDrawingColor() {
  for(int i = 0; i < numColors; i++) {
    if(centerOfMass_x > xColorPalette[i] && centerOfMass_x < xColorPalette[i] + colorPalettesWidth) currentDrawingColor = drawingColors[i];
  }
}


void calculatePipetCenterOfMass() {
  if(!isPipetting) return;
  if (isMouseControlled) { 
    centerOfMass_x = mouseX;
    centerOfMass_y = mouseY;
    return;
  }
  int min;
  if(closestDepths.size() > 0) min = closestDepths.max();
  else min = 0;
  for(int i = 0; i < closestDepths.size(); i++) {
    if(closestDepths.get(i) < min) {
      min = closestDepths.get(i);
      pipetX = xClosestDepthCoord.get(i);
      pipetY = yClosestDepthCoord.get(i);
    }
  }
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
  if (keyCode == RIGHT) saveFrame("Drawing-######.png");
}
