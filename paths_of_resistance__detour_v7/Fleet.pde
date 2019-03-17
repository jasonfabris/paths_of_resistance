
ArrayList<Vehicle> vehicles;
float num_v;
boolean least;

class Fleet {
  
  Fleet(boolean _least) {
    vehicles = new ArrayList<Vehicle>();
    least = _least;
  }
  
  void add_vehicles(float _num_v) {
       //vehicle starts
    num_v = _num_v;
    for (int i = 0; i < num_v; i++) {
        
      float lx = random(30, width - 30);
      float ly = random(30, height - 30);
    
      PVector l = new PVector(lx, ly);
    
      vehicles.add(new Vehicle(l, least));
      //println(l.x, l.y, " add v at");
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
          //println(vehicles.indexOf(v));
          v.choose_grid(fld);
       }
  }//choose grid
}
