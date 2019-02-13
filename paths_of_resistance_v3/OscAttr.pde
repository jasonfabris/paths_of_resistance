class OscAttr {
  
  float amp;  ///max amplitude
  float period; //rotations
  float r;
  
  float loc_x;
  float loc_y;
  PVector loc;
  
  float strength;
  
  OscAttr() {
      
    loc_x = width/2;
    loc_y = height/2;
    loc = new PVector (loc_x, loc_y);
    amp = 2; //2
    period = 80; // every 2 seconds?
  
  }
  
  PVector attract(Vehicle v) {
      
    PVector frc = PVector.sub(loc, v.loc);
    float distance = frc.mag();
    distance = constrain(distance, .25, 1.25);
    
    frc.normalize();
    strength = get_cur_frc() * (distance * distance);
    frc.mult(strength);
     
    //println("Frc: ", frc.x, frc.y); 
    return frc;
    
  }
  
  float get_cur_frc() {
      strength = amp * cos(TWO_PI * frameCount/period);
      //println("Strength: ", strength);
      return strength;
  }
  
  void display() {
    r = amp * cos(TWO_PI * frameCount/period);
    
    noFill();
    stroke(10, 100, 100, 100);
    ellipse(loc_x, loc_y, r, r);
    
    float r_old = amp * cos(TWO_PI*(frameCount-1)/period);
    noFill();
    stroke(235, 15, 100, 100);
    ellipse(loc_x, loc_y, r_old, r_old);
    
    
  }
  
}
