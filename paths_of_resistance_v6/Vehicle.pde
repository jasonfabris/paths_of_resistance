class Vehicle {
 
  PVector loc;
  PVector old_loc;
  PVector acc;
  PVector vel;
  
  float max_speed;
  float max_frc;
  float mass;
  float targ_pull; //how attractive is the target?


Vehicle(PVector _loc) {
   loc = _loc.copy();
   vel = new PVector(0,0);
   acc = new PVector(0,0);
   mass = random(30, 275);
   max_speed = mass/1000;
   max_frc = mass / 2;
   targ_pull = random(1.5, 2.5);
}

void apply_force(PVector frc) {
  PVector f = PVector.div(frc, mass); 
  acc.add(f);
}

//find the goal
void seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    desired.mult(targ_pull);
    
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
  int[] incumbent;
  
  //get heading
  float head = vel.heading();
  
  //which cell are we in?
  int[] cur_cell = flow.lookup_idx(loc);
  //println("cell: ", cur_cell[0], cur_cell[1]);
  
  //how fast are we going?
  //println("Vel:", vel.mag());
  
  //what is the cell we'd end up in if changing the heading?
  //look 60 frames ahead
  //TODO implement better prediction
  incumbent = flow.lookup_idx(PVector.add(loc, new PVector(60 * vel.mag() * cos(head), 60 * vel.mag() * sin(head))));
  PVector incumbent_frc = flow.field[incumbent[0]][incumbent[1]].copy();
      
  //get the grid cells in the 120 deg field of view in front of the vehicle
  for (float i = head - PI/3; i < head + PI/3; i += 0.07) {
       
     PVector sightline = PVector.add(loc, new PVector(60 * vel.mag() * cos(i), 60 * vel.mag() * sin(i)));
     //println("idx: ", cur_cell[0], cur_cell[1], degrees(head), degrees(i), cos(i), sin(i));
     
     //stroke(20, 100, 100, 5);
     //line(loc.x, loc.y, sightline.x, sightline.y);
     //circle(loc.x, loc.y, 20);
     
     //get the fld strength at sightline 
     
     /// need to add current vel, plus option grid force
          
     PVector option = flow.lookup(sightline);
     PVector impact = PVector.sub(target, option);
     PVector impact_incumbent = PVector.sub(target, incumbent_frc);
     
     PVector new_dist = PVector.add(vel, option);
     new_dist = PVector.sub(target, new_dist);
     
     
     //stroke(180, 100, 100, 5);
     //line(sightline.x, sightline.y, impact.x, impact.y);
     stroke(180, 100, 100, 5);
     //line(incumbent_frc.x, incumbent_frc.y, impact_incumbent.x, impact_incumbent.y);
     
     noFill();
     //stroke(50, 100,100,5);
     //circle(sightline.x, sightline.y, 20);
     stroke(360, 100, 100, 5);
     //line(loc.x, loc.y, new_dist.x, new_dist.y);
     
     noStroke();
     //line(incumbent_frc.x, incumbent_frc.y, impact_incumbent.x, impact_incumbent.y);
     //line(loc.x, loc.y, new_dist.x, new_dist.y);
     
}
  
  //for each of those grid cells 
   // PVector incumbent = flow.field[0][0].copy();
    
    //PVector desired = 
    
    
    //PVector steer = PVector.sub(desired, vel);
    //steer.limit(max_frc);
  
  
  
}

void update() {
   old_loc = loc.copy();
   
   vel.add(acc);
   loc.add(vel);
   acc.mult(0);
}


boolean has_arrived(PVector destination) {
     
    if (loc.dist(destination) < 60) {
       vel.mult(0.8); 
    }
  
    return loc.dist(destination) < 5;
    
    
}

void display() {
     
    stroke(189, 44, 30+(mass/10), 7);
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
