
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
  PImage img = kinect.getDepthImage();
  image(img, 0, 0);
}

void videoEvent(Kinect k) {
  // There has been a video event!
}
