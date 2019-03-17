import java.util.Iterator;

PVector target;
OscAttr osc1;
FlowField fld;

Fleet fleet;

float v_count = 120;  //number of vehicles
String fname;

void setup() {
   
 // fname = String.format("C:/Users/Jason/Documents/Processing Projects/Output/happy_wanderersv1_%d%d%d%d%d.tif", year(), month(), day(), hour(), minute(), second());//

  colorMode(HSB, 360, 100, 100, 100);
  size(1400,1400);
  //frameRate(5);
  float rad = width * 0.4;
  
  fleet = new Fleet(true);
  fleet.add_vehicles(v_count);
  println(fleet.get_count(), " 1");
  
  background(180, 1, 98);
  
  target = new PVector(250,height/2);
  
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
        
    fleet.apply_force(wind);
    //fleet.seek_target(target);
    fleet.follow(fld);
    fleet.osc_attract(osc1);
    
    fleet.choose_grid(fld);    
       
    fleet.run();
   
   
    //num_v = num_v * 0.9;
  
  //target.x += randomGaussian() * 10;
  //target.y += randomGaussian() * 10;
  //println(target.x, target.y);
  
 //save every so often
  if (frameCount % 2600 == 0) {
     save(fname); 
  } 
}
