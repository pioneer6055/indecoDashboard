//Custom class for P5 controllers

public class GUISwitch 
{
  ControlP5 cp5;
  Button btnZ;
  int x;
  int y;
  int wid;
  int hei;
  int onColor = 0;
  int offColor = 0;
  String keyName = "";
  Float value = 0f;
  boolean badRead = true;
     
  GUISwitch(ControlP5 aP5, String theName, int iX, int iY, int iWidth, int iHeight, int iOn, int iOff, int iFore, PFont ifont, String icaption) 
  {
    this.cp5 = aP5;
  
    x = iX;
    y = iY;
    wid = iWidth;
    hei = iHeight;
    onColor = iOn;
    offColor = iOff;
    
    btnZ = cp5.addButton(theName)
           .setPosition(iX,iY)
           .setSize(iWidth, iHeight)
           .setColorBackground(iOff)
           .setColorForeground(iOff)
           .setColorLabel(iFore)
           .setColorActive(color(120))
           .setCaptionLabel(icaption)
           .setFont(ifont)
           .setMoveable(false)
           .setMouseOver(true);    
  }

  
  //set control's value
  void setValue()
  {
     if(value == 0) 
     {
       btnZ.setColorBackground(offColor);
       btnZ.setColorForeground(offColor);
     }
     else 
     {
       btnZ.setColorBackground(onColor);
       btnZ.setColorForeground(onColor);
     }
  }
  
  

}