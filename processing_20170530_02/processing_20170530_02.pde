// 力：重力、風力（浮力）
Mover movers[] = new Mover[100];

/*
* 初期設定
*/
void setup() {
  size(500, 500);
  for (int i = 0; i < movers.length; i++)
  {
    movers[i] = new Mover(random(0.1, 2), random(0, width), random(0, height), random(0, 255), random(0, 255), random(0, 255));
  }
}

/*
* 随時描写
*/
void draw() {
  noStroke();
  fill(255, 60);
  rect(0, 0, width, height);

  // 表示更新
  for (int i = 0; i < movers.length; i++) {
    
    // 力のスケーリング
    float edgeForceScale = 0.0002;

    // 左端に近づくほど、X軸のプラス（→）方向への力を加算
    PVector leftForce = new PVector(abs(width -movers[i].location.x) * edgeForceScale, 0);
    movers[i].applyForce(leftForce);
    
    // 右端に近づくほど、X軸のマイナス（←）方向への力を加算
    PVector rightForce = new PVector(-(movers[i].location.x * edgeForceScale), 0);
    movers[i].applyForce(rightForce);

    // 上端に近づくほど、y軸のプラス（↓）方向への力を加算
    PVector topForce = new PVector(0, abs(height - movers[i].location.y) * edgeForceScale);
    movers[i].applyForce(topForce);

    // 下端に近づくほど、y軸のマイナス（↑）方向への力を加算
    PVector bottomForce = new PVector(0, -(movers[i].location.y * edgeForceScale));
    movers[i].applyForce(bottomForce);

    movers[i].update();
    movers[i].display();
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
  float r,g,b;
  
  /*
  * コンストラクタ
  */
  Mover(float m, float x, float y, float r_, float g_, float b_) {
    // 質量、位置、速度、加速度の初期値を設定
    mass = m;
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
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
    ellipse(location.x, location.y, mass * 16, mass * 16);
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