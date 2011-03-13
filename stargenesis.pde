import processing.opengl.*;
import javax.media.opengl.GL;

ArrayList nuclei = new ArrayList();
PGraphicsOpenGL pgl;
GL gl;

void setup() {
  smooth();
  noStroke();
  size(1000,800,OPENGL);
  colorMode(HSB, 1000);
  frameRate(60);

  /*fixes crazy flickering*/
  pgl = (PGraphicsOpenGL)g;
  gl = pgl.beginGL();
  gl.setSwapInterval(1);
  pgl.endGL();

  int nNuclei = 500;
  for(int i=0; i<nNuclei; i++)
  {
    nuclei.add(new Nucleus(int(random(width)), int(random(height)), 1,0));
  }
}

void draw() {
  
  int nNuclei = nuclei.size();
  Nucleus n;
  for(int i=0; i<nNuclei; i++)
  {
    n = (Nucleus)nuclei.get(i);
    int outcome = n.collide(nuclei, i);
    if(outcome != 0)
    {
      if(outcome>0)
      {
        Nucleus other = (Nucleus)nuclei.get(outcome-1);
        n.merge(other);
        nuclei.remove(outcome-1); 
      }
      if(n.type==7) 
      {
        // Be8 -> He4 + He4
        nuclei.add(n.divide(2,2));
      }
      if(n.type==8)
      {
        // He3 + He3 -> He4 + H1 + H1
        nuclei.add(n.divide(1,0));
        nuclei.add(n.divide(1,0)); 
      }
      return;
    }
    n.move();

    
  }
  background(0);
  for(int i=0; i<nNuclei; i++)
  {
    n = (Nucleus)nuclei.get(i);
    n.draw();
  }
}


/**
 */



