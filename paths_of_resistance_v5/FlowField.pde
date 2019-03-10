class FlowField {
 
    PVector[][] field;
    int cols, rows;
    int resolution;
    
    FlowField() {
       resolution = 10;
       cols = width/resolution;
       rows = height/resolution;
       
       field = new PVector[cols][rows];
       init();
    }
       
       void init() {
         float xoff = 0;
         for (int i = 0; i < cols; i++) {
            float yoff = 0;
            for (int j = 0; j < rows; j++) {
              float theta = map(noise(xoff, yoff), 0, 1, 0, TWO_PI);
              field[i][j] = new PVector(cos(theta), sin(theta));
              yoff += 0.1;
            }  //j
         xoff += 0.1;
         }//i    
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
   
}
