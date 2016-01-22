class Joint {
  PVector pos;
  float rest_len;
  float k = 0.082;

  Point pt1;
  Point pt2;
  
  //contructor takes exsisting points and initial length distance
  Joint(Point _pt1, Point _pt2, float _rl) {
    pt1 = _pt1;
    pt2 = _pt2;
    rest_len = _rl;
  }
  //spring forces
  void update() {
    //distance between two anchors using direction vector and magnitude
    //find distance between current displacement and resting position
    PVector dir = PVector.sub(pt1.pos, pt2.pos);
    float dist = dir.mag();
    float dispos = dist - rest_len;
    //using Hooke's law: force = -k * x
    //where k is a constant and x is the displacement 
    dir.normalize();
    dir.mult(-k * dispos);
    pt1.applySpring(dir);
    //force of second anchor works in opposite direction
    dir.mult(-1);
    pt2.applySpring(dir);
    
    //when stretch to far, join will rip and disappear
    //breakable mode needs to be on, use b key to toggle
    if (dist > max_len && breakable){
      pt1.breakOff(this);
      pt2.breakOff(this);
    }
    
  }   
  //draw line between points
  void draw() {
    strokeWeight(1);
    stroke(0);
    line(pt1.pos.x, pt1.pos.y, pt2.pos.x, pt2.pos.y);
  }
}