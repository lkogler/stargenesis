class Nucleon
{

  boolean isProton;

  // coordinates given in pixels, relative to center of nucleus
  int x, y;

  // velocity of the nucleon
  float vx, vy;
  float v = 3;

  // radius of nucleon
  int radius;

  // color information
  color c;


  Nucleon()
  {
    x = 20;
    y = 20;
    radius = 10;
    c = color(900, 1000, 1000);
    isProton = true; 
    float angle = random(2*PI);
    vx = v*cos(angle);
    vy = v*sin(angle);
  }


  Nucleon( int _x, int _y, int _radius, color _c, boolean _isProton)
  {
    x = _x;
    y = _y;
    radius = _radius;
    c = _c;
    isProton = _isProton;
    float angle = random(2*PI);
    vx = v*cos(angle);
    vy = v*sin(angle);
  }

  Nucleon(int _x, int _y, int _radius, int _hue, int _saturation, boolean _isProton)
  {
    x = _x;
    y = _y;
    radius = _radius;
    isProton = _isProton;
    this.setColor(_hue, _saturation);

    float angle = random(2*PI);
    vx = v*cos(angle);
    vy = v*sin(angle);
  }

  void draw(int _centerX, int _centerY)
  {
    fill(c);
    ellipse(_centerX+x, _centerY+y, radius*2, radius*2);
  }

  void move(int _radius) 
  {
    boolean randomWalk = true;
    // 0,0 is the center of the nucleus    

    // Don't do anything if we only have one nucleon
    if(_radius <= radius/2) return;

    // random walk, variable step size
    if(randomWalk)
    {
      vx = random(-v, v);
      vy = random(-v, v);
      x += vx;
      y += vy;

      if(sqrt(x*x + y*y) > _radius)
      {
        x -= 2*vx;
        y -= 2*vy;
      }
    }
    else // nucleon bounces back and forth in nucleus at constant speed
    {
      if(sqrt(x*x + y*y) > _radius)
      {
        vx = -vx;
        vy = -vy;
      }
      x += vx;
      y += vy;        
    }
  }

  void setColor(int _hue, int _saturation) 
  {
    if(isProton)
    {
      c = color(_hue, _saturation, 1000);
    }
    else
    {
      c = color(_hue, _saturation, 500);
    }
  }



}






