class Point { 
  PVector pos;
  PVector vel;
  PVector acc;
  PVector fixedPos;
  PVector origin;
  PVector displace;
  
  float dis;
  float size = 2;
  float damping = 0.77;
  float mass = 1;
  
  //mouse drag variables
  PVector mouse_dist;
  boolean is_dragged = false;
  
  boolean showJnts = true; //boolean to display point
  boolean isEdge = false; //boolean true to set edges for mesh vertex
  
  //array for joints
  //only needs to store joints attatched to particualr point object
  ArrayList joints = new ArrayList();

  //Point constructor, setting initial vecotr values
  Point(PVector _pos){
    pos = _pos;
    vel = new PVector(0, 0);
    acc = new PVector(0, 9);
    fixedPos = new PVector(0, 0);
    //save origin point for comparison
    origin = _pos; //separate position variable that isn't altered upon movement
    displace = new PVector(0, 0);
    mouse_dist = new PVector(0, 0);
  }
  
  //standard force calculations to simulate effect of gravity
  //from a neutral state
  void update() {
      if (isEdge){
         pos.set(fixedPos);
      }
    vel.add(acc);
    vel.mult(damping);
    pos.add(vel);
    acc.mult(0);
    showJnts = show_joints;

     for (int i = 0; i < joints.size(); i++) {
        Joint jnt = (Joint) joints.get(i);
        jnt.update();
    }
  }
  
  //Using Newton's law: F = M * A
  //takes force vector
  void applySpring(PVector force) {
    force.div(mass);
    acc.add(force);
  }
  
  //shows connection point as circle
  void draw() {
    color c = color(#134865);
    noStroke();
    fill(c);
    pushMatrix();
    if(rot){
      rotateX(rotX);
    }
    if(show_points){
      ellipse(pos.x, pos.y, size, size);
    }
    if(is_dragged) {
     size = 1; 
    }else{
     size = 2;
     if(isEdge){
        size = 5;
  }
  }
  
  //display connection joints
  if (joints.size() > 0 && showJnts) {
      for (int i = 0; i < joints.size(); i++) {
        Joint jnt = (Joint) joints.get(i);
        jnt.draw();
      }
    }
  }
  
  //remove associated connections as well as the anchors themselves
  void breakOff (Joint jnt) {
    joints.remove(jnt);
    points.remove(this);
  }  
  
  //mouse interaction template from Nature of Code
    void clicked(int mx, int my) {
    float d = dist(mx,my,pos.x,pos.y);
    if (d < size + 12) {
      is_dragged = true;
      mouse_dist.x = pos.x-mx;
      mouse_dist.y = pos.y-my;
    }
  }

  void stop_dragging() {
    is_dragged = false;
  }

  void drag(int mx, int my) {
    if (is_dragged) {
      //move points by distance from mouse to previous position
      pos.x = mx + mouse_dist.x;
      pos.y = my + mouse_dist.y;
    }
  }
  //function to create new joint and passing on selected point object
  //along with resting length and strength
    void connect (Point pt, float rl) {
      Joint jnt = new Joint(this, pt, rl);
      joints.add(jnt);
  }
  //keep point in origional position
  void fix(PVector fp){
      isEdge = true;
      fixedPos.set(fp);
  }
  
  void calcDisplacement(){
    //distance from current position from origional position
    displace = PVector.sub(pos, origin);
    dis = displace.mag();
  }
}