/*

 Leap Motion Experiment
 
 by MASOOD
 
 Initiated 12/24/2020
 Last Modified 12/25/2020
 
 Source:
   Highly modified, but adapted from https://github.com/nok/leap-motion-processing/blob/master/examples/e1_basic/e1_basic.pde
   and from http://www.wekinator.org/examples/#Leap_Motion_hardware_sensor
   The OSC outlets are not used, but remain just in case... so it could still be used with Wekinator.
 
 */

import de.voidplus.leapmotion.*;

import oscP5.*;
import netP5.*;

ArrayList<DrawingShape> shapes;

float smoothing = 0.1;

float fingerX;
float fingerY;
float fingerZ;

float fingerXsmooth;
float fingerYsmooth;
float fingerZsmooth;

int paletteY;

ColorButton[] colorButtons;

Boolean drawing = false;
Boolean touching = false;

color currentColor;
color backgroundColor;

int currentThickness;  

int num=0;

OscP5 oscP5;
NetAddress dest;
LeapMotion leap;

int numFound = 0;

float[] features = new float[15];

void setup() {

  size(1000, 1000, P3D);
  currentColor = color(0);
  backgroundColor = color(255);
  //hint(ENABLE_DEPTH_SORT);
  int index = 0;

  colorButtons = new ColorButton[5];

  for (int i = 0; i < colorButtons.length; i++) {
    colorButtons[i] = new ColorButton(
      color(random(255), random(255), random(255)), width/5/2+i*width*.2, height-height*.1);
    colorButtons[i].detectTouch(fingerX, fingerY, touching);
  }

  shapes = new ArrayList<DrawingShape>();

  // ...

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1", 6448);

  leap = new LeapMotion(this).allowGestures();
  sendInputNames();
}

void draw() {

  if (fingerZ > 65) {
    touching = true;
  } else {
    touching = false;
  }

  background(backgroundColor);

  drawTarget(fingerX, fingerY);

  for (DrawingShape shape : shapes) {
    shape.drawShape();
  }

  //println("fingerX: " + fingerX);
  //println("fingerY: " + fingerY);
  //println("touching: " + touching);

  currentColorTriangle(0, 0);
  shadow(0, height-height*.2, width, height-height*.2, 25, -1);

  for (ColorButton cb : colorButtons) {
    cb.display();
    if (cb.detectTouch(fingerX, fingerY, touching)) {

      currentColor = cb.c;

      println("fingerX: " + fingerX);
      println("fingerY: " + fingerY);
      println("touching: " + touching);
    }
  }

  // ========= HANDS =========
  numFound = 0;
  for (Hand hand : leap.getHands ()) {
    numFound++;
  }

  // HANDS 
  for (Hand hand : leap.getHands()) {

    // hand.draw();
    int     hand_id          = hand.getId();
    PVector hand_position    = hand.getPosition();
    PVector hand_stabilized  = hand.getStabilizedPosition();
    PVector hand_direction   = hand.getDirection();
    PVector hand_dynamics    = hand.getDynamics();
    float   hand_roll        = hand.getRoll();
    float   hand_pitch       = hand.getPitch();
    float   hand_yaw         = hand.getYaw();
    float   hand_time        = hand.getTimeVisible();
    PVector sphere_position  = hand.getSpherePosition();
    float   sphere_radius    = hand.getSphereRadius();

    //println("-----"+hand_stabilized);

    if (true) {

      // FINGERS
      for (Finger finger : hand.getFingers()) {

        // Basics
        strokeWeight(10);
        finger.drawBones();
        int     finger_id         = finger.getId();
        PVector finger_position   = finger.getPosition();
        PVector finger_stabilized = finger.getStabilizedPosition();
        PVector finger_velocity   = finger.getVelocity();
        PVector finger_direction  = finger.getDirection();
        float   finger_time       = finger.getTimeVisible();

        //println(finger_position.x); //x
        //println(finger_id);

        if (((finger_id % 5) == 1) && drawing) {
          int index = shapes.size() - 1; 
          if (shapes.get(index).points.size() == 0) {
            fingerX = finger_position.x;
            fingerY = finger_position.y;
            fingerZ = finger_position.z;
          } else {
            fingerX = lerp(fingerX, finger_position.x, smoothing);
            fingerY = lerp(fingerY, finger_position.y, smoothing);
            fingerZ = lerp(fingerZ, finger_position.z, smoothing);
          }
          PVector smoothed = new PVector(fingerX, fingerY);
          shapes.get(shapes.size()-1).addPoint(smoothed);
        } else if (finger_id % 5 == 1) {
          fingerX = lerp(fingerX, finger_position.x, smoothing);
          fingerY = lerp(fingerY, finger_position.y, smoothing);
          fingerZ = lerp(fingerZ, finger_position.z, smoothing);
        }
      }
    }
  }

  // =========== OSC ============
  if (num % 3 == 0) {
    sendOsc();
  }
  num++;
}

// ========= CALLBACKS =========

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}

// ======================================================
// 4. Key Tap Gesture

void leapOnKeyTapGesture(KeyTapGesture g) {
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector position         = g.getPosition();
  PVector direction        = g.getDirection();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();

  println("KeyTapGesture: " + id);

  touching = true;
}

//====== OSC SEND ======
void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  if (numFound > 0) {
    for (int i = 0; i < features.length; i++) {
      msg.add(features[i]);
    }
  } else {
    for (int i = 0; i < features.length; i++) {
      msg.add(0.);
    }
  }
  oscP5.send(msg, dest);
}

void sendInputNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setInputNames");
  String[] fingerNames = {"thumb", "index", "middle", "ring", "pinky"};
  String coordinates[] = {"_x", "_y", "_z"};
  int n = 0;
  for (int i = 0; i < fingerNames.length; i++) {
    for (int j = 0; j< coordinates.length; j++) {
      msg.add(fingerNames[i] + coordinates[j]); 
      n++;
    }
  }
  oscP5.send(msg, dest); 
  println("Sent finger names" + n);
}

void keyPressed() {
  if (key == ' ') {
    DrawingShape shape = new DrawingShape();
    shape.c = currentColor;
    shapes.add(shape);
    drawing = !drawing;
  }
  if (key == 'z') {

    if (drawing) {
      drawing = false;
    }
    int index = shapes.size() - 1; 
    if (index >= 0) {
      shapes.remove(index);
    } else {
      println("Screen Clear");
    }
  }
  if (key == 'c') {
    shapes = new ArrayList<DrawingShape>();
  }
  if (key == 'r') {
    for (ColorButton cb : colorButtons) {
      cb.randomizeColor();
    }
  }
  if (key == 'b') {
    backgroundColor = currentColor;
  }
  if (key == 's') {
    saveFrame("output/frames####.png");
  }
  
  if (key == '1') {
    
  }
}
