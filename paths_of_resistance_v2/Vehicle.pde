class Vehicle {
 
  PVector loc;
  PVector acc;
  PVector vel;
  
  float max_speed;
  float max_frc;
  float mass;


Vehicle(PVector _loc) {
   loc = _loc.copy();
   vel = new PVector(0,0);
   acc = new PVector(0,0);
   mass = random(250);
   max_speed = mass/1000;
   max_frc = mass / 2;
}

void seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    
    PVector steer = PVector.sub(desired, vel);
    steer.limit(max_frc);
    apply_force(steer);
}

void apply_force(PVector frc) {
  PVector f = PVector.div(frc, mass); 
  acc.add(f);
}

void update() {
   vel.add(acc);
   loc.add(vel);
   acc.mult(0);
}

void display() {
   fill(100 + mass, 75, 30+(mass/10), 50);
   noStroke();
   ellipse(loc.x, loc.y, 1, 1);
   
}

}//class
