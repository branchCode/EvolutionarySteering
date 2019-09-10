class Vehical {
  public PVector position;
  public PVector velocity;
  public PVector acceleration;
  public float hp;

  float maxspeed;
  float maxforce;
  float r;    // size
  float[] dna;

  public Vehical(float x, float y, float[] dna_) {
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
    this.hp = 1;
    this.maxspeed = 5;
    this.maxforce = 0.5;
    this.r = 6;
    this.dna = dna_;
  }

  void applyForce(PVector f) {
    acceleration.add(f);      // unit mass
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
    hp -= 0.001;
    if (isDead()) {
      vehs.remove(this);
      if(random(1) < 0.5){
        food.add(position.copy());
      }
      else{
        poison.add(position.copy());
      }
    }
  }

  boolean isDead() {
    return hp < 0;
  }

  PVector eat(ArrayList<PVector> list, float nutrition, float view) {
    PVector target = new PVector(random(width), random(height));
    float min_d = width;
    for (int i = list.size() - 1; i >= 0; --i) {
      PVector p = list.get(i);
      float dis = position.dist(p);
      if(dis > view)
        continue;
      if (dis < r) {
        list.remove(i);
        hp += nutrition;
      } else if (dis < min_d) {
        min_d = dis;
        target = p;
      }
    }    
    return target;
  }

  void seek(PVector aim, float attraction) {
    PVector dir = PVector.sub(aim, position);
    dir.setMag(maxspeed);
    PVector f = PVector.sub(dir, velocity);
    f.limit(maxforce);
    f.mult(attraction);
    applyForce(f);
  }

  void display() {
    float angle = velocity.heading() - (PI / 2.0);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    noStroke();
    color green = color(0, 255, 0);
    color red = color(255, 0, 0);
    color col = lerpColor(red, green, hp);
    fill(col);
    beginShape();
    vertex(0, r * 2);
    vertex(-r, -r);
    vertex(r, -r);
    endShape(CLOSE);
    
    if(debug){
      noFill();
      stroke(0, 255, 0);
      ellipse(0, 0, dna[2] * 2, dna[2] * 2);
      stroke(255, 0, 0);
      ellipse(0, 0, dna[3] * 2, dna[3] * 2);
    }
    
    popMatrix();
  }
  
  void bound(){
    if(position.x < 0 || position.x > width || position.y < 0 || position.y > height){
      seek(new PVector(random(width), random(height)), random(1));
    }
  }
  
  void reproduce(){
    if(random(1) < mutationRatio){
      float[] childdna = new float[4];
      childdna[0] = dna[0] + random(-0.5, 0.5);
      childdna[1] = dna[1] + random(-0.5, 0.5);
      childdna[2] = dna[2] + random(-50, 50);
      childdna[3] = dna[3] + random(-50, 50);
      vehs.add(new Vehical(position.x, position.y, childdna));
    }
    else{
      vehs.add(new Vehical(position.x, position.y, dna.clone()));
    }
  }
}
