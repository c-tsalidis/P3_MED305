// this code was inspired by --> https://www.openprocessing.org/sketch/184101

class Slider {
  // variables
  float colorBarWidth = width / 2;
  float sliderXPos = width/2;
  float colourVal = map(sliderXPos, 0.0, colorBarWidth, 0.0, 255.0);

  // constructor
  Slider() {}
  
  void update() { // this is like draw
    if(showToolbar) colourVal = updateSlider((width / 2) - (colorBarWidth / 2), 0, colorBarWidth, 50.0, colourVal);
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
    rect(sliderPosition + xPos - 3, yPos - 5, 6, sliderH + 10);
    // rect(sliderW + 40, yPos, sliderH, sliderH); // rectangle telling the user what color it is
    noStroke();
    currentDrawingColor = color(hueVal,255,255);
    return hueVal;
  }
}
