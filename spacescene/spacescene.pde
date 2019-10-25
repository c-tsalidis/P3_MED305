Star [] myStars = new Star [1200];
Brush myBrush = new Brush();

void setup() {
  size(displayWidth, displayHeight);
  smooth();
  frameRate(70);
  
  for (int i = 0; i < myStars.length; i++) {
    myStars[i] = new Star();
  }  
}

void draw() {
  
  background(#161616); 
  translate(width/2, height/2);
  for (int i = 0; i < myStars.length; i++) {
    myStars[i].show();
    myStars[i].pulsate();
  }
  
  myBrush.drawWithBrush();
  
  
  
  
    
}
