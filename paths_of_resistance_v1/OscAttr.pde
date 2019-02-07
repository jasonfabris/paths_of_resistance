class OscAttr {
  
  float amp;  ///max amplitude
  float period; //rotations
  float r;
  
  float loc_x;
  float loc_y;
  
  OscAttr() {
      
    loc_x = width/2;
    loc_y = height/2;
    amp = 100;
    period = 60; // every 2 seconds?
  
  }
  
  void display() {
    r = amp * cos(period/frameCount);
    
    stroke(10, 100, 100, 100);
    ellipse(loc_x, loc_y, r, r);
    
    float r_old = amp * cos(period/(frameCount-1));
    stroke(235, 15, 100, 100);
    ellipse(loc_x, loc_y, r_old, r_old);
    
    
  }
  
}
