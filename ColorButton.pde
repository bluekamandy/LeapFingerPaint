class ColorButton {

  color c;

  float x;
  float y;
  
  Boolean selected;

  int size = width/5;

  ColorButton(color _c, float _x, float _y) {
    c = _c;
    x = _x;
    y = _y;
  }

  void display() {
    fill(c);
    noStroke();
    rectMode(CENTER);
    rect(x, y, size, size);
    noFill();
  }

  Boolean detectTouch(float tx, float ty, boolean tch) {
    if (tch &&
    tx > x - size/2 &&
    tx < x + size/2 &&
    ty > y - size/2 &&
    ty < y + size/2) {
      println("color tapped");
      return true;
    } else {
      return false;
    }
  }

  void randomizeColor() {
    c = color(random(255), random(255), random(255));
  }
}
