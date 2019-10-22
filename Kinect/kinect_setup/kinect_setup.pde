
// look at Daniel Shiffman's Kinect tutorials:
// https://shiffman.net/p5/kinect/

// import the library responsible for getting the 
import org.openkinect.processing.*;

Kinect2 kinect;
PImage img;

void setup() {
   // 640 X 480
  int kinnectResolutionX = 512;
  int kinnectResolutionY = 424;
  kinect = new Kinect2(this);
  kinect.initDepth();
  kinect.initDevice();
  // size(kinnectResolutionX * 2, kinnectResolutionY * 2);
  size(512, 424);
  img = createImage(kinect.depthWidth, kinect.depthHeight, RGB);
}

void draw() {
  // get the grayscale image
  // PImage img = kinect.getDepthImage();
  // 0-4500
  img.loadPixels();
  int [] depth = kinect.getRawDepth();
  /*
  for(int x = 0; x < img.width; x += skip) {
    for(int y = 0; y < img.height; y += skip) {
      // int distance = depth[x + y * img.width];
      int index = x + y * img.width;
      float b = brightness(img.pixels[index]);
      noStroke();
      fill(b);
      if(b <= 75) {
      // if(distance <= 2200) {
        rect(x * 2, y * 2, skip, skip);
      }
    }
  }
  */
  noStroke();
  for(int x = 0; x < kinect.depthWidth; x += 1) {
    for(int y = 0; y < kinect.depthHeight; y += 1) {
      int offset = x + y * kinect.depthWidth;
      int d = depth[offset];
      // img.pixels[offset] = color();
      if(d > 300 && d < 1500) {
        img.pixels[offset] = color(150);
      }
      else {
        img.pixels[offset] = color(0);
      }
    }
  }
  img.updatePixels();
  image(img, 0, 0);
}
