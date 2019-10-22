
// look at Daniel Shiffman's Kinect tutorials:
// https://shiffman.net/p5/kinect/

// import the library responsible for getting the 
import org.openkinect.processing.*;

Kinect2 kinect;

void setup() {
  kinect = new Kinect2(this);
  kinect.initDepth();
  kinect.initDevice();
  size(600, 400);
}

void draw() {
  background(0);
  // get the grayscale image
  PImage img = kinect.getDepthImage();
  // PImage output = createImage(img.width, img.height, RGB);
  int skip = 1;
  for(int x = 0; x < img.width; x += skip) {
    for(int y = 0; y < img.height; y += skip) {
      int index = x + y * img.width;
      float b = brightness(img.pixels[index]);
      noStroke();
      fill(b);
      if(b <= 100) {
        rect(x, y, skip, skip);
      }
    }
  }
  
  /*
  output.loadPixels();
  int skip = 1;
  for(int x = 0; x < img.width; x += skip) {
    for(int y = 0; y < img.width; y += skip) {
      int distance = x + y * img.width;
      if(distance > 130000) {
        pixels[];
      }
    }
  }
  output.updatePixels();
  */
  /*
  int[] depth = kinect.getRawDepth(); // raw depth data
  for(int i = 0; i < depth.length; i++) {
    int d = depth[i];
    if(d >= 130000) {
      
    }
  }
  */
  // image(img, 0, 0);
}

void videoEvent(Kinect k) {
  // There has been a video event!
}
