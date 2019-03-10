class Vehicle {
 
  PVector loc;
  PVector old_loc;
  PVector acc;
  PVector vel;
  
  float max_speed;
  float max_frc;
  float mass;


Vehicle(PVector _loc) {
   loc = _loc.copy();
   vel = new PVector(0,0);
   acc = new PVector(0,0);
   mass = random(30, 275);
   max_speed = mass/500;
   max_frc = mass / 2;
}

void apply_force(PVector frc) {
  PVector f = PVector.div(frc, mass); 
  acc.add(f);
}

//find the goal
void seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    
    PVector steer = PVector.sub(desired, vel);
    steer.limit(max_frc);
    apply_force(steer);
}


//follow the underlying forces
void follow(FlowField flow) {
   PVector desired = flow.lookup(loc);
   //desired.mult(max_speed);
   
   PVector steer = PVector.sub(desired, vel);
   steer.limit(max_frc);
   apply_force(steer);
}

//choose where to head next
void choose_grid(FlowField flow, boolean max_min) {
   
  max_min = true; //true = least resistance
  
  //get heading
  float head = vel.heading();
  
  //which cell are we in?
  int[] cur_cell = flow.lookup_idx(loc);
  
  
  //get the grid cells in the 120 deg field of view in front of the vehicle
  for (float i = head - PI/3; i < head + PI/3; i += 0.07) {
      
     
     PVector sightline = PVector.add(loc, new PVector(60 * cos(i), 60 * sin(i)));
     println("idx: ", cur_cell[0], cur_cell[1], degrees(head), degrees(i), cos(i), sin(i));
     
     stroke(0, 100, 100, 5);
     line(loc.x, loc.y, sightline.x, sightline.y);
     //circle(loc.x, loc.y, 20);
  }
  
  //for each of those grid cells 
    PVector incumbent = flow.field[0][0].copy();
    
    PVector desired = PVector.sub(target, incumbent);
    
    
    PVector steer = PVector.sub(desired, vel);
    steer.limit(max_frc);
  
  
  
}

void update() {
   old_loc = loc.copy();
   
   vel.add(acc);
   loc.add(vel);
   acc.mult(0);
}


void display() {
     
    stroke(100 + mass, 85, 30+(mass/10), 56);
   //noStroke();
   
   beginShape();
     for (int i = 0; i <= 4; i++) {
        float x = lerp(old_loc.x, loc.x, i/4.0);
        float y = lerp(old_loc.y, loc.y, i/4.0);
       vertex(x, y);
     }
   endShape();
   
   //fill(100 + mass, 75, 30+(mass/10), 5);
   //noStroke();
   
   //ellipse(loc.x, loc.y, 10, 10);
   
}

}//class
