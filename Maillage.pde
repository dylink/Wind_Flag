int oneDCoords(int a, int b, int l){
  return a * l + b;
}

class Maillage{
  ArrayList<Masse> points;
  ArrayList<Ressort> ressorts;
  ArrayList<Triangle> triangles;
  float dt;
  float damp;
  Maillage(int originX, int originY, int originZ, int largeur, int hauteur, int rest, float m, float ks, float kd){
    points = new ArrayList<>();
    ressorts = new ArrayList<>();
    triangles = new ArrayList<>();
    damp = kd;
    for(int i = 0; i< largeur; i++){
      for(int j = 0; j<hauteur; j++){
        Masse a = new Masse(new PVector((i*rest)+originX, (j*rest)+originY, originZ), m);
        /*if(j == 0 ){
          a.fixe = true;
        }*/
        if(i == 0 && (j == 0 || j == 1 || j == hauteur-1 || j == hauteur-2)){
          a.fixe = true;
        }
        points.add(a);
      }
    }
    
    
    
    for(int i = 0; i<points.size(); i++){
      int a = i/hauteur;
      int b = i%hauteur;
      
      Masse m1 = null, m2 = null, m3 = null, m4 = null;
      if(points.get(i).x.x + rest < (largeur*rest)+originX){
        
        int x = oneDCoords(a+1, b, hauteur);
        m1 = points.get(x);
        Ressort r = new Ressort(points.get(i), points.get(x), ks, rest);
        ressorts.add(r);
      }
      if(points.get(i).x.y+rest < (hauteur*rest)+originY){
        int x = oneDCoords(a, b+1, hauteur);
        m2 = points.get(x);
        Ressort r = new Ressort(points.get(i), points.get(x), ks, rest);
        ressorts.add(r);
      }
      if(points.get(i).x.x +rest < (largeur*rest) + originX && points.get(i).x.y +rest < (hauteur*rest) + originY){
        int x = oneDCoords(a+1, b, hauteur);
        int x1 = oneDCoords(a, b+1, hauteur);
        m3 = points.get(x);
        Ressort r = new Ressort(points.get(x), points.get(x1), ks-(ks*0.5), (rest)*sqrt(2));
        ressorts.add(r);
      }
      /*if(points.get(i).x.x > originX && points.get(i).x.y +rest < (hauteur*rest) + originY){
        int x = oneDCoords(a-1, b+1, hauteur);
        m4 = points.get(x);
        Ressort r = new Ressort(points.get(i), points.get(x), ks-(ks*0.5), (rest-5)*sqrt(2));
        ressorts.add(r);
      }*/
      
      if(m1 != null && m2 != null){
        triangles.add(new Triangle(points.get(i), m1, m2));
        if(m3 != null){
          triangles.add(new Triangle(m1, m3, m2));
        }
      }
      
    }
    
  }
  
  void update(float d, float wind){
    dt = d;
    
    forces(wind);
    euler();
  }
  
  PVector genereVent(){
    PVector vent = new PVector(0,0,0);
    float vx = 8.0;
    float vz = 0;
    
    vx += random(-2, 2);
    vz += random(-1,1);
    
    vx = vx < 2 ? 2 : vx;
    vx = vx > 5 ? 5 : vx;
    
    vz = vz < -3 ? -3 : vz;
    vz = vz > 3 ? 3 : vz;
    
    vent = new PVector(vx, 0, vz);
    return vent;
  }
  
  void forces(float wind){
    PVector gravite = new PVector(0,9.8,0);
    
    for(int i = 0; i<points.size(); i++){
      points.get(i).setForce(PVector.mult(gravite, points.get(i).m));
      points.get(i).f.add(PVector.mult(points.get(i).v, -damp));
    }
    
    for(int i = 0; i<ressorts.size();i++){
      float k = ressorts.get(i).ks;
      float l = PVector.sub(ressorts.get(i).p2.x, ressorts.get(i).p1.x).mag();
      PVector vnorm = PVector.sub(ressorts.get(i).p2.x, ressorts.get(i).p1.x).normalize();
      
      float ksf = k*(l-ressorts.get(i).s);
      
      PVector f = PVector.mult(vnorm, ksf);
      
      
      ressorts.get(i).p1.setForce(PVector.add(ressorts.get(i).p1.f, f));
      ressorts.get(i).p2.setForce(PVector.add(ressorts.get(i).p2.f, f.mult(-1)));
    }
    
    for(int i = 0; i<triangles.size(); i++){
      PVector frict;
      PVector n;
      PVector surf;
      PVector v1, v2;
      
      PVector vent = genereVent().mult(wind);
      
      
      v1 = PVector.sub(triangles.get(i).m2.x, triangles.get(i).m1.x);
      v2 = PVector.sub(triangles.get(i).m3.x, triangles.get(i).m2.x);
      
      n = v1.copy().cross(v2).normalize();
      
      surf = PVector.div(PVector.add(PVector.add(triangles.get(i).m1.v, triangles.get(i).m2.v), triangles.get(i).m3.v), 3);
      frict = PVector.div(PVector.mult(n, PVector.dot(n, PVector.sub(vent, surf))), 3);
      
      
      triangles.get(i).m1.setForce(PVector.add(triangles.get(i).m1.f, frict));
      triangles.get(i).m2.setForce(PVector.add(triangles.get(i).m2.f, frict));
      triangles.get(i).m3.setForce(PVector.add(triangles.get(i).m3.f, frict));
    }
    
  }
  
  void euler(){
    for(int i = 0; i<points.size(); i++){
      if(!points.get(i).fixe){
        points.get(i).v.add(PVector.mult(PVector.div(points.get(i).f, points.get(i).m), dt));
        points.get(i).x.add(PVector.mult(points.get(i).v, dt));
      }
      
    }
  }
  
}
