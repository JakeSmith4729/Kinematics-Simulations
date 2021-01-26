import java.util.ArrayList;

// 1 m = 100 px
float dt, last, now;  // Time-based variables
float g = 980;        // acceleration of gravity
float mx,my;          // mouse tracking variables
ArrayList<Ball> balls = new ArrayList<Ball>(); // arraylist for balls

// Class for ball objects
class Ball {
  int rad = 40;                      // ball radius
  float xpos, ypos;                  // positions      
  float xvel, yvel;                  // velocities  
  float xpos_proj, ypos_proj;        // position projections
  
  // constructor
  Ball(float ixpos, float iypos, float ixvel, float iyvel){
    xpos = ixpos;
    ypos = iypos;
    xvel = ixvel;
    yvel = iyvel;
  }
  
  // project ball position for next frame
  void project(){
    xpos_proj = xpos + (xvel * dt);
    ypos_proj = ypos + (0.5*g*sq(dt)) + (yvel*dt);
  }
  
  // test for collisions and move ball 
  void move(){
    float t_contact;
    float yvel_rebound;
    
    // check right wall
    if(xpos_proj + rad > width){
      xpos = (2*width) - xpos_proj - (2*rad);
      xvel *= -1;
    }
    // check left wall
    else if(xpos_proj - rad < 0){
      xpos = (2*rad) - xpos_proj;
      xvel *= -1;
    }
    // without collision, move ball to its projected x-position
    else{
      xpos = xpos_proj;
    }
  
    // check bottom wall
    if(ypos_proj + rad > height){
      t_contact = (-yvel + sqrt(sq(yvel)+(2*g*(height-ypos-rad))))/g;
      yvel_rebound = -(yvel+(g*t_contact));
      ypos = height - rad + (0.5 * g * sq((dt-t_contact))) + (yvel_rebound*(dt - t_contact));
      yvel = yvel_rebound + (g*(dt-t_contact));
    }
    // check top wall
    else if(ypos_proj- rad < 0){
      t_contact = (-yvel - sqrt(sq(yvel)+(2*g*(ypos-rad))))/-g;
      yvel_rebound = -(yvel+(g*t_contact));
      ypos = 0 + rad + (0.5 * g * sq((dt-t_contact))) + (yvel_rebound*(dt - t_contact));
      yvel = yvel_rebound + (g*(dt-t_contact));
    }
    // without collision, move ball to its projected y-position
    else{
      ypos = ypos_proj;
      yvel = yvel + (g*dt);
    }
  }
  // draw ball
  void create(){
     fill(200+100*sin(0.001*millis()),200+100*sin(0.005*millis()), 200+100*sin(0.003*millis())); // changing color
     ellipse(xpos, ypos, rad,rad); // draw ball
  }
}

// setup window
void setup() 
{
  last = millis();
  size(1000, 800);
  frameRate(100);
  noStroke();
  ellipseMode(RADIUS);
}

// when mouse pressed and dragged, create new ball with velcity proportional to the drag length
void mousePressed(){
  mx = mouseX;
  my = mouseY;
}
void mouseReleased(){
  balls.add(new Ball(mx,my,2000*(mx-mouseX)/width,2000*(my-mouseY)/height));
}
  
void draw() 
{
  // Draw background
  fill(0);
  rect(0,0,width,height);
  
  // get time difference from last frame
  now = millis();
  dt = (now - last) * 0.001;
  last = millis();

  // check each ball for wall collisions, then move
  for (int i = 0; i < balls.size(); i++){
    balls.get(i).project();
    balls.get(i).move();
    balls.get(i).create();
  }
  // draw line showing mouse drag
  if (mousePressed == true){
    stroke(225);
    line(mx,my,mouseX,mouseY);
  }
}


  
