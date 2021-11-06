Maillage m;
float t = 0.1;
PImage img;
int flagW = 20, flagH = 15;
float ks = 150, damp = 0.9, mass = 3;
int originX = 100, originY = 20, originZ = -50, restLength = 15, windForce = 80, str = 0, texId = 0;
boolean wind = false, drawTex = true;
StringList path;
float cameraRotateX;
float cameraRotateY;
float cameraSpeed;
PVector speed;


void setup(){
  size(600, 600, P3D);
  
  m = new Maillage(0, 0, 0, flagW, flagH, restLength, mass, ks, damp);
  img = loadImage("Portugal.png");
  path = new StringList();
  path.append("Portugal.png");
  path.append("Corse.png");
  path.append("OuterWilds.png");
  
  cameraSpeed = TWO_PI / width;
  cameraRotateY = -PI/6;
  speed = new PVector();  
  
}

void draw(){

  background(143);
  lights();
  textFont(createFont("Arial",11,true));
  textAlign(LEFT);
  text("Caméra : ",30,30) ;
      text("Souris : rotation",115,30) ;
      
  text("Texture : ",30,60) ;
      text("j / k : Précédente / Suivante",115,60) ;
      text("t :Afficher / Masquer",115,75) ;
  
  text("Maillage : ",30,105) ;
      text("m : Afficher / Masquer",115,105) ;
      
  text("Vent : ",30,135) ;
      text("w : Activer / Désactiver",115,135);
      text("+ / - : Augmenter / Diminuer",115,150);
      
  textAlign(RIGHT);
  text("Force du vent : " + Integer.toString(windForce), 500, 30);
  
  translate(width/2, originY, originZ);
  
  stroke(0);
  
  camera_rotation();
  
  noFill();
  
  textureMode(NORMAL);
  strokeWeight(str);
  for(int j = 0; j<flagH-1;j++){
    beginShape(TRIANGLE_STRIP);
    if(drawTex) texture(img);
    for(int i = 0; i<flagW; i++){
      int x1 = (i * flagH + j);
      int x2 = (i * flagH + (j+1));
      float u = map(i, 0, flagW-1,0,1);
      float v1 = map(j, 0, flagH-1, 0,1);
      float v2 = map(j+1,0,flagH-1,0,1);
      vertex(m.points.get(x1).x.x, m.points.get(x1).x.y, m.points.get(x1).x.z, u, v1);
      vertex(m.points.get(x2).x.x, m.points.get(x2).x.y, m.points.get(x2).x.z, u, v2);
    }
    endShape();
  }
  
  strokeWeight(5);
  line(0, 0, 0, 0, 360, 0);
  
  m.update(t, wind?windForce:0);
}

void keyPressed(){
  if(key == 'w') wind = !wind;
  if(key == 'm') str = str == 0 ? 1 : 0;
  if(key == 't') drawTex = !drawTex;
  if(key == 'k'){
    texId = (texId+1)%path.size();
    img = loadImage(path.get(texId));
  }
  if(key == 'j'){
    texId = texId > 0 ? texId-1 : path.size()-1;
    img = loadImage(path.get(texId));
  }
  if(key == '+'){ System.out.println("Oui"); windForce += 10;}
  if(key == '-') windForce -= 10;
}

void mouseDragged(){
    cameraRotateX += (mouseX - pmouseX) * cameraSpeed;
    cameraRotateY += (pmouseY - mouseY) * cameraSpeed;
    cameraRotateY = constrain(cameraRotateY, -HALF_PI, 0); 
 }

/* Source : https://discourse.processing.org/t/camera-rotation-in-3d-using-mouse/20563*/
 void camera_rotation(){
    rotateY(cameraRotateX);
    pushMatrix();
    for(Masse p : m.points){
      translate(p.x.x, height/2 + p.x.y, p.x.z);
    }
    for(int j=0; j<flagW-1; j++)
       for(int i=0; i<flagH-1; i++)
          
    rotateY(atan2(speed.x, speed.y));
    popMatrix();
 }
