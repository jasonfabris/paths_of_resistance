
ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
PVector target;
OscAttr osc1;

float num_v = 37;


void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  size(1200,1200);
  
  for (int i = 0; i < num_v; i++) {
    
    PVector l = new PVector(random(width), random(height));
    
    vehicles.add(new Vehicle(l));
  }
  
  background(235, 15, 100);
  
  target = new PVector(width/2, height/2);
  
  osc1 = new OscAttr();
}


void draw() {
  
  //stroke(300,100,100,100);
  //rect(target.x, target.y, target.x + 100, target.y + 100);
  
  osc1.display();
  
  PVector wind = new PVector(random(-3.25, 3.25), random(-.05, 0.05));
  
  for (int i = 0; i < vehicles.size(); i++) {
    
    Vehicle t;
    Vehicle v = vehicles.get(i);
    
    if (i == 0) {
      t = vehicles.get(vehicles.size() - 1);
    } else if (i % 9 == 0) {
      println(i, i % 9);
      t = vehicles.get(i-3);
    } else { 
      t = vehicles.get(i - 1);
    }
    
    
    
    target = t.loc.copy();
    
    v.apply_force(wind);
    v.seek(target);
    
    if (v.loc.dist(t.loc) < 20) {
      v.apply_force(new PVector(random(30), random(30)));
    }
    
    
    v.update();
    v.display();
  }
  
  target.x += randomGaussian() * 10;
  target.y += randomGaussian() * 10;
  println(target.x, target.y);
}
