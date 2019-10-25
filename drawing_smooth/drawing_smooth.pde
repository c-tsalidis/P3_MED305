float x;
float y;
float x2;
float y2;

float easing = 0.3;
float diameter = 20;

void setup() {
  size(displayWidth, displayHeight);
  smooth();
  frameRate(70);
  
  background(255);
  noStroke();
}

void draw() {
  float targetX = mouseX;
  float dx = (mouseX-x) * easing;
  float targetY = mouseY;
  float dy = (mouseY-y) * easing;
  
  float t;
  float cx;
  float cy;
  float steps;
  

  if (mousePressed) {
     x2 = x + dx;
     y2 = y + dy;

    // Draw additional circles between frames for smooth brushstrokes
    steps = 80;
    for (int i = 0; i <= steps; i += 1) {
      t = i/steps;
      cx = lerp(x, x2, t); //get fractional x positions
      cy = lerp(y, y2, t); //get fractional y positions
      
      pushMatrix();
      translate (cx, cy);
      
      //Draw lines
      fill(100);
      ellipse(-(diameter/2), -(diameter/2), diameter, diameter);
      popMatrix();
    }

    x = x2;
    y = y2;
    
  } else {
    
    x = targetX;
    y = targetY;
    
  }
  
  clearCanvas();
}


void clearCanvas() {
  if (keyCode == UP) {
    background(255);
  }
}
