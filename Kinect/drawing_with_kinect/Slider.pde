// this code was inspired by --> https://www.openprocessing.org/sketch/184101

class Slider {
  // variables
  int colorBarWidth = width / 2;
  int colorBarHeight =50;
  int sliderXPos = width/2;
  float colourVal = map(sliderXPos, 0.0, colorBarWidth, 0.0, 255.0);
  int sliderX = width/4;
  int sliderY = 10;
  

  // constructor
  Slider() {}
  
  void update() { // this is like draw
    this.calculateCenterOfMass();
    if(showToolbar) {
      colourVal = updateSlider(sliderX, sliderY, colorBarWidth, colorBarHeight, colourVal);
    }
  }
  
  float updateSlider(float xPos, float yPos, float sliderW, float sliderH, float hueVal) {
    colorMode(HSB);
    float sliderPosition = map(hueVal, 0.0, 255.0, 0.0, sliderW); // find the position of the slider.
    for (int i = 0; i < sliderW; i++) { //draw 1 line for each hueValue from 0-255
      hueVal = map(i, 0.0, sliderW, 0.0, 255.0); //get hueVal for each position in the bar
      stroke(hueVal, 255, 255);
      line(xPos + i, yPos, xPos + i, yPos + sliderH);
    }
    if (centerOfMass_x > xPos && centerOfMass_x < (xPos + sliderW) && centerOfMass_y > yPos && centerOfMass_y < (yPos + sliderH)) {
      sliderPosition = centerOfMass_x - xPos;
    }
    stroke(100);
    hueVal = map(sliderPosition, 0.0, sliderW, 0.0, 255.0);
    fill(hueVal, 255, 255);
    rect(sliderPosition + xPos - 3, yPos - 5, 20, sliderH + 10);
    // rect(sliderW + 40, yPos, sliderH, sliderH); // rectangle telling the user what color it is
    noStroke();
    if(!isErasing && !isPipetting) currentDrawingColor = color(hueVal,255,255);
    return hueVal;
  }
  
  boolean isInsideHitbox(float x, float y) {
    if (x > ((width / 2) - (colorBarWidth / 2)) && x < ((width / 2) - (colorBarWidth / 2) + this.colorBarWidth) &&
      y > 0 && y < (50)) {
      return true;
    } else return false;
  }
  
  void calculateCenterOfMass() {
    if(isMouseControlled) { 
      centerOfMass_x = mouseX;
      centerOfMass_y = mouseY;
      return;
    }
    int numberCoordinatesSilhouette = 0; // the number of coordinates of the silhouette that are inside of this button's hitbox
    int xSum = 0, ySum = 0;
    for(int i = 0; i < xSilhouetteCoordinates.size(); i++) {
      if(isInsideHitbox(xSilhouetteCoordinates.get(i), ySilhouetteCoordinates.get(i))) {
        xSum += xSilhouetteCoordinates.get(i);
        ySum += ySilhouetteCoordinates.get(i);
        numberCoordinatesSilhouette++;
      }
    }
    // to avoid dividing by zero, and to avoid noise, check if the number of coordinates in the silhouette is higher number than this value
    if(numberCoordinatesSilhouette > noiseFilter) {
      centerOfMass_x = xSum / numberCoordinatesSilhouette;
      centerOfMass_y = ySum / numberCoordinatesSilhouette;
      numberCoordinatesSilhouette = 0;
    }
  }
}
