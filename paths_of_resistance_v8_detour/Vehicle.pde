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
  PVector chosen_path;
  
  //get heading
  float head = tmp_vel.heading();
  //get the grid cells in the 120 deg field of view in front of the vehicle
  
  for (float i = head - PI/3; i < head + PI/3; i += 0.15) {
    
     PVector sightline = PVector.add(tmp_loc, new PVector(60 * tmp_vel.mag() * cos(i), 60 * tmp_vel.mag() * sin(i)));
    // stroke(0,100,100,5);
    // line(loc.x, loc.y, sightline.x, sightline.y);
     
     //get the fld strength at sightline
     PVector path_frc = flow.lookup(sightline);
     //what is the path from sightline to target?
     PVector optim_from_path = PVector.sub(target, sightline);
     
     //what would happen if we went to sightline?
     PVector frc_from_path = PVector.add(sightline, PVector.sub(path_frc, tmp_vel).limit(max_frc));
     PVector act_from_path = PVector.sub(target, frc_from_path);
     
     fill(360,100,50,20);
     ellipse(frc_from_path.x, frc_from_path.y, 10, 10);
     
     PVector diff_from_optim = PVector.sub(act_from_path, optim_from_path);
     //println("Mag: ", diff_from_optim);
     
     if(diff_from_optim.mag() < 0) {
        chosen_path = sightline.copy();
        println("Changing path");
     }
     
     //stroke(260,100,100,20);
     //line(tmp_loc.x, tmp_loc.y, act_from_path.x, act_from_path.y);
     //stroke(60,100,100,20);
     //line(tmp_loc.x, tmp_loc.y, optim_from_path.x, optim_from_path.y);
     
     
    } //headings
    //seek(chosen_path);
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
