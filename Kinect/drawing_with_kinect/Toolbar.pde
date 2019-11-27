class Toolbar {
  // variables
  Slider slider; // creating the slider
  Button eraser, pipet, toolbarButton; // creating the buttons
  PImage eraserImg, pipetImg, toolbarImg;
  // constructor
  Toolbar() {
    // initializing the slider
    slider = new Slider();
    // initializing the buttons
    eraserImg = loadImage("eraser.png");
    pipetImg = loadImage("pipette.png");
    toolbarImg = loadImage("pipette.png");
    eraser = new Button(0, 0, 100, 50, true, false, false, "Eraser", eraserImg);
    pipet = new Button(100, 0, 100, 50, false, true, false, "pipet", pipetImg);
    toolbarButton = new Button(width - 100, 0, 100, 50, false, false, true, "Toolbar", toolbarImg);
  }
  
  void update() {
    // update sliders and buttons
    toolbarButton.update(); // always show the toolbar button
    // only show the toolbar if the user selected it
    if(showToolbar) {
      slider.update();
      eraser.update();
      pipet.update();
    }
  }
}
