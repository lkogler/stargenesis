class Nucleus
{
  ArrayList nucleons;
  int x,y;
  float vx, vy;
  boolean debug = true;
  int protons;
  int neutrons;

  int radius;

  int type;

  // hue and saturation
  int nucleusHue;
  int nucleusSaturation;

  int nucleonRadius = 2;


  Nucleus(int _x, int _y, int _protons, int _neutrons)
  {
    x = _x;
    y = _y;
    vx = 0;
    vy = 0;
    protons = _protons;
    neutrons = _neutrons;

    nucleons = new ArrayList();

    // The setType() method looks up the isotope based on the number of protons and neutrons
    // and then sets the type and color variables accordingly
    this.setType();

    radius = (protons+neutrons)*nucleonRadius/2;

    for(int i=0; i<protons; i++)
    {
      float r = random(radius);
      float angle = random(2*PI);

      nucleons.add(new Nucleon(int(r*cos(angle)), int(r*sin(angle)), nucleonRadius, nucleusHue, nucleusSaturation, true));
    }
    for(int i=0; i<neutrons; i++)
    {
      float r = random(radius);
      float angle = random(2*PI);

      nucleons.add(new Nucleon(int(r*cos(angle)), int(r*sin(angle)),nucleonRadius, nucleusHue, nucleusSaturation, false));
    }
  }

  Nucleus(int _x, int _y, ArrayList _nucleons)
  {
    x = _x;
    y = _y;
    vx = 0;
    vy = 0;

    nucleons = _nucleons;

    protons = 0;
    neutrons = 0;

    int nNucleons = nucleons.size();

    for(int i=0; i<nNucleons; i++)
    {
      Nucleon n = (Nucleon)nucleons.get(i);
      if(n.isProton) protons++;
      else neutrons++;
    }
    // The setType() method looks up the isotope based on the number of protons and neutrons
    // and then sets the type and color variables accordingly
    this.setType();

    int nucleonRadius = 4;
    radius = (protons+neutrons)*nucleonRadius/2;
  }


  void draw()
  {
    int nNucleons = nucleons.size();
    for(int i=0; i<nNucleons; i++)
    {
      Nucleon n = (Nucleon)nucleons.get(i);
      n.move(radius);
      n.draw(x,y);
    }

  }

  void move() {

    // Implementing a pseudo-gravitational pull toward the center of the screen
    // 0,0 is in top left corner    
    float gravity = 0.03;

    if(x>width/2) vx -= gravity;
    else vx += gravity; 

    if(y>height/2) vy -= gravity;
    else vy += gravity;

    x += vx;
    y += vy;

  }

  int collide(ArrayList _otherNuclei, int _thisIndex) 
  {
    // the return value  will indicate the outcome of the collision:
    // 0: nothing happens
    // i (positive integer): This nucleus will merge with nucleus i-1
    // -1: The nucleus will split into two nuclei
    // -2: beta decay 
    int outcome = 0;

    int nNuclei = _otherNuclei.size();
    for (int i = 0; i < nNuclei; i++) 
    {
      // A nucleus can't collide with itself!
      if(i == _thisIndex) continue;

      Nucleus otherNucleus = (Nucleus)_otherNuclei.get(i);
      float dx = float(otherNucleus.x - x);
      float dy = float(otherNucleus.y - y);
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = float(otherNucleus.radius + this.radius);
      if (distance < minDist) 
      { 
        // test to see if the two nuclei will react
        if(this.react(otherNucleus)) return i+1;

        // Kinematics of one nucleus bouncing off another
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float spring = 0.05;
        float ax = (targetX - otherNucleus.x) * spring;
        float ay = (targetY - otherNucleus.y) * spring;
        vx -= ax;
        vy -= ay;
        otherNucleus.vx += ax;
        otherNucleus.vy += ay;
      }
    }  

    outcome = this.decay();

    return outcome; 
  }

  int decay()
  {
    if(type==5) // Be7->Li7 
    {
      if(random(1)>.990)
      {
        for(int i=0; i<protons+neutrons; i++)
        {
          Nucleon nuc = (Nucleon)nucleons.get(i);
          if(nuc.isProton==true) 
          {
            nuc.isProton==false;
            neutrons++;
            protons--;
            this.setType();
            return -2;
          }
        }
      } 
    }
    if(type==6) // B8-> He4+He4
    {
      
      
    }

  }

  boolean react(Nucleus _other)
  {
    int t1 = -1;
    int t2 = -1;

    // H1
    if(type == 0) 
    {
      t1 = type;
      t2 = _other.type;
    }
    else if(_other.type == 0)
    {
      t1 = _other.type;
      t2 = type; 
    }
    if(t1 == 0)
    {
      if(t2 == 0) // H1+H1 = H2
      {
        // One of the protons must be converted to a neutron first!
        Nucleon proton = (Nucleon)this.nucleons.get(0);
        proton.isProton = false;
        this.protons = 0;
        this.neutrons = 1;
        return true;
      } 
      if(t2 == 1) // H1+H2 = He3
      {
        return true;
      }
      if(t2 == 4) // H1+Li7 = H4 + H4 
      {
        return true;
      }
      if(t2 == 5) // H1+Be7
      {
        return true;
      }
      return false;
    } 

    // He3
    if(type ==2) 
    {
      t1 = type;
      t2 = _other.type;
    }
    else if(_other.type == 2)
    {
      t1 = _other.type;
      t2 = type; 
    }
    if(t1==2)
    {
      if(t2 == 2) // H3 + H3
      {
        return true;
      }
      if(t2 == 3) // H3 + H4
      {
        return true;
      }
      return false;
    }

    return false;
  }

  void merge(Nucleus _otherNucleus)
  {
    this.protons += _otherNucleus.protons;
    this.neutrons += _otherNucleus.neutrons;

    int nAddedNucleons = _otherNucleus.protons+_otherNucleus.neutrons;

    for(int i=0; i<nAddedNucleons; i++)
    {
      this.nucleons.add(_otherNucleus.nucleons.get(i));   
    }

    radius = (protons+neutrons)*nucleonRadius/2;
    this.setType();
    if(debug==true && this.type == -1)
    {
      println("Neutrons: " + this.neutrons + " Protons: " + this.protons);
    }  
  }

  Nucleus divide(int _nProtons, int _nNeutrons)
  {
    if(_nProtons>this.protons || _nNeutrons>this.neutrons)
      return null;

    int nNucleons = protons+neutrons;
    int countProtons = 0;
    int countNeutrons = 0;

    ArrayList newNucleons = new ArrayList();

    int i=0;
    while(i<nNucleons)
    {
      Nucleon n = (Nucleon)nucleons.get(i);
      if(n.isProton && countProtons<_nProtons)
      {
        newNucleons.add(n);
        nucleons.remove(n);
        countProtons++;
        protons--;
        nNucleons--;
        continue;
      }
      else if(!(n.isProton) && countNeutrons<_nNeutrons)
      {
        newNucleons.add(n);
        nucleons.remove(n);
        countNeutrons++;
        neutrons--;
        nNucleons--;
        continue; 
      }
      i++;
    }

    radius = (protons+neutrons)*nucleonRadius/2;
    this.setType();
    Nucleus newNucleus =  new Nucleus(x, y, newNucleons);
    return newNucleus;

  }


  void setType()
  {

    this.type = -1;
    this.nucleusHue = 0;
    this.nucleusSaturation = 0;

    int nTypes = 7;

    // Hydrogen (H)
    if(this.protons == 1) 
    {
      if(this.neutrons == 0)
      {
        this.type = 0; 
      }
      else if(this.neutrons==1)
      {
        this.type = 1; 
      }
    }
    // Helium (He)
    if(this.protons == 2)
    {
      if(this.neutrons == 1)
      {
        this.type = 2;
      }
      else if(this.neutrons == 2)
      {
        this.type = 3;
      }
    }
    // Lithium (Li)
    if(this.protons == 3)
    {
      if(this.neutrons == 4)
      {
        this.type = 4;
      } 
    }
    // Beryllium (Be)
    if(this.protons == 4)
    {
      if(this.neutrons == 3)
      {
        this.type = 5;
      }
      if(this.neutrons == 4)
      {
        this.type = 7;
      } 
      if(this.neutrons == 2) 
      {
        // not a "real" nucleus, just an intermediate state
        // in He3+He3-> He4 + H1 + H1
        this.type = 8;
      }
    }
    // Boron (B)
    if(this.protons == 5)
    {
      if(this.neutrons == 3)
      {
        this.type = 6;
      } 
    }

    if(type >= 0)
    {
      this.nucleusHue = ((type*1000)/(nTypes+1))+(1000/(2*nTypes));
      this.nucleusSaturation = 1000;
    }
    // Actually set the colors of the individual nucleons
    for(int i=0; i<nucleons.size(); i++)
    {
      Nucleon n = (Nucleon)nucleons.get(i);
      n.setColor(nucleusHue, nucleusSaturation); 
    }

  }

}














