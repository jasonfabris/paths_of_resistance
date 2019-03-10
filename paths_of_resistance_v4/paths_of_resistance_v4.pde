
ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
PVector target;
OscAttr osc1;

float num_v = 136;
String fname;

void setup() {
   
 // fname = String.format("C:/Users/Jason/Documents/Processing Projects/Output/happy_wanderersv1_%d%d%d%d%d.tif", year(), month(), day(), hour(), minute(), second());//

  colorMode(HSB, 360, 100, 100, 100);
  size(1400,1400);
  
  float rad = width * 0.4;
  float space = 360 / num_v;
  
  for (int i = 0; i < 360; i+=space) {
        
    //float lx = width/2 + randomGaussian() * 10 + rad * cos(radians(i));
    //float ly = height/2 + randomGaussian() * 10 + rad * sin(radians(i));
    float lx = width/2 + rad * cos(radians(i));
    float ly = height/2 + rad * sin(radians(i));
    
    PVector l = new PVector(lx, ly);
    
    vehicles.add(new Vehicle(l));
  }
  
  background(222, 8, 98);
  
  target = new PVector(width/2, height/2);
  
  osc1 = new OscAttr();
}


void draw() {
  fname = String.format("C:/Users/Jason/Documents/Processing Projects/Output/happy_wanderersv1_%d%d%d%d%d.tif", year(), month(), day(), hour(), minute(), second());
  //stroke(300,100,100,100);
  //rect(target.x, target.y, target.x + 100, target.y + 100);
  
  //osc1.display();
  
  PVector wind = new PVector(random(-1.25, 1.25), random(-0.025, 0.025));
  
  for (int i = 0; i < vehicles.size(); i++) {
    
    Vehicle t;
    Vehicle v = vehicles.get(i);
    
    if (i == 0) {
      //t = vehicles.get(vehicles.size() - 1);
      t = vehicles.get(int(random(vehicles.size())));
      while (t == v) {
        //t = vehicles.get(vehicles.size() - 3);
        t = vehicles.get(int(random(vehicles.size())));
      }
      
      
    } else if (i % 10 == 0) {
      t = vehicles.get(int(random(vehicles.size())));
      while (t == v) {
        //t = vehicles.get(vehicles.size() - 3);
        t = vehicles.get(int(random(vehicles.size())));
      }
      
    } else { 
      t = vehicles.get(max(i - 8, 0));  // play with this (i-1)
    }
    
    
    // random change of heart
    if (random(1) < 0.5) {   //0.001
      float new_t = random(vehicles.size());
      if (floor(new_t) != i) {
        t = vehicles.get(floor(new_t));
        println(i-1, floor(new_t), "!");
      }
    }
    
    target = t.loc.copy();
    
    v.apply_force(wind);
        
    PVector attr_frc = osc1.attract(v);
    v.apply_force(attr_frc);
    
    v.seek(target);
    
    if (v.loc.dist(t.loc) < 10 && frameCount > 1250) {  // 10? 100? 
      v.apply_force(new PVector(v.vel.x * -1, v.vel.y * -1));  // -1 or random 80 or try seek instead of apply_force
      //v.apply_force(v.vel.div(0.5));
    }
    
    v.update();
    v.display();
  }
  
  target.x += randomGaussian() * 10;
  target.y += randomGaussian() * 10;
  //println(target.x, target.y);
  
 //save every so often
  if (frameCount % 2600 == 0) {
     save(fname); 
  } 
}
