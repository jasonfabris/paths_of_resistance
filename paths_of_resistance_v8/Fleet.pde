
class Fleet {
  ArrayList<Vehicle> vehicles;
  float num_v;
  boolean least;

Fleet(boolean _least, float _num_v) {
    vehicles = new ArrayList<Vehicle>();
    least = _least;
     num_v = _num_v;
  }
  
  void add_vehicles() {
       //vehicle starts
   
    for (int i = 0; i < num_v; i++) {
      
      float lx = 0;
      //half on each side
      if(i % 2 == 0 ) {
        lx = random(width - 130, width - 110);
      } else {
        lx = random(110, 130);
      }
      
      float ly = random(50, height - 50);
    
      PVector l = new PVector(lx, ly);
    
      vehicles.add(new Vehicle(l, least));
      println("Add v at", l.x, l.y, least);
    } 
    
  } //add vehicles
  
  float get_count() {
     return vehicles.size(); 
  }
  
  void run() {
     Iterator<Vehicle> vit = vehicles.iterator();
   
     while (vit.hasNext()) {
        Vehicle v = vit.next();
        if (v.has_arrived(target)) {
          //reset vehicles that have reached their destination
           vit.remove(); 
        }
      v.update();
      v.display();
      //println(vehicles.size(), " vehicles");
    
   }
   
   //replace vehicles
   while (vehicles.size() < num_v) {
       vehicles.add(new Vehicle(new PVector(random(width), random(height)), least)); 
    } 
  }
  
  void apply_force(PVector frc) {
      for (Vehicle v: vehicles) {
        //println(frc.x, frc.y);
        v.apply_force(frc);
      }
  } // apply frc
  
  void seek_target(PVector t) {
       for (Vehicle v: vehicles) {
          v.seek(t);
       }
  } //seek target
  
  void follow(FlowField flow) {
    for (Vehicle v: vehicles) {
          v.follow(flow);
       }
  }
  
  void osc_attract(OscAttr osc) {
    for (Vehicle v: vehicles) {
          PVector attr_frc = osc.attract(v);
          v.apply_force(attr_frc);
       }
  }
  
  void choose_grid(FlowField fld) {
    for (Vehicle v: vehicles) {
          v.choose_grid(fld);
       }
  }//choose grid
}
