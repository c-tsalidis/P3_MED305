// this code was inspired by --> https://www.openprocessing.org/sketch/184101
class Slider {
  // variables
  int colorBarWidth;
  int colorBarHeight;
  int sliderXPos = width / 2;
  float colourVal = map(sliderXPos, 0.0, colorBarWidth, 0.0, 255.0);
  int sliderX;
  int sliderY = 10;

  // constructor
  Slider() {}

  void update() { // this is like draw
    this.calculateCenterOfMass();
    if (showToolbar) {
      updateSlider(sliderX, sliderY, colorBarWidth, colorBarHeight, colourVal);
      colorBarWidth = width - toolbar.eraser.bWidth - toolbar.toolbarButton.bWidth - 200;
      sliderX = toolbar.eraser.bWidth+100;
      colorBarHeight = toolbar.tHeight-toolbar.tHeight/3;
    }
  }

  void updateSlider(float xPos, float yPos, float sliderW, float sliderH, float hueVal) {
    colorMode(HSB);
    float sliderPosition = map(hueVal, 0.0, 255.0, 0.0, sliderW); // find the position of the slider.
    for (int i = 0; i < sliderW; i++) { //draw 1 line for each hueValue from 0-255
      hueVal = map(i, 0.0, sliderW, 0.0, 255.0); //get hueVal for each position in the bar
      stroke(hueVal, 255, 255); //this is the reason we use HSB to only change the one value hue
      line(xPos + i, yPos, xPos + i, yPos + sliderH);
    }
    if (centerOfMass_x > xPos && centerOfMass_x < (xPos + sliderW) && centerOfMass_y > yPos && centerOfMass_y < (yPos + sliderH)) {
      sliderPosition = centerOfMass_x - xPos;
    }
    stroke(100);
    hueVal = map(sliderPosition, 0.0, sliderW, 0.0, 255.0);
    fill(hueVal, 255, 255); //Fill the center of the slider position indicator with the color that is selected
    rect(sliderPosition + xPos - 3, yPos - 5, 20, sliderH + 10);
    noStroke();
    if (!isErasing) { //if the user is not erasing, then use the selected color.
      currentDrawingColor = color(hueVal, 255, 255);
      colourVal = hueVal;
    }
  }

  boolean isInsideHitbox(float x, float y) {
    if (x > ((width / 2) - (colorBarWidth / 2)) && x < ((width / 2) - (colorBarWidth / 2) + this.colorBarWidth) &&
      y > 0 && y < (50)) {
        isErasing = false;
        return true;
    } else return false;
  }

  void calculateCenterOfMass() {
    if (isMouseControlled) { 
      centerOfMass_x = mouseX;
      centerOfMass_y = mouseY;
      return;
    }
    int numberCoordinatesSilhouette = 0; // the number of coordinates of the silhouette that are inside of this button's hitbox
    int xSum = 0, ySum = 0;
    for (int i = 0; i < xSilhouetteCoordinates.size(); i++) {
      if (isInsideHitbox(xSilhouetteCoordinates.get(i), ySilhouetteCoordinates.get(i))) {
        xSum += xSilhouetteCoordinates.get(i);
        ySum += ySilhouetteCoordinates.get(i);
        numberCoordinatesSilhouette++;
      }
    }
    // to avoid dividing by zero, and to avoid noise, check if the number of coordinates in the silhouette is higher number than this value
    if (numberCoordinatesSilhouette > noiseFilter) {
      centerOfMass_x = xSum / numberCoordinatesSilhouette;
      centerOfMass_y = ySum / numberCoordinatesSilhouette;
      numberCoordinatesSilhouette = 0;
    }
  }
}
