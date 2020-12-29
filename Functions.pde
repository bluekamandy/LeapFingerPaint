void drawTarget(float x, float y) {
  strokeWeight(1);
  stroke(0);
  ellipse(x, y, 50, 50);
  line(x-10, y, x+10, y);
  line(x, y-10, x, y+10);
}

void currentColorTriangle(float x, float y) {
  int size = 100;
  noStroke();
  fill(currentColor);
  triangle(x, y, x+size, y, x, y+size);

  shadow(x, y+size+50, x+size+50, y, 20, 1);
}

void shadow(float x1, float y1, float x2, float y2, int stTransp, int direction) {
  float startingTransparency = stTransp;
  int shadowLength = 50;
  float alphaDecrement = startingTransparency / shadowLength;

  if (direction == -1) {
    float currentTransparency = startingTransparency;
    for (int j = shadowLength; j > 0; j--) {
      stroke(0, currentTransparency);
      line(x1, j+y1-shadowLength, x2, j+y2-shadowLength);
      currentTransparency = currentTransparency - alphaDecrement;
    }
  } else if (direction == 1) {
        float currentTransparency = startingTransparency;
    for (int j = 0; j < shadowLength; j++) {
      stroke(0, currentTransparency);
      line(x1, j+y1-shadowLength, x2, j+y2-shadowLength);
      currentTransparency = currentTransparency - alphaDecrement;
    }
  }
}
