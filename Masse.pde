class Masse{
  PVector x;
  PVector v;
  PVector f;
  float m;
  public boolean fixe = false;
  
  Masse(){}
  
  Masse(PVector a, float d){
    x = a;
    v = new PVector(0,0,0);
    f = new PVector(0,0,0);
    m = d;
  }
  
  void setForce(PVector force){
    if(!fixe){
      f = force;
    }
  }
  
}
