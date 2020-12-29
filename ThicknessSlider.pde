// Not implemented.

class ThicknessSlider {
  
  float x1;
  float y1;
  float x2;
  float y2;
  
  float position;
  
  color sliderHandleColor;
  color trackColor;
  
  ThicknessSlider(float _x1, float _y1, float _x2, float _y2){
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
    
    position = 0;
    
    sliderHandleColor = color(0);
    trackColor = color(127);
  }
  
  void display() {
    stroke(trackColor);
    strokeWeight(2);
    strokeCap(ROUND);
    line(x1, y1, x2, y2);
    
    // Point Slope y = m(x-x1) + y1
    // Slope = rise over run
    float slope = (y2-y1)/(x2-x1);
    
    
    strokeWeight(10);
    //line(position
  }
  
}
