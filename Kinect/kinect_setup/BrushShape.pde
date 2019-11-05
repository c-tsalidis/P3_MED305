class BrushShape {
  // variables
  float x;
  float y;
  color _color;
  int _width;
  int _height;
  
  // constructor
  BrushShape() {
    this.x = 0;
    this.y = 0;
    this._color = color(255, 0, 0, 100);
    this._width = 25;
    this._height = 25;
  }
  
  // methods
  void display() {
    if(hand_x == this.x && hand_y == this.y) {
      this._color = currentDrawingColor;
    }
    fill(this._color);
    ellipse(this.x, this.y, this._width, this._height);
  }
}
