class DrawingShape {
  ArrayList<PVector> points;

  int thickness = 5;
  color c = color(0);

  DrawingShape() {
    points = new ArrayList<PVector>();
  }

  void addPoint(PVector pt) {
    points.add(pt);
  }

  void drawShape() {
    stroke(c);
    strokeWeight(thickness);
    beginShape();
    for (int i = 0; i < points.size(); i++) {
      curveVertex(points.get(i).x, points.get(i).y);
    }
    endShape();
    strokeWeight(1);
  }
  
  void clear() {
    points = new ArrayList<PVector>();
  }
  
  void changeColor(color _c){
    c = _c;
  }
}
