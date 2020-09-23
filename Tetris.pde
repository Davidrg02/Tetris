void setup() {
  size(360, 660); // 194 x 356 px
}
void draw() {
  background(#acaebe);
  F1a();
  F1b();
  F1c();
  F1d();
}

int x = 180;
int y1 = 0;
int y2 = 30;
int y3 = 30;
int y4 = 30;

// Figura 1:
void F1a() {
  strokeWeight(3);
  fill(#001BFF);
  if(y1<600){
    rect(x, y1++, 30, 30);
  }
}
void F1b() {
  strokeWeight(3);
  fill(#001BFF);
  if(y2<630){
    rect(x-30, y2++, 30, 30);
  }
}
void F1c() {
  strokeWeight(3);
  fill(#001BFF);
  if(y3<630){
    rect(x, y3++, 30, 30);
  }
}
void F1d() {
  strokeWeight(3);
  fill(#001BFF);
  if(y4<630){
    rect(x+30, y4++, 30, 30);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT && x!=300) {
      x = x + 30;
    } else if (keyCode == LEFT && x!=30) {
      x = x - 30;
    }
  }
}
  
  
  
  
  
  
  
