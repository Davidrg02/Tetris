void setup() {
  size(360, 660); // 194 x 356
}
void draw() {
  background(#acaebe);
  if (si==true){
   //Figura 1
   F1a();
   F1b();
   F1c();
   F1d();
  }

}

int z = 0;

int x1 = 180;
int x1a = 0;
int x1b = 0;
int x1c = 0;
int x1d = 0;

int y1a = 0;
int y1b = 30;
int y1c = 30;
int y1d = 30;

int cont = 0;

int matriz[][] = new int[22][12];

Boolean si = true;





// Figura 1:
void F1a() {
  strokeWeight(3);
  fill(#9700FF);
  if(y1a<600-x1b+x1c){
    rect(x1+x1a+x1b+x1c+x1d, y1a++, 30, 30);
  }else{
    y1a = 600-x1b+x1c;
    rect(x1+x1a+x1b+x1c+x1d, y1a, 30, 30);
    si = false;
  }
}
void F1b() {
  strokeWeight(3);
  fill(#9700FF);
  if(y1b<630-(2*x1a)-x1b-x1c){
    rect(x1-30+x1a-x1b+x1c-x1d, y1b++, 30, 30);
  }else{
    y1b = 630-(2*x1a)-x1b-x1c;
    rect(x1-30+x1a-x1b+x1c-x1d, y1b, 30, 30);
    z = 1;
    si = false;
  }
}
void F1c() {
  strokeWeight(3);
  fill(#9700FF);
  if(y1c<630-x1a){
    rect(x1, y1c++, 30, 30);
  }else{
    y1c = 630-x1a;
    rect(x1, y1c, 30, 30);
    si = false;
  }
}
void F1d() {
  strokeWeight(3);
  fill(#9700FF);
  if(y1d<630+x1b+x1c){
    rect(x1+30-x1a+x1b-x1c+x1d, y1d++, 30, 30);
  }else{
    y1d = 630+x1b+x1c;
    rect(x1+30-x1a+x1b-x1c+x1d, y1d, 30, 30);

  }
}
//////////////////////////////////////////////
//////////////////////////////////////////////
//////////////////////////////////////////////
//

//////////////////////////////
//////////////////////////////
//////////////////////////////
// Presionado de teclas
void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT && x1!=300-x1c && y1a!=600-x1b+x1c && y1b!=630-(2*x1a)-x1b-x1c && y1c!=630-x1a && y1d!=630+x1b+x1c) {
      x1 = x1 + 30;
    } else if (keyCode == LEFT && x1!=30-x1a && y1a!=600-x1b+x1c && y1b!=630-(2*x1a)-x1b-x1c && y1c!=630-x1a && y1d!=630+x1b+x1c) {
      x1 = x1 - 30;
    }
    if (keyCode == DOWN && y1a!=600 && y1b!=630 && y1c!=630 && y1d!=630){
      y1a = y1a + 30;
      y1b = y1b + 30;
      y1c = y1c + 30;
      y1d = y1d + 30;
    }
    if (keyCode == UP && x1!=300-x1c && x1!=30-x1a && y1a!=600-x1b+x1c && y1b!=630-(2*x1a)-x1b-x1c && y1c!=630-x1a && y1d!=630+x1b+x1c){
      //primera rotación
      if(cont==0){
        cont = 1;
        x1a = 30;
        y1a = y1a + 30;
        y1b = y1b - 30;
        y1d = y1d + 30;
      }
      //segunda rotación
      else if(cont==1){
        cont = 2;
        x1b = -30;
        y1a = y1a + 30;
        y1b = y1b + 30;
        y1d = y1d - 30;
      }
      //tercera rotación
      else if(cont==2){
        cont = 3;
        x1c = -30;
        y1a = y1a - 30;
        y1b = y1b + 30;
        y1d = y1d - 30;
      }//Cuarta rotación
      else if(cont==3){
        cont = 0;
        x1a = 0;
        x1b = 0;
        x1c = 0;
        y1a = y1a - 30 - 30 + 30;
        y1b = y1b + 30 - 30 - 30;
        y1d = y1d - 30 + 30 + 30;  
      }
    }
  }
}

  
  
