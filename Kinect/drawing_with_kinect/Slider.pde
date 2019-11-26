
class Slider {
  // variables
  float colorWidth= width;
  float sPos = width/2;
  float colourVal = map(sPos, 0.0, colorWidth, 0.0, 255.0);



  // constructor
  Slider() {
  }
  void update() { // this is like draw
    colourVal= updateSlider(20.0, 20.0, width-100, 30.0, colourVal);
  }
  float updateSlider(float xPos, float yPos, float sliderW, float sliderH, float hueVal) {
    colorMode(HSB);

    float colorPos = map(hueVal, 0.0, 255.0, 0.0, sliderW); //find the position of the slider.

    for (int i = 0; i<sliderW; i++) {
      hueVal=map(i, 0.0, sliderW, 0.0, 255.0);
      stroke(hueVal, 255, 255);
      line(xPos+i, yPos, xPos+i, yPos+sliderH);
    }
    if (centerOfMass_x>xPos && centerOfMass_x<(xPos+sliderW) && centerOfMass_y>yPos && centerOfMass_y<(yPos+sliderH)) {
      colorPos=centerOfMass_x-xPos;
    }
    stroke(100);
    hueVal=map(colorPos, 0.0, sliderW, 0.0, 255.0);
    fill(hueVal, 255, 255);
    rect(colorPos+xPos-3, yPos-5, 6, sliderH+10);
    rect(sliderW+40, yPos, sliderH, sliderH);
    return hueVal;
  }
}
