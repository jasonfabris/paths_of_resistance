class FlowField {
 
    PVector[][] field;
    int cols, rows;
    int resolution;
    float fld_strength;
    float fld_turbulence;
    float zoff;
    
    FlowField() {
       resolution = 50;
       fld_turbulence = 0.075;
       fld_strength = 2;
       cols = width/resolution;
       rows = height/resolution;
       zoff = 0;
       
       field = new PVector[cols][rows];
       init();
    }
       
       void init() {
         float xoff = 100;
         for (int i = 0; i < cols; i++) {
            float yoff = 0;
            for (int j = 0; j < rows; j++) {
              float theta = map(noise(xoff, yoff, zoff), 0, 1, 0, TWO_PI);
              field[i][j] = new PVector(cos(theta), sin(theta));
              field[i][j].mult(fld_strength);
              yoff += fld_turbulence;
            }  //j
         xoff += fld_turbulence;
         }//i 
         zoff += 0.01;
         //println(zoff);
       }
      
       
      PVector lookup(PVector _lookup) {
       int column = int(constrain(_lookup.x/resolution, 0, cols-1));
       int row = int(constrain(_lookup.y/resolution, 0, rows-1));
       
       return field[column][row].get();
      }
      
      int[] lookup_idx(PVector _lookup) {
       
       int[] idx = new int[2];
       idx[0] = int(constrain(_lookup.x/resolution, 0, cols-1));
       idx[1] = int(constrain(_lookup.y/resolution, 0, rows-1));
       
       return idx;
      }
      
      void show_fld() {
        for (int i = 0; i < cols; i++) {     
            for (int j = 0; j < rows; j++) {
              PVector linestart = new PVector((resolution/2) + resolution * i, (resolution/2) + resolution * j);
              PVector lineadd = PVector.mult(field[i][j], 20);
              //println(lineadd.x, lineadd.y);
              PVector lineend = PVector.add(linestart, lineadd);
              
              stroke(100,10,50,25);
              noFill();
              line(linestart.x, linestart.y, lineend.x, lineend.y);
              circle(lineend.x, lineend.y, 10);
              //println(field[i][j].x, field[i][j].y);
            }
        }
      }
}
