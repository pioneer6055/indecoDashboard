//Custom class for P5 controllers
public class GUISlider 
{
  ControlP5 cp5;
  Slider sldZ;
  int x;
  int y;
  int wid;
  int hei;
  String keyName = "";
  Float value = 0f;
  boolean badRead = true;
  
     
  //sldZ = cp5.addSlider("sldZ").setPosition(400,50).setHeight(20).setWidth(100).setFont(font).setId(99).setRange(0,255);
  //sldZ.getCaptionLabel().setVisible(false);
  //CColor col = new CColor(ControlP5.BLUE,ControlP5.GRAY,ControlP5.BLUE,ControlP5.ORANGE,ControlP5.WHITE);
  //sldZ.setColor(col);
  
  GUISlider(ControlP5 aP5, String theName, int iX, int iY, int iWidth, int iHeight, int ifore, int iback, PFont ifont, int islide, int rangeMin, int rangeMax) 
  {
    this.cp5 = aP5;
  
    x = iX;
    y = iY;
    wid = iWidth;
    hei = iHeight;
    //foreColor = ifore;
    //backColor = iback;
    //slideColor = islide;
    sldZ = cp5.addSlider(theName).setPosition(iX,iY).setHeight(iHeight).setWidth(iWidth).setFont(ifont).setRange(rangeMin,rangeMax);
    sldZ.getCaptionLabel().setVisible(false);
    CColor col = new CColor(iback,islide,iback,ifore,ifore);
    sldZ.setColor(col);

  }

  //set control's value 
  void setValue()
  {
     sldZ.setValue(value); 
  }

}