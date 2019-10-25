import org.openkinect.processing.*;

Kinect2 kinect;
PImage img;
PImage cameraImg;

int minSilhouetteThreshold = 300;
int maxSilhouetteThreshold = 1500;
int minDrawingThreshold = 200;
int maxDrawingThreshold = minDrawingThreshold;

void setup() {
  
   // 512 x 424
  kinect = new Kinect2(this);
  kinect.initVideo();
  kinect.initDepth();
  kinect.initDevice();
  fullScreen();
  img = createImage(kinect.depthWidth, kinect.depthHeight, RGB);
}

void draw() {
  // translate(width/2, height/2);
  background(0);
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
      if(d > 300 && d < 1500) {
        img.pixels[offset] = color(255);
        drawSilhouette(x, y, skip, skip); // increase the size with rectangles
      }
      else {
        img.pixels[offset] = color(0);
      }
    }
  }
  img.updatePixels();
  // image(cameraImg, 0, 0);
  imageMode(CENTER);
  // image(img, width/2, height/2, width, height);
  // image(img, width/2, height/2);
}


void drawSilhouette(int _x, int _y, int _width, int _height) {
  fill(255);
  float YProp = 3; // y proportion
  // newWidth = newHeight * aspectRatio;
  float xProp = YProp * kinect.depthWidth / kinect.depthHeight; // x proprotion
  noStroke();
  // rect(_x * xProp, _y * YProp, _width, _height);
  rect(_x * xProp, _y * YProp, 5, 5);
  // point(_x * xProp, _y * YProp);
  // ellipse(_x * xProp, _y * YProp, 2, 2);
}
