int w = 10;
int h = 20;
int q = 20;//bloques de ancho y alto
int dt;// retraso entre cada movimiento
int tiempoActual;
Malla malla;
Pieza pieza;
Pieza siguientePieza;
Piezas piezas;
Puntaje puntaje;
int r = 0;//estado de rotación, de 0 to 3
int nivel = 1;
int nbLineas = 0;

int txtSize = 20;
int textColor = color(34, 230, 190);

Boolean gameOver = false;
Boolean gameOn = false;

void setup()
{
  size(600, 480);
  textSize(20);
}

void inicializacion() {
  nivel = 1;
  nbLineas = 0;
  dt = 1000;
  tiempoActual = millis();
  puntaje = new Puntaje();
  malla = new Malla();
  piezas = new Piezas();
  pieza = new Pieza(-1);
  siguientePieza = new Pieza(-1);
}

void draw()
{
  background(60);

  if(malla != null){
    malla.drawMalla();
    int now = millis();
    if (gameOn) {
      if (now - tiempoActual > dt) {
        tiempoActual = now;
        pieza.bajar();
      }
    }
    pieza.mostrar(false);
    puntaje.mostrar();
  }
  if (gameOver) {
    noStroke();
    fill(255, 60);
    rect(110, 195, 240, 2*txtSize, 3);
    fill(textColor);
    text("Game Over :(", 120, 220);
  }
  if (!gameOn) {
    noStroke();
    fill(255, 60);
    rect(110, 250, 255, 2*txtSize, 3);
    fill(textColor);
    text("Presiona P para jugar :D", 120, 280);
  }
}

void irASiguientePieza() {
  //println("-- - siguientePieza - - --");
  pieza = new Pieza(siguientePieza.tipo);
  siguientePieza = new Pieza(-1);
  r = 0;
}

void irASiguienteLevel() {
  puntaje.anadirPuntosDeNivel();
  nivel = 1 + int(nbLineas / 10);
  dt *= .8;
  //soundLevelUp();
}

void keyPressed() {
  if (key == CODED && gameOn) {
    switch(keyCode) {
    case LEFT:
    case RIGHT:
    case DOWN:
    case UP:
    case SHIFT:
      pieza.inputKey(keyCode);
      break;
    }
  } else if (keyCode == 80) {// "p"
    if(!gameOn){
      inicializacion();
      //soundGameStart();
      gameOver = false;
      gameOn = true;
    }
  }
}

class Malla {
  int [][] cells = new int[w][h];

  Malla() {
    for (int i = 0; i < w; i ++) {
      for (int j = 0; j < h; j ++) {
        cells[i][j] = 0;
      }
    }
  }

  Boolean isLibre(int x, int y) {
    if (x > -1 && x < w && y > -1 && y < h) {
      return cells[x][y] == 0;
    } else if (y < 0) {
      return true;
    }
    return false;
  }

  Boolean piezaEncaje() {
    int x = pieza.x;
    int y = pieza.y;
    int[][][] pos = pieza.pos;
    Boolean BajarOk = true;
    for (int i = 0; i < 4; i ++) {
      int tmpx = pos[r][i][0]+x;
      int tmpy = pos[r][i][1]+y;
      if (!isLibre(tmpx, tmpy)) {
        BajarOk = false;
        break;
      }
    }
    return BajarOk;
  }

  void mostrarPieza() {
    int x = pieza.x;
    int y = pieza.y;
    int[][][] pos = pieza.pos;
    for (int i = 0; i < 4; i ++) {
      if(pos[r][i][1]+y >= 0){
        cells[pos[r][i][0]+x][pos[r][i][1]+y] = pieza.c;
      }else{
        gameOn = false;
        gameOver = true;
        return;
      }
    }
    //soundTouchDown();
    puntaje.anadirPuntosDePieza();
    verificarLineasCompletas();
    irASiguientePieza();
    drawMalla();
  }

