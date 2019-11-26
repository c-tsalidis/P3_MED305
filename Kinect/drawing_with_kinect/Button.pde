class Button {
  // variables
  int x, y, bWidth, bHeight;
  boolean isEraser, isPipet, isToolbarButton;
  
  // constructor
  Button(int _x, int _y, int _bWidth, int _bHeight) {
    this.x = _x;
    this.y = _y;
    this.bWidth = _bWidth;
    this.bHeight = _bHeight;
  }
  
  void update() {
    if(isInsideHitbox()) {
      if(isEraser) {
        if(currentDrawingColor != backgroundColor) currentDrawingColor = backgroundColor;
        else currentDrawingColor = previousColor;
      }
      else if(isPipet) {
        // the user is selecting color from the drawing
        
      }
      else if(isToolbarButton) {
        // the user wants to either show or hide the tool bar
      }
    }
  }
  
  boolean isInsideHitbox() {
    if(centerOfMass_x > this.x && centerOfMass_x < (this.x + this.bWidth) &&
      centerOfMass_y > this.y && centerOfMass_y < (this.y + this.bHeight)) {
        return true;
    } else return false;
  }
}
