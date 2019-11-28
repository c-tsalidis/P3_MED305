class Toolbar {
  // variables
  Slider slider; // creating the slider
  Button eraser, toolbarButton; // creating the buttons
  PImage eraserImg, pipetImg, toolbarImg;
  int tHeight = 75;
  
  // constructor
  Toolbar() {
    // initializing the slider
    slider = new Slider();
    // initializing the buttons
    eraserImg = loadImage("eraser.png");
    // pipetImg = loadImage("pipette.png");
    toolbarImg = loadImage("hand.png");
    // imageThreshold(eraserImg);
    // imageThreshold(toolbarImg);
    eraser = new Button(0, 0, 100, 50, true, false, false, "Eraser", eraserImg);
    eraser.bWidth = this.tHeight;
    eraser.bHeight = this.tHeight;
    // pipet = new Button(100, 0, 100, 50, false, true, false, "pipet", pipetImg);
    toolbarButton = new Button(width - 100, 0, 100, 50, false, false, true, "Toolbar", toolbarImg);
    toolbarButton.bWidth = this.tHeight;
    toolbarButton.bHeight = this.tHeight;
    toolbarButton.x = width - toolbarButton.bWidth;
  }
  
  void update() {
    stroke(255);
    line(0, this.tHeight, width, this.tHeight);
    noStroke();
    // update sliders and buttons
    toolbarButton.update(); // always show the toolbar button
    // only show the toolbar if the user selected it
    if(showToolbar) {
      slider.update();
      eraser.update();
      // pipet.update();
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
