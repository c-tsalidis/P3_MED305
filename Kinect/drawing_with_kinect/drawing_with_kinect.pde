import org.openkinect.processing.*;

Kinect2 kinect;
PImage img;

int minSilhouetteThreshold = 700;
int maxSilhouetteThreshold = 1500;

int minDrawingThreshold = minSilhouetteThreshold + 200;

float centerOfMass_x; 
float centerOfMass_y;

Star [] myStars = new Star[1200]; // the stars for the background

boolean isDrawing; // is the user inside the boundaries for drawing?

color currentDrawingColor;
color silhouetteColor = color(255);

PImage previousFrameDrawingImage;
PImage defaultCanvasImage;

ArrayList<Float> xSilhouetteCoordinates = new ArrayList<Float>();
ArrayList<Float> ySilhouetteCoordinates = new ArrayList<Float>();

String colorText;

color backgroundColor = color(#161616);

int numColors = 6;
int [] xColorPalette = new int[numColors];
int [] yColorPalette = new int[numColors];
color [] drawingColors = new color[numColors];
int colorPaletteHeight = 100;
int eraserWidth = 50;
int colorPalettesWidth;

// runs once
void setup() {
  background(backgroundColor);
  kinect = new Kinect2(this);
  // kinect.initVideo();
  kinect.initDepth();
  kinect.initDevice();
  fullScreen();
  // smooth();
  noStroke(); // get rid of strokes to whatever is being drawn
  defaultCanvasImage = get();
  previousFrameDrawingImage = createImage(width, height, RGB);
  createStars(); // only need to create the stars once, so do it in setup
  currentDrawingColor = color(255, 0, 0); // by default make the drawing color red
  createColors();
}

// runs every frame --> 60fps by default
void draw() {
  image(previousFrameDrawingImage, 0, 0);
  drawBackground();
  processDepth(); // process the depth values given by the kinect, and draw the silhoutte if user inside boundaries (between min and max thresholds)
  updateCenterOfMass(); // after processing the depth data, update the hands position
  checkColor(); // update the color depending on where the hands are at
  // showCenterOfMass(); // draw the center of mass
  showColorPalette();
  getCurrentDrawingImage(); // get the current image and save it, and replace the white silhouette with the background
  // createColorPallete();
  // fill(200);
  // text(centerOfMass_x + " | " +  centerOfMass_y, 20, height - 50);
  // PImage depthImage = kinect.getDepthImage();
  // image(depthImage, 0, 0);
}

void processDepth() {
  int [] depth = kinect.getRawDepth(); // get the depth values ranging from 0-4500 from the kinect
  int skip = 1;
  for (int x = 0; x < kinect.depthWidth; x += skip) {
    for (int y = 0; y < kinect.depthHeight; y += skip) {
      int offset = x + y * kinect.depthWidth;
      int d = depth[offset]; // get the depth value corresponding to the current pixel
      if (d > minSilhouetteThreshold && d < maxSilhouetteThreshold && d != 0) {
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

void createColors() {
  int colorCounter = 0; // keeping track of the first x coordinate of each color - for bounndaries
  colorPalettesWidth = ((width - eraserWidth) / drawingColors.length);
  drawingColors[0] = color(#FFFF00); // yellow
  drawingColors[1] = color(#FFA500); // orange
  drawingColors[2] = color(#FF0000); // red
  drawingColors[3] = color(#FF00FF); // purple
  drawingColors[4] = color(#0000FF); // blue
  drawingColors[5] = color(#00FF00); // green
  for(int i = 0; i < drawingColors.length; i++) {
    xColorPalette[i] = colorCounter;
    colorCounter += colorPalettesWidth;
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
  // use map
  float yProp = 3; // y proportion --> Value chosen because it's the one that worked best
  float xProp = yProp * (kinect.depthWidth / kinect.depthHeight); // x proportion --> // newWidth = newHeight * aspectRatio;
  xSilhouetteCoordinates.add(_x * xProp);
  ySilhouetteCoordinates.add(_y * yProp);
  if ( d < minDrawingThreshold) {
    fill(currentDrawingColor);
    ellipse(_x * xProp, _y * yProp, 5, 5); // create an ellipse for showing the hands (what the user is currently drawing)
  }
  else {
    fill(silhouetteColor);
    rect(_x * xProp, _y * yProp, 2, 2); // create a rectangle for showing the silhoutte of the user
  }
}

void checkColor() {
  stroke(255);
  // line(0, colorPaletteHeight, width, colorPaletteHeight);
  line(width - eraserWidth, 0, width - eraserWidth, height);
  noStroke();
  if (centerOfMass_y < colorPaletteHeight) updateCurrentDrawingColor(); // check if the user has the center of mass over a certain color in the color palette, and if so, update the color to the corresponding one
  if (centerOfMass_y > colorPaletteHeight && centerOfMass_x > (width - eraserWidth)) currentDrawingColor = backgroundColor; // activate the eraser if the user is selecting the eraser
  // feedback to the user of the current drawing color
  fill(currentDrawingColor);
  rect(20, height - 50, 100, 30);
}

void updateCenterOfMass() {
  // get the center position of the hands by calculating the average position of all the x and y coordinates
  int counter = 0;
  float xCounter = 0;
  float yCounter = 0;
  for (int i = 0; i < xSilhouetteCoordinates.size(); i++) {
    xCounter += xSilhouetteCoordinates.get(i);
    yCounter += ySilhouetteCoordinates.get(i);
    counter++;
  }
  if (counter > 25) { // only update the hand coordinates if the counter is higher than this number so as to avoid possible noises that interfere with the hand tracking
    centerOfMass_x = xCounter / counter;
    centerOfMass_y = yCounter / counter - 50;
  }
  xSilhouetteCoordinates.clear();
  ySilhouetteCoordinates.clear();
}

void showCenterOfMass() {
  fill(currentDrawingColor);
  ellipse(centerOfMass_x, centerOfMass_y, 30, 30);
}

void getCurrentDrawingImage() {
  PImage currentCanvas = get(); // get the current frame image
  previousFrameDrawingImage.loadPixels(); // load the previous image pixels
  for (int x = 0; x < currentCanvas.width; x++) {
    for (int y = 0; y < currentCanvas.height; y++) {
      int loc = x + y * currentCanvas.width;
      if (color(currentCanvas.pixels[loc]) == currentDrawingColor) previousFrameDrawingImage.pixels[loc] = currentDrawingColor;
    }
  }
  previousFrameDrawingImage.updatePixels(); // update the previous image pixels
}

void updateCurrentDrawingColor() {
  for(int i = 0; i < numColors; i++) {
    if(centerOfMass_x > xColorPalette[i] && centerOfMass_x < xColorPalette[i] + colorPalettesWidth) currentDrawingColor = drawingColors[i];
  }
}

void showColorPalette() {
  for(int i = 0; i < numColors; i++) {
    fill(drawingColors[i]);
    rect(xColorPalette[i], 0, colorPalettesWidth, colorPaletteHeight / 2);
  }
}

void keyPressed() {
  // if the user presses the 'UP' key on the keyboard, then replace every pixel of the canvas with the background color
  if (keyCode == UP) {
    previousFrameDrawingImage.loadPixels();
    for (int x = 0; x < previousFrameDrawingImage.width; x++) {
      for (int y = 0; y < previousFrameDrawingImage.height; y++) {
        int loc = x + y * previousFrameDrawingImage.width;
        previousFrameDrawingImage.pixels[loc] = backgroundColor;
      }
    }
    previousFrameDrawingImage.updatePixels();
  }
  // if the user presses the 'RIGHT' key on the keyboard, then save the current frame to the device as a .png file
  if (keyCode == RIGHT) saveFrame("Drawing-######.png");
}
