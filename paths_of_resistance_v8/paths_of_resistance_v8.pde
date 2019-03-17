import java.util.Iterator;

PVector target;
OscAttr osc1;
FlowField fld;

ArrayList<Fleet> fleets;

float v_count = 800;  //number of vehicles
String fname;

void setup() {
   
 // fname = String.format("C:/Users/Jason/Documents/Processing Projects/Output/happy_wanderersv1_%d%d%d%d%d.tif", year(), month(), day(), hour(), minute(), second());//

  colorMode(HSB, 360, 100, 100, 100);
  size(1400,1400);
  //frameRate(5);
  float rad = width * 0.4;
  
  fleets = new ArrayList<Fleet>();
  fleets.add(new Fleet(true, v_count));
  fleets.add(new Fleet(false, v_count));
  
  for(Fleet f: fleets) { 
    f.add_vehicles();
  }
  
  for(Fleet f: fleets) {
    println(f.get_count());
  }
  background(180, 1, 98);
  
  target = new PVector(width/2,height/2);
  
  osc1 = new OscAttr();
  fld = new FlowField();
  
  
}


void draw() {
  fname = String.format("C:/Users/Jason/Documents/Processing Projects/Output/happy_wanderersv1_%d%d%d%d%d.tif", year(), month(), day(), hour(), minute(), second());
  
  //background(0,0,100);

  //osc1.display();
  fld.init();
  //fld.show_fld();
  
   //some random wind
    PVector wind = new PVector(random(-1.25, 1.25), random(-0.025, 0.025));
    
    for(Fleet f: fleets) {    
      f.apply_force(wind);
      f.seek_target(target);
      f.follow(fld);
      f.osc_attract(osc1);
      f.choose_grid(fld);    
       
      f.run();
    }
   
    //num_v = num_v * 0.9;
  
  target.x += randomGaussian() * 10;
  target.y += randomGaussian() * 10;
  //println(target.x, target.y);
  
 //save every so often
  if (frameCount % 1000 == 0) {
     save(fname); 
  } 
}
