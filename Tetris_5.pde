void setup() {
  size(360, 660); // 194 x 356
}
void draw() {
  background(#acaebe);
   //Figura 1
   F1a();
   F1b();
   F1c();
   F1d();
}


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


// Figura 1:
void F1a() {
  strokeWeight(3);
  fill(#FFAA00);
  if(y1a<600-x1b+x1c){
    rect(x1+30, y1a++, 30, 30);
  }else{
    y1a = 600-x1b+x1c;
    rect(x1+30, y1a, 30, 30);
  }
}
void F1b() {
  strokeWeight(3);
  fill(#FFAA00);
  if(y1b<630-(2*x1a)-x1b-x1c){
    rect(x1-30+x1a-x1b+x1c-x1d, y1b++, 30, 30);
  }else{
    y1b = 630-(2*x1a)-x1b-x1c;
    rect(x1-30+x1a-x1b+x1c-x1d, y1b, 30, 30);
  }
}
void F1c() {
  strokeWeight(3);
  fill(#FFAA00);
  if(y1c<630-x1a){
    rect(x1, y1c++, 30, 30);
  }else{
    y1c = 630-x1a;
    rect(x1, y1c, 30, 30);
  }
}
void F1d() {
  strokeWeight(3);
  fill(#FFAA00);
  if(y1d<630+x1b+x1c){
    rect(x1+30-x1a+x1b-x1c+x1d, y1d++, 30, 30);
  }else{
    y1d = 630+x1b+x1c;
    rect(x1+30-x1a+x1b-x1c+x1d, y1d, 30, 30);
  }
}
