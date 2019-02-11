
ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
PVector target;
OscAttr osc1;

float num_v = 66;
String fname;

void setup() {
   
 // fname = String.format("C:/Users/Jason/Documents/Processing Projects/Output/happy_wanderersv1_%d%d%d%d%d.tif", year(), month(), day(), hour(), minute(), second());//

  colorMode(HSB, 360, 100, 100, 100);
  size(3200,3200);
  
  for (int i = 0; i < num_v; i++) {
    
    PVector l = new PVector(random(width), random(height));
    
    vehicles.add(new Vehicle(l));
  }
  
  background(215, 8, 97);
  
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
      t = vehicles.get(vehicles.size() - 1);
    } else if (i % 9 == 0) {
      ////println(i, i % 9);
      t = vehicles.get(vehicles.size() - 2);
    } else { 
      t = vehicles.get(i - 1);
    }
    
    
    
    target = t.loc.copy();
    
    v.apply_force(wind);
        
    PVector attr_frc = osc1.attract(v);
    v.apply_force(attr_frc);
    
    v.seek(target);
    
    if (v.loc.dist(t.loc) < 15) {
      v.apply_force(new PVector(random(-5, 5), random(-5, 5)));
    }
    
    
    v.update();
    v.display();
  }
  
  target.x += randomGaussian() * 10;
  target.y += randomGaussian() * 10;
  //println(target.x, target.y);
  
 //save every so often
  if (frameCount % 7200 == 0) {
     save(fname); 
  } 
}
