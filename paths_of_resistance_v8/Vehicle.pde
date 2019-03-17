class Vehicle {
 
  PVector loc;
  PVector old_loc;
  PVector acc;
  PVector vel;
  
  float max_speed;
  float max_frc;
  float mass;
  float targ_pull; //how attractive is the target?
  float dist_from_target;
  
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
   //println(least_most);
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
  PVector chosen_path = loc.copy();
  
  //get heading
  float head = tmp_vel.heading();
  //get the grid cells in the 120 deg field of view in front of the vehicle
  
  dist_from_target = PVector.dist(target, tmp_loc);
  
  for (float i = head - PI/3; i < head + PI/3; i += 0.15) {
    
     //PVector sightline = PVector.add(tmp_loc, new PVector(60 * tmp_vel.mag() * cos(i), 60 * tmp_vel.mag() * sin(i)));
     PVector sightline = PVector.add(tmp_loc, new PVector(2*flow.resolution * cos(i), 2*flow.resolution * sin(i))); 
     //get the fld strength at sightline
     PVector path_frc = flow.lookup(sightline);
     //what is the path from sightline to target?
     PVector optim_from_path = PVector.sub(target, sightline);
     
     //what would happen if we went to sightline?
     PVector frc_from_path = PVector.add(sightline, PVector.sub(path_frc, tmp_vel).limit(max_frc));
     PVector act_from_path = PVector.sub(target, frc_from_path);
     
     //fill(360,100,50,20);
     //ellipse(frc_from_path.x, frc_from_path.y, 10, 10);
     
     float diff_from_optim = PVector.sub(optim_from_path, act_from_path).mag();
     float dist_from_target_path = PVector.dist(target, act_from_path);
     //println("Mag: ", diff_from_optim, " Dist: ", dist_from_target);
     
     if(least_most) {
       if(dist_from_target_path < dist_from_target) {
          chosen_path = sightline.copy();
          dist_from_target = dist_from_target_path;
       }
       //println("Changing path - L");
     } else {
       if(dist_from_target_path > dist_from_target) {
          chosen_path = sightline.copy();
          dist_from_target = dist_from_target_path;
       }
       //println("Changing path - M");
     }
         
    } //headings
    seek(chosen_path);
}

void update() {
   old_loc = loc.copy();
   
   vel.add(acc);
   loc.add(vel);
   acc.mult(0);
}


boolean has_arrived(PVector destination) {
     
    if (loc.dist(destination) < 10) {
       vel.x = lerp(vel.x, 0, .9);
       vel.y = lerp(vel.y, 0, .9);
    }
  
    return loc.dist(destination) < 5;
    
    
}

void display() {
     
   if(least_most) {   
      stroke(25, 84, 60, 5);
   } else {
      stroke(300, 94, 60, 5);
   }
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
