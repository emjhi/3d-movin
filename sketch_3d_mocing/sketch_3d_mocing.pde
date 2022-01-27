boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ;
float leftRightHeadAngle, upDownHeadAngle;
PImage amethyst;
PImage slime;
PImage shroom;
boolean skipFrame;

import java.awt.Robot;

Robot rbt;

color black = #000000;
color white = #FFFFFF;
color blue = #7092BE;

int gridSize;
PImage map;

void setup() {
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);

  wkey = akey = skey = dkey = false;

  eyeX = width/2;
  eyeY = 9*height/11;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  tiltX = 0;
  tiltY = 1;
  tiltZ = 0;

  leftRightHeadAngle = radians(270);
  noCursor();

  //map = loadImage("New Piskel (1).png");
  map = loadImage("map.png");

  gridSize = 100;

  shroom = loadImage("shroom.png");
  slime = loadImage("slime.png");
  amethyst = loadImage("Block_of_Amethyst_(texture)_JE3_BE1.png");
  textureMode(NORMAL);

  try { 
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  skipFrame = false;
}


void draw() {
  background(0);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ);
  drawFloor();
  drawFocalPoint();
  controlCamera();
  drawMap();
  pointLight(255, 255, 255, eyeX, eyeY, eyeZ);
}


void drawFloor() {
  stroke(255);

  //  for (int x = -2000; x <= 2000; x += 100) {
  //    //line(x, height, -2000, x, height, 2000);
  //    //line(-2000, height, x, 2000, height, x);
  //    texturedCube(x, height, x, shroom, gridSize);
  //  }

  //  for (int x = -2000; x <= 2000; x += 100) {
  //   //line(x, height-gridSize*3, -2000, x, height-gridSize*3, 2000);
  //   //line(-2000, height-gridSize*3, x, 2000, height-gridSize*3, x);
  //    texturedCube(x, height-gridSize*4, x, shroom, gridSize);
  //  }

  int z = -2000;
  int x = -2000;
  while (z < 2000) {
    texturedCube(x, height, z, shroom, gridSize);
    texturedCube(x, height-gridSize*4, z, shroom, gridSize);
    x += gridSize;
    if (x >= 2000) {
      x = -2000;
      z += gridSize;
    }
  }
}

void controlCamera() {
  if (wkey) {
    eyeX += cos(leftRightHeadAngle)*10;
    eyeZ += sin(leftRightHeadAngle)*10;
  }

  if (skey) {
    eyeX -= cos(leftRightHeadAngle)*10;
    eyeZ -= sin(leftRightHeadAngle)*10;
  }

  if (dkey) {
    eyeX -= cos(leftRightHeadAngle - PI/2)*10;
    eyeZ -= sin(leftRightHeadAngle - PI/2)*10;
  }

  if (akey) {
    eyeX -= cos(leftRightHeadAngle + PI/2)*10;
    eyeZ -= sin(leftRightHeadAngle + PI/2)*10;
  }

  if (skipFrame == false) {
    leftRightHeadAngle += (mouseX - pmouseX)*0.01;
    upDownHeadAngle += (mouseY - pmouseY)*0.01;
  }

  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;

  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;


  if (mouseX > width-2) {
    rbt.mouseMove(2, mouseY);
    skipFrame = true;
  } else if (mouseX < 2) {
    rbt.mouseMove(width-2, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == blue) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, amethyst, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, amethyst, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, amethyst, gridSize);
      }
      if (c == black) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, slime, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, slime, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, slime, gridSize);
      }
    }
  }
}

void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
}


void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
}
