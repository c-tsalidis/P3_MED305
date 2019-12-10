class Toolbar {
  // variables
  Slider slider; // creating the slider
  Button eraser, toolbarButton; // creating the buttons
  PImage eraserImg, pipetImg, toolbarImg, toolbarInactiveImg, eraserInactiveImg;
  int tHeight = 75;
  
  // constructor
  Toolbar() {
    // initializing the slider
    slider = new Slider();
    // initializing the images for the buttons
    eraserImg = loadImage("eraser.png");
    eraserInactiveImg = loadImage("eraserInactive.png");
    toolbarImg = loadImage("hand.png");
    toolbarInactiveImg = loadImage("handInactive.png");
    // initializing the buttons
    eraser = new Button(0, 0, 100, 50, true, false, "Eraser", eraserImg);
    eraser.bWidth = this.tHeight;
    eraser.bHeight = this.tHeight;
    toolbarButton = new Button(width - 100, 0, 100, 50, false, true, "Toolbar", toolbarImg);
    toolbarButton.bWidth = this.tHeight;
    toolbarButton.bHeight = this.tHeight;
    toolbarButton.x = width - toolbarButton.bWidth;
  }
  
  void update() {
    toolbarButton.update();
    previousColor = currentDrawingColor;
    if(showToolbar) {
      toolbarButton.image = toolbarImg;
      slider.update();
      eraser.update();
      if(isErasing) eraser.image = eraserImg;
      else eraser.image = eraserInactiveImg;
    }
    else {
      toolbarButton.image = toolbarInactiveImg;
      isErasing = false;
      currentDrawingColor = previousColor;
    }
  }
}
