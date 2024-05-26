float[] xBalles, yBalles;
float[] vitessesX, vitessesY;
float[] m;
int nombreDeBalles = 16;
float vitesseX = 1;
float vitesseY = 1;
color[] couleursBoules;
boolean afficherBaton = true;

final float billardLargeur = 2.54;
final float billardHauteur = 1.27;
final float ratio = billardLargeur / billardHauteur;
final float diametreBalle = 57. / 1000;

final float height = 900, width = height * ratio;
final float hauteur = height * 0.8, largeur = hauteur * ratio;
final float scale = hauteur / billardHauteur;

final float dt = 0.001;

float trouX = 0.038 * billardLargeur;
float trouY =trouX;

float[] lines = new float[]{
  -billardLargeur / 2 + trouX, billardHauteur / 2, - trouX , billardHauteur / 2,
  -billardLargeur / 2, billardHauteur / 2 + trouY, -billardLargeur / 2 + trouX, billardHauteur / 2,
  -billardLargeur / 2, billardHauteur / 2 + trouY, -billardLargeur / 2 - trouX, billardHauteur / 2,
  -billardLargeur / 2, billardHauteur / 2 - trouY, -billardLargeur / 2 - trouX, billardHauteur / 2,
  
   trouX, billardHauteur / 2, billardLargeur / 2 - trouX, billardHauteur / 2,
  -trouX, billardHauteur / 2, -trouX, billardHauteur / 2 + trouY,
  -trouX, billardHauteur / 2 + trouY, trouX, billardHauteur / 2 + trouY,
   trouX, billardHauteur / 2 + trouY, trouX, billardHauteur / 2,
   
  -billardLargeur / 2 + trouX, -billardHauteur / 2, - trouX, -billardHauteur / 2,
  -billardLargeur / 2, -billardHauteur / 2 + trouY, -billardLargeur / 2 - trouX, -billardHauteur / 2,
  -billardLargeur / 2, -billardHauteur / 2 - trouY, -billardLargeur / 2 + trouX, -billardHauteur / 2,
  -billardLargeur / 2, -billardHauteur / 2 - trouY, -billardLargeur / 2 - trouX, -billardHauteur / 2,
   
   trouX, -billardHauteur / 2, billardLargeur / 2 - trouX, -billardHauteur / 2,
  -trouX, -billardHauteur / 2, -trouX, -billardHauteur / 2 - trouY,
  -trouX, -billardHauteur / 2 - trouY, trouX, -billardHauteur / 2 - trouY,
   trouX, -billardHauteur / 2 - trouY, trouX, -billardHauteur / 2,
   
  -billardLargeur / 2, -billardHauteur / 2 + trouY, -billardLargeur / 2, billardHauteur / 2 - trouY,
  billardLargeur / 2, billardHauteur / 2 + trouY, billardLargeur / 2 + trouX, billardHauteur / 2,
  billardLargeur / 2, billardHauteur / 2 + trouY, billardLargeur / 2 - trouX, billardHauteur / 2,
  billardLargeur / 2, billardHauteur / 2 - trouY, billardLargeur / 2 + trouX, billardHauteur / 2,
  
  billardLargeur / 2, -billardHauteur / 2 + trouY, billardLargeur / 2, billardHauteur / 2 - trouY,
  billardLargeur / 2, -billardHauteur / 2 + trouY, billardLargeur / 2 + trouX, -billardHauteur / 2,
  billardLargeur / 2, -billardHauteur / 2 - trouY, billardLargeur / 2 + trouX, -billardHauteur / 2,
  billardLargeur / 2, -billardHauteur / 2 - trouY, billardLargeur / 2 - trouX, -billardHauteur / 2,
};

float queueLongueur = 1;
float queueEpaisseur = 8;
float queueX, queueY;
float queueDirectionX = 1;
float angleQueue = 0;

