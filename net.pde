//net/cloth simulation
//William Primett

//drag over the net to move the points
//KEY CONTROLS:
//  p - show points, j - show netting, m - show mesh, c - show slider controls, 
//  x - rotate back, b - breakable net mode, v - hanging string mode, r - reset net 

//initial values
//net Height and Width
int nh = 56; 
int nw = 80;
float ys = 25;//starting y position

int num_points = 100;
float rest_len = 8; //starting distance of points
float max_len = 35; //max length/stretch of joints before breaking
//element view toggles
boolean show_points = true, show_joints = false, 
  show_mesh = false, show_controls = false, 
  only_vert = false, breakable = false, rot = false;

float rotX = PI/16;

//Point object, what spring attatch to
//Spring objects, controls forces created and functioned within the point object class
ArrayList points;

//custom net parametres for slider control
HScrollbar spacing, str;

void setup() {
  size(1280, 720, P3D);
  // create the net
  //initializes point objects and attatches joints(springs to each according to position
  createNet();
  
  //make control sliders
  spacing = new HScrollbar(0, height-72, width, 16, 16, "spacing( requires reset [r] )");
  str = new HScrollbar(0, height-24, width, 16, 16, "strength");
}

void draw() {
  lights();
  background(255);

  //iteratte through all points
  for (int i = 0; i < points.size (); i++) {
    //run functoin for each point to animate
    Point point = (Point) points.get(i);
    point.draw();
    point.update();
    point.drag(mouseX, mouseY);
    popMatrix();
        
    //extra calculations for mesh measurments
    //compares distance from origional point(displacment)
    point.calcDisplacement();
  }
  //view toggles, see instructions at top for more info
  if(show_mesh){
    makeMesh();
  }
  if (show_controls) {
    controls();
  }
  
  //change initial spring lengths with slider 
  rest_len = int(map(spacing.getPos(), 0, width, 4, 12));
  //changes break sensitivity
  max_len = int(map(str.getPos(), 0, width, 20, 110));
}

void createNet () {
  //new flexible points array
  points = new ArrayList();

  //horizontal middle of net
  int mid = (int) (width/2 - (nw * rest_len)/2);
  //nested loop to create grid of points
  for (int y = 0; y <= nh; y++) { // y looped ouside to link points as points are in 1 dimentional array
    for (int x = 0; x <= nw; x++) { 
        //setting initial position for new point objects and initialzing objects in array
      Point point = new Point(new PVector(mid + x * rest_len, y * rest_len + ys));
      //find top corner points to act as fixed points
      //these can't be dragged by the mouse
      if (x == 0 && y == 0 || x == nw && y == 0){
        point.fix(point.pos);
      }
      //connects points horizontally, can be toggled for string effect
      if(x != 0 && !only_vert){
        point.connect((Point)(points.get(points.size()-1)), rest_len);
      }
      //Points are in one dimentional array
      //next y co ordinate(1 below and above) found use conversion fomula
      // y * width + x 
      if(y != 0){
        point.connect((Point)(points.get((y - 1) * (nw+1) + x)), rest_len);
      }
      // add new points to array  
      points.add(point);
    }
  }
}

//shows and animates sliders from class
void controls(){
  spacing.display();
  spacing.update();
  //TURN ON BREAKABLE MODE [B] TO CHANGE STRENGTH
  if(breakable) {
    str.update();
    str.display();
  }
  
}


void mousePressed() {
  for (int i = 0; i < points.size (); i++) {
      Point point = (Point) points.get(i);
      if (!point.isEdge) {
      //each point takes the mouse position
      //if in range of distance, mouse will drag points in area
      point.clicked(mouseX, mouseY);
    }
  }
}

//stop dragging points when mouse Released
void mouseReleased() {
  for (int i = 0; i < points.size (); i++) {
      Point point = (Point) points.get(i);
      point.stop_dragging();
  }
}

void keyPressed() {
  //displaytoggles
  if (key == 'p') show_points = !show_points;
  if (key == 'j') show_joints = !show_joints;
  if (key == 'm') show_mesh = !show_mesh;
  if (key == 'c') show_controls = !show_controls;
  if (key == 'r') createNet();   //reset points
  if (key == 'x') rot = !rot; //rotate back(x axis)
  if (key == 'b') breakable = !breakable;
   if (key == 'v'){
     only_vert = !only_vert;
     createNet();
   }
}