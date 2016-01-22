//ADDITIONAL MESH MODE
void makeMesh(){
  noStroke();
  fill(122, 20);
  pushMatrix();
  if(rot){
      rotateX(rotX);
  }
  //trangle strip mode, polygon formed for each part of the mesh for blinds effect
  beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < points.size() - 1; i++) {
      Point point = (Point) points.get(i);
      //join up vertecies of all points
      //z coordinate of vertex depends on displacement of origional position
      //give depth to mesh and highlights most dragged points
       vertex(point.pos.x, point.pos.y, point.dis);
    }
  endShape();
  popMatrix();
}