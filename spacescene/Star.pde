class Star {
  
  float x;
  float y;
  float z;
  
  Star() {
    x = random(-width, width);
    y = random(-height, height);
    z = random(width);
  }      

void show() {
  
  float sx = map(x / z, 0, 1, 0, width);
  float sy = map(y / z, 0, 1, 0, height);
  
  float r = map(z, 0, width, 3, 1);
  ellipse(sx, sy, r, r);
 }
 
void pulsate() {
  float fillPulsate = random(128,256);
  fill(fillPulsate);
  noStroke();
  }
 
}
