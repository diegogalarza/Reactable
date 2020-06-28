/* #########################################
#     PONTIFICIA UNIVERSIDAD JAVERIANA     #
#          INTERACCION Y SONIDO            #
#         PROF: GERARDO M. SARRIA          #
#           PROYECTO - REACTABLE           #
#    DIEGO F. GALARZA - VICTOR M. OSPINA   #
############################################*/
import oscP5.*;
import netP5.*;
import TUIO.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
TuioProcessing tuio;

//COORDS, ANGLES & COLORS FOR EACH AMOEBA DETECTED
int curr_amoeba;
int amoeba1; int amoeba2; int amoeba3; int amoeba4; int amoeba5;
int x_pos1; int y_pos1; int x_pos2; int y_pos2;
int x_pos3; int y_pos3; int x_pos4; int y_pos4;
int x_pos5; int y_pos5;
float angle1; float angle2; float angle3; float angle4; float angle5;
float c; color blue = color(0,247,255); color red = color(255, 0, 0);
color orange = color(255, 167, 100); color yellow = color(245, 255, 0);
int flag1 = 0; int flag2 = 0; int flag3 = 0; 
int flag4 = 0; int flag5 = 0;

//VALUES FOR 'LOOPER' TO FLOW EVENLY
int rotB_size = 10;                           //ROTATION
float xoff = 0.0; float xincrement = 0.01;    //FLOW

//VALUES FOR 'PITCH TEMPO' CONTROL
float min_angle; float max_angle = 360;       //STARDARD
float curr_angle; float factor = (1/6.28)*360;//ROTATION

//VALUES FOR WAVE BETWEEN AMOEBAS
float wave_freq = 4; float wave_amp = 10;     //FREQUENCY & AMPLITUDE
float dist1; float dist2; float dist3; float dist4;

//OSC ADDRESS AND PORT
int port; String ip;

//SIMPLE SETUP FUNCTION
void setup(){
  size(1200, 900);
  background(0);
  frameRate(120);
  colorMode(HSB, 360, 100, 100);
  port = 8001;
  ip = "127.0.0.1";
  oscP5 = new OscP5(this, port);
  myRemoteLocation = new NetAddress(ip, port);
  tuio = new TuioProcessing(this);
  
}

//LOCATING AN AMOEBA USING SOME GIVEN X,Y POSITION
void amoeba_location(int x_pos, int y_pos, int a_color){
  noFill();
  ellipse(x_pos, y_pos, 20, 20);
  rot_ball(x_pos, y_pos, a_color);
}

//ROTATING BALL AROUND AMOEBA A.K.A 'LOOPER'
void rot_ball(int valx, int valy, int val_color){
  pushMatrix();
  translate(valx, valy);
  rotate(radians(frameCount*15)); //FASTER LOOPING AT *29
  fill(0, 20);
  rect(0,0,70,70);
  xoff += xincrement;
  fill(val_color);
  ellipse(50, 50,rotB_size,rotB_size);
  popMatrix();
}

//PITCH-TEMPO CONTROL FUNCTION
void pitch_tempo(int x_pos, int y_pos, float angle){
  float start_angle = angle; min_angle = 0;
  if (min_angle - start_angle <= max_angle){
    min_angle = angle;
  }
  fill(118, 100, 100); //ELECTRIC GREEN
  noStroke();
  rect(x_pos-120, y_pos+50, 10,(-1)*(map(angle, 0, 360, 0, 100)));
  noFill();
}

//WAVE CONNECTION BETWEEN AMOEBAS
void wave_connection(int tmpX1, int tmpY1, int tmpX2, int tmpY2, float wave_freq, float wave_amp){
  float dist_bt_amoebas = sqrt(pow((tmpX2-tmpX1),2)+pow((tmpY2-tmpY1),2));
  float arctan = atan2(tmpY2-tmpY1,tmpX2-tmpX1);
  noFill();
  pushMatrix();
  stroke(255);
  translate(tmpX1,tmpY1);
  rotate(arctan);
  beginShape();
  for(float i = 0; i <= dist_bt_amoebas; i += 1) {
    vertex(i,sin(i*TWO_PI*wave_freq/dist_bt_amoebas+(frameCount/9))*wave_amp);
  }
  endShape();
  popMatrix();
}

