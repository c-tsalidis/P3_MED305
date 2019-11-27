class Button {
  // variables
  int x, y, bWidth, bHeight;
  boolean isEraser, isPipet, isToolbarButton;
  boolean hasEntered = false;
  String text;
  PImage image;

  // constructor
  Button(int _x, int _y, int _bWidth, int _bHeight, boolean _isEraser, boolean _isPipet, boolean _isToolbarButton, String _text, PImage _image) {
    this.x = _x;
    this.y = _y;
    this.bWidth = _bWidth;
    this.bHeight = _bHeight;
    this.isEraser = _isEraser;
    this.isPipet = _isPipet;
    this.isToolbarButton = _isToolbarButton;
    this.text = _text;
    this.image = _image;
  }

  void update() {
    this.display();
    if (this.isInsideHitbox()) {
      if (!hasEntered) {
        if (this.isEraser) {
          // if (currentDrawingColor != backgroundColor) currentDrawingColor = backgroundColor;
          // else currentDrawingColor = previousColor;
          isErasing = !isErasing;
          // println("is erasing: "+ isErasing);
        } else if (this.isPipet) {
          // the user is selecting color from the drawing
          isPipetting = !isPipetting;
          // println("is pipetting: " + isPipetting);
        } else if (this.isToolbarButton) {
          // the user wants to either show or hide the tool bar
          showToolbar = !showToolbar;
          // println("isShowing toolbar: " + showToolbar);
        }
        hasEntered = true;
      }
    } else {
      hasEntered = false;
    }
  }

  void display() {

    fill(255);
    rect( this.x, this.y, this.bWidth, this.bHeight);
    image(this.image, this.x, this.y, this.bWidth, this.bHeight);
  }

  boolean isInsideHitbox() {
    if (centerOfMass_x > this.x && centerOfMass_x < (this.x + this.bWidth) &&
      centerOfMass_y > this.y && centerOfMass_y < (this.y + this.bHeight)) {
      return true;
    } else return false;
  }

  void checkCenterOfMass() {
    // check from the x and y coordinates of the silhouette if the center of mass is in between this button's hitbox
  }
}
