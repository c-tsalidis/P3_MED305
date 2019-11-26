class Toolbar {
  // variables
  Slider slider; // creating the slider
  Button eraser, pipet, toolbarButton; // creating the buttons
  
  // constructor
  Toolbar() {
    // initializing the slider
    slider = new Slider();
    // initializing the buttons
    eraser = new Button(0, 0, 100, 50);
    pipet = new Button(100, 0, 100, 50);
    toolbarButton = new Button(width - 100, 0, 100, 50);
  }
  
  void update() {
    slider.update();
    eraser.update();
    pipet.update();
    toolbarButton.update();
  }
}
