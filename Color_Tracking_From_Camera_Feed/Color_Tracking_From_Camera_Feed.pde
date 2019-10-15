
// Code for the P3_MED305

// Inspired by Daniel Shiffman's tutorial on color tracking. His videos are linked as follows:
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/nCVZHROb_dE

import processing.video.*;

Capture video;

color trackColor; 
float threshold = 25;

int numberOfCircles = 50;
float[] x = new float[numberOfCircles];
float[] y = new float[numberOfCircles];

void setup() {
  size(1280, 720);
  String[] cameras = Capture.list();
  printArray(cameras);
  // Works --> camera index --> 2, 3, 4, 5, 6
  video = new Capture(this, cameras[6]);
  video.start();
  
  // trackColor = color(200, 0, 0);
  trackColor = color(200, 0, 0);
  // trackColor = color(#FFF000); // yellow
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(0);
  video.loadPixels();
  // image(video, 0, 0);

  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 80;

  float avgX = 0;
  float avgY = 0;

  int count = 0;
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < (threshold*threshold)) {
        /*
        stroke(255);
        strokeWeight(1);
        point(x, y);
        */
        avgX += x;
        avgY += y;
        count++;
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 0) { 
    // avgX = avgX / count;
    // avgY = avgY / count;
    avgX = width - (avgX / count);
    avgY = avgY / count;
    // avgY = height - (avgY / count);
    // Draw a circle at the tracked pixel
    fill(255);
    // strokeWeight(4.0);
    // stroke(0);
    noStroke();
    ellipse(avgX, avgY, 50, 50);
     x[0] = avgX;
     y[0] = avgY;
     int counter = 0;
     for (int i= numberOfCircles - 1; i > 0; i--) {
       if(counter <= 255) {
         counter += 1;
       }
       x[i] = x[i-1];
       y[i] = y[i-1];
       // fill(color(random(255), random(255), random(255)), counter);
       fill(255, counter);
       ellipse(x[i], y[i], counter, counter);
     }
  }
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
} 
