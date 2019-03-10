import java.util.Iterator;

ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
PVector target;
OscAttr osc1;
FlowField fld;

float num_v = 1500;
String fname;

void setup() {
   
 // fname = String.format("C:/Users/Jason/Documents/Processing Projects/Output/happy_wanderersv1_%d%d%d%d%d.tif", year(), month(), day(), hour(), minute(), second());//

  colorMode(HSB, 360, 100, 100, 100);
  size(1400,1400);
  //frameRate(5);
  float rad = width * 0.4;
  
  //vehicle starts
  for (int i = 0; i < num_v; i++) {
        
    float lx = random(width - 130, width - 110);
    float ly = random(50, height - 50);
    
    PVector l = new PVector(lx, ly);
    
    vehicles.add(new Vehicle(l));
  }
  
  background(180, 1, 98);
  
  target = new PVector(250,height/2);
  
  osc1 = new OscAttr();
  fld = new FlowField();
  
}


void draw() {
  fname = String.format("C:/Users/Jason/Documents/Processing Projects/Output/happy_wanderersv1_%d%d%d%d%d.tif", year(), month(), day(), hour(), minute(), second());
  //stroke(300,100,100,100);
  //rect(target.x, target.y, target.x + 100, target.y + 100);
  
  //background(0,0,100);
  
  //osc1.display();
  fld.init();
  //fld.show_fld();
  
  
  //some random wind
  PVector wind = new PVector(random(-1.25, 1.25), random(-0.025, 0.025));
  
  
   
   Iterator<Vehicle> vit = vehicles.iterator();
   
   while (vit.hasNext()) {
      Vehicle v = vit.next();
      if (v.has_arrived(target)) {
          //reset vehicles that have reached their destination
         vit.remove(); 
      }
      
    //v.apply_force(wind);
    v.choose_grid(fld, true);    
        
    PVector attr_frc = osc1.attract(v);
    v.apply_force(attr_frc);
    
    v.follow(fld);
    v.seek(target);
      
    v.update();
    v.display();
    println(vehicles.size(), " vehicles");
    
   }
   
   //replace vehicles
   while (vehicles.size() < num_v) {
       vehicles.add(new Vehicle(new PVector(random(width), random(height)))); 
    }
    //num_v = num_v * 0.9;
  
  //target.x += randomGaussian() * 10;
  //target.y += randomGaussian() * 10;
  //println(target.x, target.y);
  
 //save every so often
  if (frameCount % 2600 == 0) {
     save(fname); 
  } 
}
