class Toolbar {
  // variables
  Slider slider; // creating the slider
  Button eraser, pipet, toolbarButton; // creating the buttons
  
  // constructor
  Toolbar() {
    // initializing the slider
    slider = new Slider();
    // initializing the buttons
    eraser = new Button(0, 0, 100, 50, true, false, false, "Eraser");
    pipet = new Button(100, 0, 100, 50, false, true, false, "pipet");
    toolbarButton = new Button(width - 100, 0, 100, 50, false, false, true, "Toolbar");
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
  /*
  void checkHitboxes(int x, int y) {
    if(eraser.isInsideHitbox()) calculateCenterOfMassFromHitbox(eraser);
    else if(pipet.isInsideHitbox()) calculateCenterOfMassFromHitbox(pipet);
    else if(toolbarButton.isInsideHitbox()) calculateCenterOfMassFromHitbox(toolbarButton);
  }
  
  void calculateCenterOfMassFromHitbox(Button b) {
    centerOfMass_x = (b.x + b.bWidth) / 2;
    centerOfMass_y = (b.y + b.bHeight) / 2;
  }
  */
}
