import org.openkinect.processing.*;

Kinect2 kinect;
PImage img;

int minSilhouetteThreshold = 700;
int maxSilhouetteThreshold = 1500;

float hand_x; 
float hand_y;

int numCircles = 5000;
float [] savedX; // keeping track of all the x coordinates of all the circles
float [] savedY; // keeping track of all the y coordinates of all the circles

Star [] myStars = new Star[1200]; // the stars for the background
BrushShape [] brushes = new BrushShape[numCircles];

boolean isDrawing; // is the user inside the boundaries for drawing?

color currentDrawingColor;

PImage drawingImage;

float x;
float y;
float x2;
float y2;

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
  drawingImage = createImage(width, height, RGB);
  savedX = new float [numCircles];
  savedY = new float [numCircles];
  createStars(); // only need to create the stars once, so do it in setup
  createBrushes();
  currentDrawingColor = color(255, 0, 0, 100); // by default make the drawing color red with an alpha of 100
}

void draw() {
  // background(0);
  image(drawingImage, 0, 0);
  drawBackground();
  processDepth(); // process the depth values given by the kinect, and draw the silhoutte if user inside boundaries (between min and max thresholds)
  updateColor();
  createDrawing(); // show the drawing of the player every frame
  /*
  for (int i = 0; i < numCircles; i++) {
    println(x[i], y[i]);
  }
  */
  // delay(10);
  
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

void createBrushes() {
  for (int i = 0; i < numCircles; i++) {
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
  if(_x * xProp < 150 && _y * yProp < 150) return; // there are some dots in tge upper left corner that are annoying, so just don't paint them. Alternatively, filter the noise
  rect(_x * xProp, _y * yProp, 5, 5); // create a rectangle for showing the silhoutte
  updateDrawingCoordinates(d, _x, _y, xProp, yProp);
  
}

void createDrawing() {
  for (int i = 0; i < numCircles; i++) {
    // fill(currentDrawingColor);
    // ellipse(xDrawings.get(i), yDrawings.get(i), 25, 25);
    // if(savedX[i] == 0 || savedY[i] == 0) continue; // if they're on their default state (0 in both axis), then don't draw them
    // ellipse(savedX[i], savedY[i], 25, 25);
    brushes[i].display();
  }
  /*
  for(int x = 0; x < drawingImage.width; x++) {
    for(int y = 0; y < drawingImage.height; y++) {
      int loc = x + y * width;
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      r += 50;
      pixels[loc] = color(r, g, b);
    }
  }
  */
}

void updateDrawingCoordinates(int depth, float _x, float _y, float xProp, float yProp) {
  if(depth < minSilhouetteThreshold) {
    hand_x = _x * xProp;
    hand_y = _y * yProp;
  }
  if (depth < (minSilhouetteThreshold + 100)) {
    // int minDist = 3;
    isDrawing = true;
    brushes[0].x = _x * xProp;
    brushes[0].y = _y * yProp;
    // savedX[0] = _x * xProp;
    // savedY[0] = _y * yProp;
    for(int i = numCircles - 1; i > 0; i--) {
      // if(abs(x[i] - x[i-1]) >= minDist && abs(y[i] - y[i-1]) >= minDist) {
        brushes[i].x = brushes[i-1].x;
        brushes[i].y = brushes[i-1].y;
        // savedX[i] = savedX[i-1];
        // savedY[i] = savedY[i-1];          
      // }
    }
    /*
    drawingImage.loadPixels();
    int loc = (int)((_x) + (_y ) * width);
    println(loc);
    drawingImage.pixels[loc] = currentDrawingColor;
    drawingImage.updatePixels();
    */
  } else isDrawing = false;
}

void updateColor() {
  if(hand_y < 100) currentDrawingColor = color(random(0, 256), 0, random(0, 256));
}

void smoothDrawing(float currentX, float currentY) {
  float easing = 0.3;
  float diameter = 20;
  float targetX = currentX;
  float dx = (currentX-x) * easing;
  float targetY = currentY;
  float dy = (currentY-y) * easing;
  float t;
  float cx;
  float cy;
  float steps;
  if (isDrawing) {
     x2 = x + dx;
     y2 = y + dy;
    // Draw additional circles between frames for smooth brushstrokes
    steps = 80;
    for (int i = 0; i <= steps; i += 1) {
      t = i/steps;
      cx = lerp(x, x2, t); //get fractional x positions
      cy = lerp(y, y2, t); //get fractional y positions
      pushMatrix();
      translate (cx, cy);
      //Draw lines
      fill(255);
      ellipse(-(diameter/2), -(diameter/2), diameter, diameter);
      popMatrix();
    }
    x = x2;
    y = y2;
  } else {
    x = targetX;
    y = targetY;
  }
}