//TUIO AMOEBA DETECTION
void addTuioObject(TuioObject tobj){
  curr_amoeba = tobj.getSymbolID();
  if (curr_amoeba == 1){
    flag1 = 1; int play1 = 1;
    OscMessage input_amoeba1 = new OscMessage("/input1");
    input_amoeba1.add(play1);
    oscP5.send(input_amoeba1, myRemoteLocation);
  }
  if (tobj.getSymbolID() == 3){
    flag2 = 1; int play2 = 3;
    OscMessage input_amoeba2 = new OscMessage("/input2");
    input_amoeba2.add(play2);
    oscP5.send(input_amoeba2, myRemoteLocation);
  }
  if (tobj.getSymbolID() == 7){
    flag3 = 1; int play3 = 7;
    OscMessage input_amoeba3 = new OscMessage("/input3");
    input_amoeba3.add(play3);
    oscP5.send(input_amoeba3, myRemoteLocation);
  }
  if (tobj.getSymbolID() == 9){
    flag4 = 1; int play4 = 9;
    OscMessage input_amoeba4 = new OscMessage("/input4");
    input_amoeba4.add(play4);
    oscP5.send(input_amoeba4, myRemoteLocation);
  }
  if (tobj.getSymbolID() == 0){
    flag5 = 1; int play5 = 0;
    OscMessage input_amoeba5 = new OscMessage("/input5");
    input_amoeba5.add(play5);
    oscP5.send(input_amoeba5, myRemoteLocation);
  }
}

//TUIO AMOEBA UPDATE COORDS, ANGLE, ID
//CHECKS FOR EXISTING AMOEBAS ON THE CANVAS
void updateTuioObject(TuioObject tobj){
  curr_amoeba = tobj.getSymbolID();
  if (tobj.getSymbolID() == 1){
    amoeba1 = 1;
    x_pos1 = int(tobj.getX()*width);
    y_pos1 = int(tobj.getY()*height);
    angle1 = tobj.getAngle()*factor;
    flag1 = 1;
  }
  if (tobj.getSymbolID() == 3){
    amoeba2 = 3;
    x_pos2 = int(tobj.getX()*width);
    y_pos2 = int(tobj.getY()*height);
    angle2 = tobj.getAngle()*factor;
    flag2 = 1;
  }
  if (tobj.getSymbolID() == 7){
    amoeba3 = 7;
    x_pos3 = int(tobj.getX()*width);
    y_pos3 = int(tobj.getY()*height);
    angle3 = tobj.getAngle()*factor;
    flag3 = 1;
  }
  if (tobj.getSymbolID() == 9){
    amoeba4 = 9;
    x_pos4 = int(tobj.getX()*width);
    y_pos4 = int(tobj.getY()*height);
    angle4 = tobj.getAngle()*factor;
    flag4 = 1;
  }
  if (tobj.getSymbolID() == 0){
    amoeba5 = 0;
    x_pos5 = int(tobj.getX()*width);
    y_pos5 = int(tobj.getY()*height);
    angle5 = tobj.getAngle()*factor;
    flag5 = 1;
  }
  //ANGLE CONVERSION
  float ang1 = map(angle1, 0, 360, 0.00441, 0.01);
  float ang2 = map(angle2, 0, 360, 0.00441, 0.01);
  float ang3 = map(angle3, 0, 360, 0.00441, 0.01);
  float ang4 = map(angle4, 0, 360, 0.00441, 0.01);
  float ang5 = map(angle5, 0, 360, 0, 1);
  
  //AMOEBA MESSAGES TO PUREDATA CONNECTION
  if (flag1 == 1){
    OscMessage pos_amoeba1 = new OscMessage("/amoeba1/info1");
    pos_amoeba1.add(ang1);
    oscP5.send(pos_amoeba1, myRemoteLocation);
  }
  if (flag2 == 1){
    OscMessage pos_amoeba2 = new OscMessage("/amoeba2/info2");
    pos_amoeba2.add(ang2);
    oscP5.send(pos_amoeba2, myRemoteLocation);
  }
  if (flag3 == 1){
    OscMessage pos_amoeba3 = new OscMessage("/amoeba3/info3");
    pos_amoeba3.add(ang3);
    oscP5.send(pos_amoeba3, myRemoteLocation);
  }
  if (flag4 == 1){
    OscMessage pos_amoeba4 = new OscMessage("/amoeba4/info4");
    pos_amoeba4.add(ang4);
    oscP5.send(pos_amoeba4, myRemoteLocation);
  }
  if (flag5 == 1){
    OscMessage pos_amoeba5 = new OscMessage("/amoeba5/info5");
    pos_amoeba5.add(ang5);
    oscP5.send(pos_amoeba5, myRemoteLocation);
  }
}

