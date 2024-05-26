float cube1X, cube2X;
float cube1Speed = 1.0; // Vitesse initiale du premier cube
float cube2Speed = 0.0; // Vitesse initiale du deuxième cube
float cube1Mass = 1000000.0; // Masse du premier cube
float cube2Mass = 1.0; // Masse du deuxième cube
float cubeY;
float cubeSize = 400;
float floorY;
float wallX;
float startTime;
float dt=0.15;
int collisionCount = 0; 

void setup() {
  size(1500, 800);
  cube1X = 665;
  cube2X = 1073;
  cubeY = height / 2 - cubeSize / 2;
  floorY = height - (cubeSize / 2);
  wallX = width - 20;
  startTime = millis(); // Enregistrez le temps de départ
}

void draw() {
  background(255);

  // Calculer le temps écoulé depuis le début du programme
  //float elapsedTime = (millis() - startTime) / 10000.0; 

  // Dessiner les cubes
  fill(0, 0, 255);
  rect(cube1X, cubeY, cubeSize, cubeSize);

  fill(255, 0, 0);
  rect(cube2X, cubeY, cubeSize, cubeSize);

  // Dessiner la ligne sous les cubes
  fill(0);
  noStroke();
  rect(wallX, 0, width - wallX, height);

  // Dessiner le mur à droite
  fill(0);
  noStroke();
  rect(0, floorY, width, width);

  float cube1Xn=cube1X;
  float cube2Xn=cube2X;
  
  // Déplacer le premier cube de gauche à droite
  cube1X = cube1X + cube1Speed * dt;
 // Déplacer le deuxième cube de droite à gauche
  cube2X = cube2X + cube2Speed * dt;

  // Vérifier si les deux cubes se chevauchent
  if ((cube1X + cubeSize > cube2X && cube1X < cube2X + cubeSize) && (cube1Speed>cube2Speed)) {
    // Calculer la nouvelle vitesse après la collision
    float newV1 = ((cube1Mass - cube2Mass) * cube1Speed + 2 * cube2Mass * cube2Speed) / (cube1Mass + cube2Mass);
    float newV2 = ((cube2Mass - cube1Mass) * cube2Speed + 2 * cube1Mass * cube1Speed) / (cube1Mass + cube2Mass);

    // Mettre à jour les vitesses des cubes après la collision
    cube1Speed = newV1;
    cube2Speed = newV2;

 
    // Incrémenter le compteur de collisions
    collisionCount++;
  }

 
  // Vérifier si le deuxième cube a atteint le mur de gauche ou la droite
  if (cube2X + cubeSize > wallX) {
    // Inverser la direction du deuxième cube
    cube2Speed *= -1;
    collisionCount++;
  }

// Déplacer le premier cube de gauche à droite
  cube1X = cube1Xn + cube1Speed * dt;
 // Déplacer le deuxième cube de droite à gauche
  cube2X = cube2Xn + cube2Speed * dt;


  // Afficher le nombre de collisions
  fill(0);
  text("Collisions: " + collisionCount, 1300, 120);
  float pi = collisionCount/sqrt(cube1Mass/cube2Mass);
  text("pi=" + pi, 1300, 150);
  textSize(20);
}