  void verificarLineasCompletas() {
    int nb = 0;//number of full lineas
    for (int j = 0; j < h; j ++) {
      Boolean fullLine = true;
      for (int i = 0; i < w; i++) {
        fullLine = cells[i][j] != 0;
        if (!fullLine) {
          break;
        }
      }
      if (fullLine) {
        nb++;
        for (int k = j; k > 0; k--) {
          for (int i = 0; i < w; i++) {
            cells[i][k] = cells[i][k-1];
          }
        }
        // top line will be empty
        for (int i = 0; i < w; i++) {
          cells[i][0] = 0;
        }
      }
    }
    eliminarLineas(nb);
  }

  void eliminarLineas(int nb) {
    //println("deleted lineas: "+nb);
    nbLineas += nb;
    if (int(nbLineas / 10) > nivel-1) {
      irASiguienteLevel();
    }
    puntaje.anadirLinePoints(nb);
  }

  void setTotipo() {
    int j = 0;
    for (j = 0; j < h; j ++) {
      if (!piezaEncaje()) {
        break;
      } else {
        pieza.y++;
      }
    }
    pieza.y--;
    mostrarPieza();
  }

  void drawMalla() {
    stroke(#FFFFFF);
    pushMatrix();
    translate(160, 40);
    for (int i = 0; i <= w; i ++) {
      line(i*q, 0, i*q, h*q);
    }
    for (int j = 0; j <= h; j ++) {
      line(0, j*q, w*q, j*q);
    }

    stroke(80);
    for (int i = 0; i < w; i ++) {
      for (int j = 0; j < h; j ++) {
        if (cells[i][j] != 0) {
          fill(cells[i][j]);
          rect(i*q, j*q, q, q);
        }
      }
    }
    popMatrix();
  }
}

class Pieza {
  final color[] colors = {
    color(128, 12, 128), 
    color(230, 12, 12), 
    color(12, 230, 12), 
    color(9, 239, 230),  
    color(230, 230, 9), 
    color(230, 128, 9), 
    color(12, 12, 230)
  };

  // [rotacion][block nb][x o y]
  final int[][][] pos;
  int x = int(w/2);
  int y = 0;
  int tipo;
  int c;

  Pieza(int k) {
    tipo = k < 0 ? int(random(0, 7)) : k;
    c = colors[tipo];
    r = 0;
    pos = piezas.pos[tipo];
  }

  void mostrar(Boolean quieto) {
    stroke(250);
    fill(c);
    pushMatrix();
    if (!quieto) {
      translate(160, 40);
      translate(x*q, y*q);
    }
    int rot = quieto ? 0 : r;
    for (int i = 0; i < 4; i++) {
      rect(pos[rot][i][0] * q, pos[rot][i][1] * q, 20, 20);
    }
    popMatrix();
  }

  // devuelve verdadero si la pieza puede bajar un paso
  void bajar() {
    y += 1;
    if(!malla.piezaEncaje()){
      pieza.y -= 1;
      malla.mostrarPieza();
    }
  }

  void irAtipo() {
    malla.setTotipo();
  }

  void inputKey(int k) {
    switch(k) {
    case LEFT:
      x --;
      if(malla.piezaEncaje()){
        //soundLeftRight();
      }else {
         x++; 
      }
      break;
    case RIGHT:
      x ++;
      if(malla.piezaEncaje()){
        //soundLeftRight();
      }else{
         x--; 
      }
      break;
    case DOWN:
      bajar();
      break;
    case UP:
      r = (r+1)%4;
      if(!malla.piezaEncaje()){
         r = r-1 < 0 ? 3 : r-1; 
         //soundRotationFail();
      }else{
        //soundRotation();
      }
      break;
    case SHIFT:
      irAtipo();
      break;
    }
  }
}

class Piezas {
  int[][][][] pos = new int [7][4][4][2];

