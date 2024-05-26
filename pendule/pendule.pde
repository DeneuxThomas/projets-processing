int numBalls = 5;
Ball[] balls = new Ball[numBalls];
float spacing = 60;
float originY = 200;
float length = 200;

// gestion du temps
float dt = 0.1; // laisser l'interval très faible pour éviter les bugs
float t = 0;

void setup() {
  size(800, 600);
  frameRate(60);
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(width/2 - (numBalls-1)*spacing/2 + spacing*i, originY, 30, length);
  }
  
  // Lift the first ball
  balls[0].angle = -PI/2;
  balls[1].angle = -PI/2;
}

void draw() {
  background(240);

  for (int i = 0; i < numBalls; i++) {
    balls[i].update();
    balls[i].checkCollisions(balls, numBalls); // Vérifier les collisions avec les autres balles
    balls[i].display();
  }
  t += dt; // Mise à jour du temps
}

class Ball {
  float x, y;      
  float angle;     
  float angleSpeed;  
  float angleAccel;  
  float originX, originY;
  float radius;
  float armLength;
  float mass; // Masse de la balle

  Ball(float originX_, float originY_, float r, float l) {
    originX = originX_;
    originY = originY_;
    radius = r;
    armLength = l;
    angle = 0;
    angleSpeed = 0.0;
    mass = PI * r * r; // Calcul de la masse basée sur la densité
  }

  void update() {
    float g = 0.4; // Gravité
    angleAccel = (-g / armLength) * sin(angle);
    angleSpeed += angleAccel; // Mettez à jour la vitesse angulaire
    angle += angleSpeed * dt; // Mettez à jour l'angle
    x = originX + armLength * sin(angle);
    y = originY + armLength * cos(angle);
  }

  void display() {
    fill(127);
    strokeWeight(1);
    line(originX, originY, x, y);
    ellipse(x, y, 2*radius, 2*radius);
  }

  void checkCollisions(Ball[] otherBalls, int numBalls) {
    for (int i = 0; i < numBalls; i++) {
      if (otherBalls[i] != this) {
        float distance = dist(x, y, otherBalls[i].x, otherBalls[i].y);

        if (distance < radius + otherBalls[i].radius) { // Balles en collision
          float thisSpeed = angleSpeed * armLength;
          float otherSpeed = otherBalls[i].angleSpeed * otherBalls[i].armLength;
          if((thisSpeed-otherSpeed)*(x-otherBalls[i].x)<0){

          // Calcul de la nouvelle vitesse après la collision (collision élastique)
          float newThisSpeed = ((mass - otherBalls[i].mass) / (mass + otherBalls[i].mass)) * thisSpeed +
            ((2 * otherBalls[i].mass) / (mass + otherBalls[i].mass)) * otherSpeed;
          float newOtherSpeed = ((2 * mass) / (mass + otherBalls[i].mass)) * thisSpeed +
            ((otherBalls[i].mass - mass) / (mass + otherBalls[i].mass)) * otherSpeed;

          // Mettez à jour les vitesses angulaires
          angleSpeed = newThisSpeed / armLength * dt;
          otherBalls[i].angleSpeed = newOtherSpeed / otherBalls[i].armLength;
        }}
      }
    }
  }
}
