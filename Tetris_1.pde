void setup() {
  size(360, 660); // 194 x 356 px
}
void draw() {
  background(#acaebe);
   //Figura 1
   F2a();
   F2b();
   F2c();
   F2d();
}


int x2 = 180;
int x2a = 0;
int x2b = 0;
int x2c = 0;
int x2d = 0;

int y2a = 0;
int y2b = 0;
int y2c = 30;
int y2d = 30;

int cont = 0;

int matriz[][] = new int[22][12];


// Figura 1:
void F2a() {
  strokeWeight(3);
  fill(#FF0000);
  if(y2a<600+x2b-x2c){
    rect(x2+x2a-x2b-x2c, y2a++, 30, 30);
  }else{
    y2a = 600+x2b-x2c;
    rect(x2+x2a-x2b-x2c, y2a, 30, 30);
  }
}
void F2b() {
  strokeWeight(3);
  fill(#FF0000);
  if(y2b<600-x2a+(2*x2b)+x2c){
    rect(x2-30+(2*x2a)-(2*x2c), y2b++, 30, 30);
  }else{
    y2b = 600-x2a+(2*x2b)+x2c;
    rect(x2-30+(2*x2a)-(2*x2c), y2b, 30, 30);
  }
}
void F2c() {
  strokeWeight(3);
  fill(#FF0000);
  if(y2c<630-x2a){
    rect(x2, y2c++, 30, 30);
  }else{
    y2c = 630-x2a;
    rect(x2, y2c, 30, 30);
  }
}
void F2d() {
  strokeWeight(3);
  fill(#FF0000);
  if(y2d<630-x2b-x2c){
    rect(x2+30-x2a-x2b+x2c, y2d++, 30, 30);
  }else{
    y2d = 630-x2b-x2c;
    rect(x2+30-x2a-x2b+x2c, y2d, 30, 30);
  }
}
//////////////////////////////////////////////
// Presionado de teclas

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT && x2!=300+x2a && y2a!=600 && y2b!=630 && y2c!=630 && y2d!=630) {
      x2 = x2 + 30;
    } else if (keyCode == LEFT && x2!=30-x2c && y2a!=600 && y2b!=630 && y2c!=630 && y2d!=630) {
      x2 = x2 - 30;
    }
    if (keyCode == DOWN && y2a!=600 && y2b!=630 && y2c!=630 && y2d!=630){
      y2a = y2a + 30;
      y2b = y2b + 30;
      y2c = y2c + 30;
      y2d = y2d + 30;
    }
    if (keyCode == UP && x2!=300+x2a && x2!=30-x2c && y2a!=600 && y2b!=630 && y2c!=630 && y2d!=630){
      //primera rotación
      if(cont==0){
        cont = 1;
        x2a = 30;
        y2a = y2a + 30;
        y2d = y2d + 30;
      }//segunda rotación
      else if(cont==1){
        cont = 2;
        x2b = 30;
        y2a = y2a + 30;
        y2b = y2b + 60;
        y2d = y2d - 30;
      }//Tercera rotación
      else if(cont==2){
        cont = 3;
        x2c = 30;
        y2a = y2a - 30;
        y2d = y2d - 30;
      }//Cuarta rotación
      else if(cont==3){
        cont = 0;
        x2a = 0;
        x2b = 0;
        x2c = 0;
        y2a = y2a - 30;
        y2b = y2b - 60;
        y2d = y2d + 30;
      }
    }
  }
}