float[] collision(float r, float cx,float cy,float p1x, float p1y, float p2x, float p2y){
  float ex=(p2x-p1x);float ey=(p2y-p1y);
  float norme=sqrt(ex*ex+ey*ey);
  ex/=norme;ey/=norme;
  float nx=ey,ny=-ex;
  float Ox=(p1x+p2x)/2,Oy=(p1y+p2y)/2;
  float Cx=cx-Ox,Cy=cy-Oy;
  float Cxloc=ps(Cx,Cy,ex,ey);
  float Cyloc=ps(Cx,Cy,nx,ny);
  float l=distance(p1x,p1y,p2x,p2y)/2;
  if (abs(Cyloc)<r) {
    if(abs(Cxloc)<l)
    //if (true)
    {
      if(Cyloc>0) return new float[] {nx,ny};
      if(Cyloc<0) return new float[] {-nx,-ny};
    }
    else
    {
      float d1=distance(p1x,p1y,cx,cy);
      float d2=distance(p2x,p2y,cx,cy);
      if(d1<r) return new float[] {(cx-p1x)/d1,(cy-p1y)/d1};
      if(d2<r) return new float[] {(cx-p2x)/d2,(cy-p2y)/d2};
    }
  }
  return null;
}

void settings() {
  size((int) width, (int) height);
}

void setup() {
  xBalles = new float[nombreDeBalles];
  yBalles = new float[nombreDeBalles];
  vitessesX = new float[nombreDeBalles];
  vitessesY = new float[nombreDeBalles];
  couleursBoules = new color[nombreDeBalles];
  m = new float[nombreDeBalles];

  couleursBoules[0] = color(255);
  couleursBoules[1] = color(255, 0, 0);
  couleursBoules[2] = color(255, 165, 0);
  couleursBoules[3] = color(255, 0, 0);
  couleursBoules[4] = color(255, 0, 0);
  couleursBoules[5] = color(0, 0, 0);
  couleursBoules[6] = color(255, 165, 0);
  couleursBoules[7] = color(255, 165, 0);
  couleursBoules[8] = color(255, 0, 0);
  couleursBoules[9] = color(255, 165, 0);
  couleursBoules[10] = color(255, 0, 0);
  couleursBoules[11] = color(255, 0, 0);
  couleursBoules[12] = color(255, 165, 0);
  couleursBoules[13] = color(255, 165, 0);
  couleursBoules[14] = color(255, 0, 0);
  couleursBoules[15] = color(255, 165, 0);

  xBalles[0] = 0 - billardLargeur / 3;
  yBalles[0] = 0;
  vitessesX[0] = 0;
  vitessesY[0] = 0;
  m[0] = 1;

  float vx = sqrt(3) / 2, vy = -0.5;
  vx *= diametreBalle * (1. + 2. / 1000); vy *= diametreBalle * (1. + 2. / 1000);
  int i = 0;
  for (int j = 0; j < 5; j++)
    for (int k = 0; k < j + 1; k++) {
      i++;
      xBalles[i] = j * vx + random(-1, 1) * diametreBalle / 1000;
      yBalles[i] = j * vy + k * diametreBalle + random(-1, 1) * diametreBalle / 1000;
      vitessesX[i] = 0;
      vitessesY[i] = 0;
      m[i] = 1;
    }

  queueX = xBalles[0] - queueLongueur;
  queueY = yBalles[0] - queueLongueur;
}

void draw() {
  //arrière plan et terrain
  background(255);
  translate(width / 2, height / 2);
  scale(1, -1);
  noStroke();
  fill(10, 150, 10);
  rect(-largeur / 2, -hauteur / 2, largeur, hauteur);

//bordure terrain
  stroke(0);
  strokeWeight(5);
  for (int i = 0; i < lines.length / 4; i++) {
    line(lines[4 * i]*scale, lines[4 * i + 1]*scale, lines[4 * i + 2]*scale, lines[4 * i + 3]*scale);
  }
  strokeWeight(1);

//gestion affichage baton
  if (afficherBaton) {
    pushMatrix();
    translate(queueX * scale, queueY * scale);
    rotate(angleQueue);
    strokeWeight(queueEpaisseur);
    line(0, 0, queueLongueur * queueDirectionX * scale, 0);
    popMatrix();
    strokeWeight(1);
  }

//créer les boules
  for (int i = 0; i < nombreDeBalles; i++) {
    appliquerForceFrottement(i);
    fill(couleursBoules[i]);
    ellipse(xBalles[i] * scale, yBalles[i] * scale, diametreBalle * scale, diametreBalle * scale);
  }

//collision mur
for (int i = 0; i < nombreDeBalles; i++) 
    for (int k = 0; k < lines.length / 4; k++) {
      float[] N=collision(diametreBalle/2,xBalles[i], yBalles[i],lines[4 * k], lines[4 * k + 1], lines[4 * k + 2], lines[4 * k + 3]);
      if(N!=null){
        float pv = 2 * ps(vitessesX[i], vitessesY[i], N[0], N[1]);
         if (pv < 0) {
          vitessesX[i] = vitessesX[i] - pv * N[0];
          vitessesY[i] = vitessesY[i] - pv * N[1];
        }
      }
  }
  
//collision boules
  for (int i = 0; i < nombreDeBalles; i++) {
    for (int k = 0; k < i; k++) {
      gestionCollision(i, k);
    }
  }

  updateQueuePosition();
  canPlay();

  for (int i = 0; i < nombreDeBalles; i++) {
    xBalles[i] += dt * vitessesX[i];
    yBalles[i] += dt * vitessesY[i];
  }
}

