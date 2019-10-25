class Brush {

float x, y;
float easing = 0.2;
float diameter = 30;
float angle = 0.0;
color white = color(255);

float targetX = mouseX;
float dx = (targetX-x) * easing;
float targetY = mouseY;
float dy = (targetY-y) * easing;
float d = dist(x, y, mouseX, mouseY);

float cx;
float cy;

void drawWithBrush() {
  
  if (mousePressed) {
    float x2 = x + dx;
    float y2 = y + dy;
 
  
    //smoothen up drawing lines w/linear interpolation
    float steps = 30;
    
    for (int i = 0; i <= steps; i += 1) {
      float t = i/steps;
      cx = lerp(x, x2, t); //get fractional x positions
      cy = lerp(y, y2, t); //get fractional y positions
      
      //pushMatrix();
      translate(cx,cy);
      
      ellipse(-(diameter/2),-(diameter/2),diameter,diameter);
      
      //popMatrix();
    }
    
    x = x2;
    y = y2;
    
  }
}
  


}