  Piezas() {
    ////   @   ////
    //// @ @ @ ////
    pos[0][0][0][0] = -1;//pieza 0, rotacion 0, point nb 0, x
    pos[0][0][0][1] = 0;// pieza 0, rotacion 0, point nb 0, y
    pos[0][0][1][0] = 0;
    pos[0][0][1][1] = 0;
    pos[0][0][2][0] = 1;
    pos[0][0][2][1] = 0;
    pos[0][0][3][0] = 0;
    pos[0][0][3][1] = 1;
    
    pos[0][1][0][0] = 0;
    pos[0][1][0][1] = 0;
    pos[0][1][1][0] = 1;
    pos[0][1][1][1] = 0;
    pos[0][1][2][0] = 0;
    pos[0][1][2][1] = -1;
    pos[0][1][3][0] = 0;
    pos[0][1][3][1] = 1;

    pos[0][2][0][0] = -1;
    pos[0][2][0][1] = 0;
    pos[0][2][1][0] = 0;
    pos[0][2][1][1] = 0;
    pos[0][2][2][0] = 1;
    pos[0][2][2][1] = 0;
    pos[0][2][3][0] = 0;
    pos[0][2][3][1] = -1;

    pos[0][3][0][0] = -1;
    pos[0][3][0][1] = 0;
    pos[0][3][1][0] = 0;
    pos[0][3][1][1] = 0;
    pos[0][3][2][0] = 0;
    pos[0][3][2][1] = -1;
    pos[0][3][3][0] = 0;
    pos[0][3][3][1] = 1;

    //// @ @   ////
    ////   @ @ ////
    pos[1][0][0][0] = pos[1][2][0][0] = -1;//pieza 1, rotacion 0, point nb 0, x
    pos[1][0][0][1] = pos[1][2][0][1] = 1;// pieza 1, rotacion 0, point nb 0, y
    pos[1][0][1][0] = pos[1][2][1][0] = 0;
    pos[1][0][1][1] = pos[1][2][1][1] = 1;
    pos[1][0][2][0] = pos[1][2][2][0] = 0;
    pos[1][0][2][1] = pos[1][2][2][1] = 0;
    pos[1][0][3][0] = pos[1][2][3][0] = 1;
    pos[1][0][3][1] = pos[1][2][3][1] = 0;

    pos[1][1][0][0] = pos[1][3][0][0] = -1;
    pos[1][1][0][1] = pos[1][3][0][1] = 0;
    pos[1][1][1][0] = pos[1][3][1][0] = 0;
    pos[1][1][1][1] = pos[1][3][1][1] = 0;
    pos[1][1][2][0] = pos[1][3][2][0] = -1;
    pos[1][1][2][1] = pos[1][3][2][1] = -1;
    pos[1][1][3][0] = pos[1][3][3][0] = 0;
    pos[1][1][3][1] = pos[1][3][3][1] = 1;
    
    ////   @ @ ////
    //// @ @   ////
    pos[2][0][0][0] = pos[2][2][0][0] = 0;//pieza 2, rotacion 0 and 2, point nb 0, x
    pos[2][0][0][1] = pos[2][2][0][1] = 1;//pieza 2, rotacion 0 and 2, point nb 0, y
    pos[2][0][1][0] = pos[2][2][1][0] = 1;
    pos[2][0][1][1] = pos[2][2][1][1] = 1;
    pos[2][0][2][0] = pos[2][2][2][0] = -1;
    pos[2][0][2][1] = pos[2][2][2][1] = 0;
    pos[2][0][3][0] = pos[2][2][3][0] = 0;
    pos[2][0][3][1] = pos[2][2][3][1] = 0;

    pos[2][1][0][0] = pos[2][3][0][0] = 0;
    pos[2][1][0][1] = pos[2][3][0][1] = 0;
    pos[2][1][1][0] = pos[2][3][1][0] = 1;
    pos[2][1][1][1] = pos[2][3][1][1] = 0;
    pos[2][1][2][0] = pos[2][3][2][0] = 1;
    pos[2][1][2][1] = pos[2][3][2][1] = -1;
    pos[2][1][3][0] = pos[2][3][3][0] = 0;
    pos[2][1][3][1] = pos[2][3][3][1] = 1;
    
    ////// @ //////
    ////// @ //////
    ////// @ //////
    ////// @ //////
    pos[3][0][0][0] = pos[3][2][0][0] = 0;//pieza 3, rotacion 0 and 2, point nb 0, x
    pos[3][0][0][1] = pos[3][2][0][1] = -1;//pieza 3, rotacion 0 and 2, point nb 0, y
    pos[3][0][1][0] = pos[3][2][1][0] = 0;
    pos[3][0][1][1] = pos[3][2][1][1] = 0;
    pos[3][0][2][0] = pos[3][2][2][0] = 0;
    pos[3][0][2][1] = pos[3][2][2][1] = 1;
    pos[3][0][3][0] = pos[3][2][3][0] = 0;
    pos[3][0][3][1] = pos[3][2][3][1] = 2;

    pos[3][1][0][0] = pos[3][3][0][0] = -1;
    pos[3][1][0][1] = pos[3][3][0][1] = 0;
    pos[3][1][1][0] = pos[3][3][1][0] = 0;
    pos[3][1][1][1] = pos[3][3][1][1] = 0;
    pos[3][1][2][0] = pos[3][3][2][0] = 1;
    pos[3][1][2][1] = pos[3][3][2][1] = 0;
    pos[3][1][3][0] = pos[3][3][3][0] = 2;
    pos[3][1][3][1] = pos[3][3][3][1] = 0;
    
    //// @ @ ////
    //// @ @ ////
    //pieza 4, all rotacions are the same
    pos[4][0][0][0] = pos[4][1][0][0] = pos[4][2][0][0] = pos[4][3][0][0] = 0;
    pos[4][0][0][1] = pos[4][1][0][1] = pos[4][2][0][1] = pos[4][3][0][1] = 0;
    pos[4][0][1][0] = pos[4][1][1][0] = pos[4][2][1][0] = pos[4][3][1][0] = 1;
    pos[4][0][1][1] = pos[4][1][1][1] = pos[4][2][1][1] = pos[4][3][1][1] = 0;
    pos[4][0][2][0] = pos[4][1][2][0] = pos[4][2][2][0] = pos[4][3][2][0] = 0;
    pos[4][0][2][1] = pos[4][1][2][1] = pos[4][2][2][1] = pos[4][3][2][1] = 1;
    pos[4][0][3][0] = pos[4][1][3][0] = pos[4][2][3][0] = pos[4][3][3][0] = 1;
    pos[4][0][3][1] = pos[4][1][3][1] = pos[4][2][3][1] = pos[4][3][3][1] = 1;

    ///// @   ////
    ///// @   ////
    ///// @ @ ////
    pos[5][0][0][0] = 0;//pieza 5, rotacion 0, point nb 0, x
    pos[5][0][0][1] = 1;//pieza 5, rotacion 0, point nb 0, y
    pos[5][0][1][0] = 1;
    pos[5][0][1][1] = 1;
    pos[5][0][2][0] = 0;
    pos[5][0][2][1] = 0;
    pos[5][0][3][0] = 0;
    pos[5][0][3][1] = -1;

    pos[5][1][0][0] = 0;
    pos[5][1][0][1] = 0;
    pos[5][1][1][0] = 1;
    pos[5][1][1][1] = 0;
    pos[5][1][2][0] = 2;
    pos[5][1][2][1] = 0;
    pos[5][1][3][0] = 2;
    pos[5][1][3][1] = -1;

    pos[5][2][0][0] = 0;
    pos[5][2][0][1] = -1;
    pos[5][2][1][0] = 1;
    pos[5][2][1][1] = -1;
    pos[5][2][2][0] = 1;
    pos[5][2][2][1] = 0;
    pos[5][2][3][0] = 1;
    pos[5][2][3][1] = 1;

    pos[5][3][0][0] = 0;
    pos[5][3][0][1] = 0;
    pos[5][3][1][0] = 1;
    pos[5][3][1][1] = 0;
    pos[5][3][2][0] = 2;
    pos[5][3][2][1] = 0;
    pos[5][3][3][0] = 0;
    pos[5][3][3][1] = 1;
    
    ////   @ ////
    ////   @ ////
    //// @ @ ////
    pos[6][0][0][0] = 0;//pieza 6, rotacion 0, point nb 0, x
    pos[6][0][0][1] = 1;//pieza 6, rotacion 0, point nb 0, y
    pos[6][0][1][0] = 1;
    pos[6][0][1][1] = 1;
    pos[6][0][2][0] = 1;
    pos[6][0][2][1] = 0;
    pos[6][0][3][0] = 1;
    pos[6][0][3][1] = -1;

    pos[6][1][0][0] = 0;
    pos[6][1][0][1] = 0;
    pos[6][1][1][0] = 1;
    pos[6][1][1][1] = 0;
    pos[6][1][2][0] = 2;
    pos[6][1][2][1] = 0;
    pos[6][1][3][0] = 2;
    pos[6][1][3][1] = 1;

    pos[6][2][0][0] = 0;
    pos[6][2][0][1] = -1;
    pos[6][2][1][0] = 1;
    pos[6][2][1][1] = -1;
    pos[6][2][2][0] = 0;
    pos[6][2][2][1] = 0;
    pos[6][2][3][0] = 0;
    pos[6][2][3][1] = 1;

    pos[6][3][0][0] = 0;
    pos[6][3][0][1] = 0;
    pos[6][3][1][0] = 1;
    pos[6][3][1][1] = 0;
    pos[6][3][2][0] = 2;
    pos[6][3][2][1] = 0;
    pos[6][3][3][0] = 0;
    pos[6][3][3][1] = -1;
  }
}

class Puntaje {
  int puntos = 0;

