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
    this.calculateCenterOfMass();
    if (this.centerOfMassisInsideHitbox()) {
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

  boolean isInsideHitbox(float x, float y) {
    if (x > this.x && x < (this.x + this.bWidth) &&
      y > this.y && y < (this.y + this.bHeight)) {
      return true;
    } else return false;
  }
  
  boolean centerOfMassisInsideHitbox() {
    if (centerOfMass_x > this.x && centerOfMass_x < (this.x + this.bWidth) &&
      centerOfMass_y > this.y && centerOfMass_y < (this.y + this.bHeight)) {
      return true;
    } else return false;
  }

  void calculateCenterOfMass() {
    int numberCoordinatesSilhouette = 0; // the number of coordinates of the silhouette that are inside of this button's hitbox
    int xSum = 0, ySum = 0;
    for(int i = 0; i < xSilhouetteCoordinates.size(); i++) {
      if(isInsideHitbox(xSilhouetteCoordinates.get(i), ySilhouetteCoordinates.get(i))) {
        xSum += xSilhouetteCoordinates.get(i);
        ySum += ySilhouetteCoordinates.get(i);
        numberCoordinatesSilhouette++;
      }
    }
    // to avoid dividing by zero, and to avoid noise, check if the number of coordinates in the silhouette is higher number than this value
    if(numberCoordinatesSilhouette > 5) {
      centerOfMass_x = xSum / numberCoordinatesSilhouette;
      centerOfMass_y = ySum / numberCoordinatesSilhouette;
      numberCoordinatesSilhouette = 0;
    }
  }
}
