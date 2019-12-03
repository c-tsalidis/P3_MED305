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
    eraser = new Button(0, 0, 100, 50, true, false, false, "Eraser", eraserImg);
    eraser.bWidth = this.tHeight;
    eraser.bHeight = this.tHeight;
    toolbarButton = new Button(width - 100, 0, 100, 50, false, false, true, "Toolbar", toolbarImg);
    toolbarButton.bWidth = this.tHeight;
    toolbarButton.bHeight = this.tHeight;
    toolbarButton.x = width - toolbarButton.bWidth;
  }
  
  void update() {
    toolbarButton.update();
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
  
  void imageThreshold(PImage image) {
    image.loadPixels();
    for (int x = 0; x < image.width; x++) {
      for (int y = 0; y < image.height; y++) {
        int loc = x + y * image.width;
        if(image.pixels[loc] != 255) image.pixels[loc] = 255;
      }
    }
    image.updatePixels();
  }
}