  void anadirLinePoints(int nb) {
    if (nb == 4) {
      puntos += nivel * 10 * 20;
    } else {
      puntos += nivel * nb * 20;
    }
  }

  void anadirPuntosDePieza() {
    puntos += nivel * 5;
  }

  void anadirPuntosDeNivel() {
    puntos += nivel * 100;
  }

  void mostrar() {
    pushMatrix();
    translate(40, 60);

    //puntaje
    fill(textColor);
    text("puntaje: ", 0, 0);
    fill(230, 230, 12);
    text(""+formatPoint(puntos), 0, txtSize);

    //nivel
    fill(textColor);
    text("nivel: ", 0, 3*txtSize);
    fill(230, 230, 12);
    text("" + nivel, 0, 4*txtSize);
    
    //lineas
    fill(textColor);
    text("lineas: ", 0, 6*txtSize);
    fill(230, 230, 12);
    text("" + nbLineas, 0, 7*txtSize);
    popMatrix();


    pushMatrix();
    translate(400, 60);

    //puntaje
    fill(textColor);
    text("siguiente: ", 0, 0);

    translate(1.2*q, 1.5*q);
    siguientePieza.mostrar(true);
    popMatrix();
  }

  String formatPoint(int p) {
    String txt = "";
    int qq = int(p/1000000);
    if (qq > 0) {
      txt += qq + ".";
      p -= qq * 1000000;
    }

    qq = int(p/1000);
    if (txt != "") {
      if (qq == 0) {
        txt += "000";
      } else if (qq < 10) {
        txt += "00";
      } else if (qq < 100) {
        txt += "0";
      }
    }
    if (qq > 0) {
      txt += qq;
      p -= qq * 1000;
    }
    if (txt != "") {
      txt += ".";
    }

    if (txt != "") {
      if (p == 0) {
        txt += "000";
      } else if (p < 10) {
        txt += "00" + p;
      } else if (p < 100) {
        txt += "0" + p;
      } else {
        txt += p;
      }
    } else {
      txt += p;
    }
    return txt;
  }
}
