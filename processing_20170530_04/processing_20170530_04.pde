import processing.opengl.*;

// 力：重力、風力（浮力）
Mover movers[] = new Mover[100];

/*
* 初期設定
*/
void setup() {
  frameRate(60);
  size(500, 500, OPENGL);
  for (int i = 0; i < movers.length; i++)
  {
    movers[i] = new Mover(random(0.2, 1.5), random(0, width), random(0, height), random(0, 500), random(0, 255), random(0, 255), random(0, 255));
  }
}

/*
* 随時描写
*/
void draw() {
  // 初期設定
  noStroke();
  background(255);
  translate(0, 0, -100);

  // 表示更新
  for (int i = 0; i < movers.length; i++) {
    
    // 力のスケーリング
    float edgeForceScale = 0.0002;

    // 左端に近づくほど、X軸のプラス（→）方向への力を加算
    PVector leftForce = new PVector(abs(width -movers[i].location.x) * edgeForceScale, 0, 0);
    movers[i].applyForce(leftForce);
    
    // 右端に近づくほど、X軸のマイナス（←）方向への力を加算
    PVector rightForce = new PVector(-(movers[i].location.x * edgeForceScale), 0, 0);
    movers[i].applyForce(rightForce);

    // 上端に近づくほど、y軸のプラス（↓）方向への力を加算
    PVector topForce = new PVector(0, abs(height - movers[i].location.y) * edgeForceScale, 0);
    movers[i].applyForce(topForce);

    // 下端に近づくほど、y軸のマイナス（↑）方向への力を加算
    PVector bottomForce = new PVector(0, -(movers[i].location.y * edgeForceScale), 0);
    movers[i].applyForce(bottomForce);

    // 奥端に近づくほど、z軸のプラス（↓）方向への力を加算
    PVector backForce = new PVector(0, 0, abs(500 - movers[i].location.z) * edgeForceScale);
    movers[i].applyForce(backForce);

    // 前端に近づくほど、z軸のマイナス（↑）方向への力を加算
    PVector sideForce = new PVector(0, 0, -(movers[i].location.z * edgeForceScale));
    movers[i].applyForce(sideForce);

    // 風力
    if (mousePressed == true) {
    // パーリンノイズ値を定期的に加算 -0.5～0.5 の間でランダム
      PVector noff = new PVector(noise(random(1000)), noise(random(1000)), noise(random(1000)));
      float noiseX = map(noff.x, 0, 1, -0.2, 0.2);
      float noiseY = map(noff.y, 0, 1, -0.2, 0.2);
      float noiseZ = map(noff.z, 0, 1, -0.2, 0.2);
      PVector wind = new PVector(noiseX, noiseY, noiseZ);
      movers[i].applyForce(wind);
    }
    
    // 描写更新
    movers[i].update();
    movers[i].display();
    
    // フレームセーブ
    //saveFrame("frames/######.tif");
  }
}

/*
* 移動オブジェクトクラス
*/
class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float r, g, b;
  
  /*
  * コンストラクタ
  */
  Mover(float m, float x, float y, float z, float r_, float g_, float b_) {
    // 質量、位置、速度、加速度の初期値を設定
    mass = m;
    location = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
    r = r_;
    g = g_;
    b = b_;
  }
  
  /*
  * 位置、速度の更新
  */
  void update() {
    // 速度に加速度を加算
    velocity.add(acceleration);
    // 現在位置に速度分の移動を加算
    location.add(velocity);
    // 加速度の初期化
    acceleration.mult(0);
  }
  
  /*
  * 画面表示
  */
  void display() {
    noStroke();
    fill(r, g, b);
    pushMatrix();
    translate(location.x, location.y, location.z);
    box(mass * 16);
    popMatrix();
  } 

  /*
  * 力の積算
  */
  void applyForce(PVector force) 
  {
    // 加速度に力を加算
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
}