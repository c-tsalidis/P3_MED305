import org.openkinect.processing.*;

Kinect2 kinect;

// silhouette thresholds
int minSilhouetteThreshold = 700;
int maxSilhouetteThreshold = 1500;

// drawing threshold
int minDrawingThreshold = 100;
int maxDrawingThreshold = 900;

color currentDrawingColor;
color previousColor;
color silhouetteColor = color(255);

PImage backgroundImage;
color backgroundColor = color(#161616);

ArrayList<Float> xSilhouetteCoordinates = new ArrayList<Float>();
ArrayList<Float> ySilhouetteCoordinates = new ArrayList<Float>();

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

Toolbar toolbar;

boolean isErasing = false, isPipetting = false, showToolbar = false;

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
  previousColor = currentDrawingColor;
  toolbar = new Toolbar();
  //createColors();
}

// runs every frame --> 60fps by default
void draw() {
  image(backgroundImage, 0, 0);
  processDepth(); // process the depth values given by the kinect, and draw the silhoutte if user inside boundaries (between min and max thresholds)
  // updateCenterOfMass(); // after processing the depth data, update the hands position
  showCenterOfMass(); // draw the center of mass - for testing purposes 
  // checkColor(); // update the color depending on where the hands are at
  // showColorPalette();
  updateBackgroundImage(); // get the current image and save it, and replace the white silhouette with the background
  toolbar.update();
  // we clear the array lists, as there is a new silhouette every frame, and we only to keep track of the latest silhouette coordinates, not of the entire history of silhouettes
  xSilhouetteCoordinates.clear();
  ySilhouetteCoordinates.clear();
}

void processDepth() {
  int [] depth = kinect.getRawDepth(); // get the depth values ranging from 0-4500 from the kinect
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

void drawSilhouette(float x, float y) {
  xSilhouetteCoordinates.add(x);
  ySilhouetteCoordinates.add(y);
  fill(silhouetteColor);
  rect(x, y, 2, 2); // create a rectangle for showing the silhoutte of the user
}

void makeDrawing(float x, float y) {
  fill(currentDrawingColor);
  ellipse(x, y, 5, 5); // create an ellipse for showing the hands (what the user is currently drawing)
}

void checkColor() {
  stroke(255);
  line(width - eraserWidth, 0, width - eraserWidth, height);
  noStroke();
  if (centerOfMass_y < colorPaletteHeight) updateCurrentDrawingColor(); // check if the user has the center of mass over a certain color in the color palette, and if so, update the color to the corresponding one
  if (centerOfMass_y > colorPaletteHeight && centerOfMass_x > (width - eraserWidth)) currentDrawingColor = backgroundColor; // activate the eraser if the user is selecting the eraser
  // feedback to the user of the current drawing color
  fill(currentDrawingColor);
  rect(20, height - 50, 100, 30);
}


void updateCenterOfMass() {
  if(isMouseControlled) { 
    centerOfMass_x = mouseX;
    centerOfMass_y = mouseY;
    return;
  }
  // get the center position of the silhouette by calculating the average position of all the x and y coordinates that are inside of the color palette hitbox 
  // average = (sum of all coordinates) / (number of coordinates)
  // in this case, we only want to calculate the center of mass of what is 
  int numberCoordinatesSilhouette = 0; // amount of coordinates of the silhouette
  float xCounter = 0; // used to calculate the sum of all the x coordinates of the silhouette
  float yCounter = 0; // used to calculate the sum of all the y coordinates of the silhouette
  int yOffset = -50; // used to offset the center of mass in the y axis to allow the users to select colors more easily
  for (int i = 0; i < xSilhouetteCoordinates.size(); i++) {
    // toolbar.checkHitboxes(xSilhouetteCoordinates.get(i), ySilhouetteCoordinates.get(i));
    // if(ySilhouetteCoordinates.get(i) < (colorPaletteHeight + yOffset) || xSilhouetteCoordinates.get(i) > (width - eraserWidth)) {
      xCounter += xSilhouetteCoordinates.get(i);
      yCounter += ySilhouetteCoordinates.get(i);
      numberCoordinatesSilhouette++;
    // }
  }
  // to avoid dividing by zero, and to avoid noise, check if the number of coordinates in the silhouette is higher number than this value
  if(numberCoordinatesSilhouette > 50) {
    centerOfMass_x = xCounter / numberCoordinatesSilhouette;
    centerOfMass_y = yCounter / numberCoordinatesSilhouette + yOffset;
    // we clear the array lists, as there is a new silhouette every frame, and we only to keep track of the latest silhouette coordinates, not of the entire history of silhouettes
    xSilhouetteCoordinates.clear();
    ySilhouetteCoordinates.clear();
    numberCoordinatesSilhouette = 0;
  }
  // println(centerOfMass_x, centerOfMass_y);
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

void showColorPalette() {
  for(int i = 0; i < numColors; i++) {
    fill(drawingColors[i]);
    rect(xColorPalette[i], 0, colorPalettesWidth, colorPaletteHeight / 2);
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