void gestionCollision(int indexBalle1, int indexBalle2) {
  float distanceEntreBalles = distance(xBalles[indexBalle1], yBalles[indexBalle1], xBalles[indexBalle2], yBalles[indexBalle2]);
  float rayonTotal = diametreBalle / 2 + diametreBalle / 2;

  if (distanceEntreBalles < rayonTotal) {
    float eX = xBalles[indexBalle2] - xBalles[indexBalle1];
    float eY = yBalles[indexBalle2] - yBalles[indexBalle1];
    float norme = sqrt(sq(eX) + sq(eY));
    eX /= norme;
    eY /= norme;
    float dvX = vitessesX[indexBalle2] - vitessesX[indexBalle1];
    float dvY = vitessesY[indexBalle2] - vitessesY[indexBalle1];

    float P = -2 * m[indexBalle1] * m[indexBalle2] / (m[indexBalle1] + m[indexBalle2]) * (dvX * eX + dvY * eY);
    if (P > 0) {
      vitessesX[indexBalle1] -= P * eX / m[indexBalle1];
      vitessesY[indexBalle1] -= P * eY / m[indexBalle1];
      vitessesX[indexBalle2] += P * eX / m[indexBalle2];
      vitessesY[indexBalle2] += P * eY / m[indexBalle2];
    }
  }
}

//produit scalaire
float ps(float a, float b, float c, float d) {
  return a * c + b * d;
}

float distance(float x1, float y1, float x2, float y2) {
  return dist(x1, y1, x2, y2);
}

void updateQueuePosition() {
  queueX = xBalles[0] - queueLongueur * cos(angleQueue);
  queueY = yBalles[0] - queueLongueur * sin(angleQueue);
}

void propulserBouleBlanche() {
  float vitesseQueue = 20;
  vitessesX[0] = vitesseQueue * cos(angleQueue) * queueDirectionX;
  vitessesY[0] = vitesseQueue * sin(angleQueue); 
}

void appliquerForceFrottement(int indexBalle) {
  float coefficientFrottement = 0.995;

  vitessesX[indexBalle] *= coefficientFrottement;
  vitessesY[indexBalle] *= coefficientFrottement;
}

void canPlay() {
  rotate(PI);
  fill(0);
  textSize(30);
  if (vitessesX[0] <= 0.2 && vitessesY[0] <= 0.2) {
    text("!!!!!!!", (-width / 2.2), (-height / 2.2));
  } else {
    text("", 0, (-height / 2.2));
  }
}


void keyPressed() {
  if (keyCode == LEFT) {
    angleQueue -= radians(1);
  } else if (keyCode == RIGHT) {
    angleQueue += radians(1);
  } else if (keyCode == DOWN) {
    if (vitessesX[0] <= 0.2 && vitessesY[0] <= 0.2) {
      afficherBaton = !afficherBaton;
    }
  } else if (keyCode == UP) {
    if (vitessesX[0] <= 0.2 && vitessesY[0] <= 0.2 && afficherBaton == true) {
      afficherBaton = !afficherBaton;
      propulserBouleBlanche();
    }  
  }
}
