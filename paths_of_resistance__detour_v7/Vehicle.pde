class Vehicle {
 
  PVector loc;
  PVector old_loc;
  PVector acc;
  PVector vel;
  
  float max_speed;
  float max_frc;
  float mass;
  float targ_pull; //how attractive is the target?
  
  boolean least_most; //easy or hard path? true = least = easy

Vehicle(PVector _loc, boolean _least) {
   loc = _loc.copy();
   vel = new PVector(0,0);
   acc = new PVector(0,0);
   mass = random(30, 275);
   max_speed = mass/1000;
   max_frc = mass / 2;
   targ_pull = random(1.5, 2.5);
   least_most = _least;
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
void choose_grid(FlowField flow) {
 
  PVector tmp_vel = vel.copy();
  PVector tmp_loc = loc.copy();
  PVector incumbent_frc = new PVector();
  
  //what is the location we'll end up in if changing the heading? look 60 frames ahead
  //TODO implement better prediction
  PVector new_loc = PVector.add(tmp_loc, PVector.mult(tmp_vel, 20));
  
  incumbent_frc = flow.lookup(new_loc);
  PVector incumbent_frc_steer = PVector.sub(incumbent_frc, tmp_vel);
  PVector incumbent_vel = PVector.add(tmp_vel, incumbent_frc_steer);
  PVector incumbent_loc = PVector.add(tmp_loc, incumbent_vel);
  
  stroke(43,40,90,4);
  line(incumbent_loc.x, incumbent_loc.y, target.x, target.y);
  
 
  //get heading
  float head = tmp_vel.heading();
  //get the grid cells in the 120 deg field of view in front of the vehicle
  for (float i = head - PI/3; i < head + PI/3; i += 0.15) {
    
     PVector sightline = PVector.add(tmp_loc, new PVector(200 * tmp_vel.mag() * cos(i), 200 * tmp_vel.mag() * sin(i)));
     //get the fld strength at sightline
     PVector opt_frc = flow.lookup(sightline);
     
     // need to add current vel, plus option grid force
          
           //PVector option = flow.lookup(sightline);
           //PVector impact = PVector.sub(target, option);
           //PVector impact_incumbent = PVector.sub(target, incumbent_frc);
           
           //PVector new_dist = PVector.add(vel, option);
           //new_dist = PVector.sub(target, new_dist);
     
     //stroke(180, 100, 100, 5);
     //line(sightline.x, sightline.y, impact.x, impact.y);
     //stroke(180, 100, 100, 5);
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
  
}

void update() {
   old_loc = loc.copy();
   
   vel.add(acc);
   loc.add(vel);
   acc.mult(0);
}


boolean has_arrived(PVector destination) {
     
    if (loc.dist(destination) < 60) {
       vel.x = lerp(vel.x, 0, .8);
       vel.y = lerp(vel.y, 0, .8);
    }
  
    return loc.dist(destination) < 3;
    
    
}

void display() {
     
    stroke(110, 44, 30+(mass/10), 7);
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
