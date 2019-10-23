
// look at Daniel Shiffman's Kinect tutorials:
// https://shiffman.net/p5/kinect/

// import the library responsible for getting the 
import org.openkinect.processing.*;

Kinect2 kinect;
PImage img;
PImage output;
PImage cameraImg;

void setup() {
   // 512 x 424
  kinect = new Kinect2(this);
  kinect.initVideo();
  kinect.initDepth();
  kinect.initDevice();
  // size(kinnectResolutionX * 2, kinnectResolutionY * 2);
  // size(512, 424);
  fullScreen();
  img = createImage(kinect.depthWidth, kinect.depthHeight, RGB);
  output = createImage(width, height, RGB);
}

void draw() {
  cameraImg = kinect.getVideoImage();
  // cameraImg = kinect.getIrImage();
  // get the grayscale image
  // 0-4500
  img.loadPixels();
  int [] depth = kinect.getRawDepth();
  noStroke();
  int skip = 1;
  for(int x = 0; x < kinect.depthWidth; x += skip) {
    for(int y = 0; y < kinect.depthHeight; y += skip) {
      int offset = x + y * kinect.depthWidth;
      int d = depth[offset];
      // if(d <= 300) img.pixels[offset] = color(255);
      if(d > 300 && d < 1500) {
      // if(d < 1500) {
        img.pixels[offset] = color(150);
        // output.pixels[offset] = color(150);
        // output.pixels[offset + 1] = color(150);
        // fill(150);
      }
      else {
        img.pixels[offset] = color(0);
        // output.pixels[offset] = color(0);
        // output.pixels[offset + 1] = color(0);
        // fill(0);
      }
      // rect(x * 2, y * 2, skip * 2, skip * 2); // increase the size with rectangles
    }
  }
  img.updatePixels();
  // image(cameraImg, 0, 0);
  colorTracking();
  image(img, 0, 0);
}

void colorTracking() {
  // background(0);
  int amountCircles = 50;
  float [] xCirles = new float[amountCircles];
  float [] yCirles = new float[amountCircles];
  color trackColor = color(200, 0, 0);
  int threshold = 80;
  float avgX = 0;
  float avgY = 0;
  int count = 0;
  // Begin loop to walk through every pixel
  for (int x = 0; x < cameraImg.width; x++ ) {
    for (int y = 0; y < cameraImg.height; y++ ) {
      int loc = x + y * cameraImg.width;
      // What is current color
      // int index = x + y * cameraImg.width;
      // float b = brightness(cameraImg.pixels[index]);
      color currentColor = cameraImg.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < (threshold*threshold)) {
        avgX += x;
        avgY += y;
        count++;
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 0) { 
    // avgX = width - (avgX / count);
    avgX = avgX / count;
    avgY = avgY / count;
    // avgY = height - (avgY / count);
    // Draw a circle at the tracked pixel
    fill(255);
    // strokeWeight(4.0);
    // stroke(0);
    noStroke();
    ellipse(avgX, avgY, 50, 50);
     xCirles[0] = avgX;
     yCirles[0] = avgY;
     int counter = 0;
     for (int i= amountCircles - 1; i > 0; i--) {
       if(counter <= 255) {
         counter += 1;
       }
       xCirles[i] = xCirles[i-1];
       yCirles[i] = yCirles[i-1];
       // fill(color(random(255), random(255), random(255)), counter);
       fill(255, counter);
       ellipse(xCirles[i], yCirles[i], counter, counter);
     }
  }
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}
