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
  // xDrawings = new float[1000];
  // yDrawings = new float[1000];
}

void draw() {
  background(0);
  /*
  if(redColorCounter > 255) redColorCounter = 0; else redColorCounter++;
   if(greenColorCounter > 255) greenColorCounter = 0; else  { if(redColorCounter > 255) greenColorCounter++; }
   if(blueColorCounter > 255) blueColorCounter = 0; else {if(greenColorCounter > 255) blueColorCounter++;}
   */
  processDepth();
  createDrawing();
  // println(drawingIndexCounter);
  // println("User is drawing: " + isDrawing);
  // println(xDrawings.size());
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
  // img.updatePixels();
  // image(cameraImg, 0, 0);
  // imageMode(CENTER);
  // image(img, width/2, height/2, width, height);
  // image(img, width/2, height/2);
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
      if(sizeCounter < 50000) {
      // xDrawings[drawingIndexCounter] = _x * xProp;
      // yDrawings[drawingIndexCounter] = _y * yProp;
      // int sameCounterX = 0;
      xDrawings.add(_x * xProp);
      yDrawings.add(_y * yProp);
      sizeCounter+=10;
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
  float x = 0;
  float y = 0;
  float x2;
  float y2;
  float easing = 0.3;
  float diameter = 20;
  float targetX = hand_x;
  float dx = (hand_x-x) * easing;
  float targetY = hand_y;
  float dy = (hand_y-y) * easing;
  float t;
  float cx;
  float cy;
  float steps;

  for (int i = 0; i < xDrawings.size(); i++) {
    // println("Drawing all of em");
    fill(255, 0, 0, 100);
    ellipse(xDrawings.get(i), yDrawings.get(i), 25, 25);
  }

  if (isDrawing) {
    
    /*
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
     */
  }
}