//DRAW EVERYTHING OVER THE CANVAS
void draw(){
  noStroke();
  smooth();
  //RAINBOW COLOR GENERATOR
  if (c >= 255)  c=0;  else  c++;
  color rainbow = color(c, 255, 255);
  
  //BEAT 1 AMOEBA
  if(x_pos1 >=100 && x_pos1<width-100){
    amoeba_location(x_pos1, y_pos1, blue);
    pitch_tempo(x_pos1, y_pos1, angle1);
  }
  //BEAT 2 AMOEBA
  if(x_pos2 >=100 && x_pos2<width-100){
    amoeba_location(x_pos2, y_pos2, orange);
    pitch_tempo(x_pos2, y_pos2, angle2);
  }
  //BEAT 3 AMOEBA
  if(x_pos3 >=100 && x_pos3<width-100){
    amoeba_location(x_pos3, y_pos3, yellow);
    pitch_tempo(x_pos3, y_pos3, angle3);
  }
  //BEAT 4 AMOEBA
  if(x_pos4 >=100 && x_pos4<width-100){
    amoeba_location(x_pos4, y_pos4, red);
    pitch_tempo(x_pos4, y_pos4, angle4);
  }
  //VOLUME CONTROL AMOEBA 5
  if(x_pos5 >= (width/2)-100 && x_pos5<(width/2)+100){
    amoeba_location(x_pos5, y_pos5, rainbow);
  }
  
  //DIST BETWEEN EACH AMOEBA AND ITS CORRESPONDING WAVE CONNECTION
  dist1 = sqrt(pow((x_pos1-x_pos5),2)+pow((y_pos1-y_pos5),2));
  dist2 = sqrt(pow((x_pos2-x_pos5),2)+pow((y_pos2-y_pos5),2));
  dist3 = sqrt(pow((x_pos3-x_pos5),2)+pow((y_pos3-y_pos5),2));
  dist4 = sqrt(pow((x_pos4-x_pos5),2)+pow((y_pos4-y_pos5),2));
  if (dist1 <= 300){ wave_connection(x_pos5, y_pos5, x_pos1, y_pos1, wave_freq,wave_amp); }
  if (dist2 <= 300){ wave_connection(x_pos5, y_pos5, x_pos2, y_pos2, wave_freq,wave_amp); }
  if (dist3 <= 300){ wave_connection(x_pos5, y_pos5, x_pos3, y_pos3, wave_freq,wave_amp); }
  if (dist4 <= 300){ wave_connection(x_pos5, y_pos5, x_pos4, y_pos4, wave_freq,wave_amp); }
 
  //CLEAR BACKGROUND TO MAKE IT LOOK 'SMOOTH'
  fill(0, 20);
  rect(0,0,width*2,height*2);
  xoff += xincrement;
}

//TUIO AMOEBA REMOVAL DETECTION
void removeTuioObject(TuioObject tuioAmoeba){
  curr_amoeba = tuioAmoeba.getSymbolID();
  if (curr_amoeba == 1){
    flag1 = 0;
    OscMessage output_amoeba1 = new OscMessage("/input1_1");
    output_amoeba1.add(flag2);
    println(output_amoeba1.add(flag2));
    oscP5.send(output_amoeba1, myRemoteLocation);
    x_pos1 = -500; y_pos1 = -900;
  }
  if (curr_amoeba == 3){
    flag2 = 0;
    OscMessage output_amoeba2 = new OscMessage("/input2_2");
    output_amoeba2.add(flag2);
    println(output_amoeba2.add(flag2));
    oscP5.send(output_amoeba2, myRemoteLocation);
    x_pos2 = -500; y_pos2 = -900;
  }
  if (curr_amoeba == 7){
    flag3 = 0;
    OscMessage output_amoeba3 = new OscMessage("/input3_3");
    output_amoeba3.add(flag3);
    println(output_amoeba3.add(flag3));
    oscP5.send(output_amoeba3, myRemoteLocation);
    x_pos3 = -500; y_pos3 = -900;
  }
  if (curr_amoeba == 9){
    flag4 = 0;
    OscMessage output_amoeba4 = new OscMessage("/input4_4");
    output_amoeba4.add(flag4);
    println(output_amoeba4.add(flag4));
    oscP5.send(output_amoeba4, myRemoteLocation);
    x_pos4 = -500; y_pos4 = -900;
  }
  if (curr_amoeba == 0){
    flag5 = 0;
    OscMessage output_amoeba5 = new OscMessage("/input5_5");
    output_amoeba5.add(flag5);
    println(output_amoeba5.add(flag5));
    oscP5.send(output_amoeba5, myRemoteLocation);
    x_pos5 = -500; y_pos5 = -900;
  }
}
