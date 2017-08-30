//Custom class for P5 controllers
public class GUIValue 
{
  ControlP5 cp5;
  Textlabel thisLabel;
  int x;
  int y;
  int wid;
  int hei;
  int backColor = ControlP5.BLACK;
  int foreColor = ControlP5.WHITE;
  int decimals = 0;
  String keyName = "";
  Float value = 0f;
  boolean badRead = true;
  
     
  GUIValue(ControlP5 aP5, String theName, int iX, int iY, int iWidth, int iHeight, int idecimals, int ifore, int iback, PFont ifont) 
  {
    this.cp5 = aP5;
  
    x = iX;
    y = iY;
    wid = iWidth;
    hei = iHeight;
    decimals = idecimals;
    foreColor = ifore;
    backColor = iback;
    thisLabel = new Textlabel(cp5,theName,x,y,wid,hei);
    thisLabel.setColorValue(foreColor);
    thisLabel.getValueLabel().setColorBackground(backColor);
    thisLabel.setFont(ifont);
  }
  
  void drawFloat() 
  {
    fill(backColor);
    rect(x,y,wid,hei);
    thisLabel.setColorForeground(foreColor);
    thisLabel.getValueLabel().setColorBackground(backColor);
    if(badRead) thisLabel.setValue("???");
    else thisLabel.setValue(String.format("%."+str(decimals)+"f",value));
    thisLabel.draw();
  }
  
  void drawInt(int val) 
  {
    fill(backColor);
    rect(x,y,wid,hei);
    thisLabel.setColorValue(foreColor);
    thisLabel.getValueLabel().setColorBackground(backColor);
    if(badRead) thisLabel.setValue("???");
    else thisLabel.setValue(str(val));
    thisLabel.draw();
  }
  
  void drawText(String val) 
  {
    fill(backColor);
    rect(x,y,wid,hei);
    thisLabel.setColorValue(foreColor);
    thisLabel.getValueLabel().setColorBackground(backColor);
    if(badRead) thisLabel.setValue("???");
    else thisLabel.setValue(val);
    thisLabel.draw();
  }
  
  void setForeColor(int val)
  {
    foreColor = val;
  }
  
  void setBackColor(int val)
  {
    backColor = val;
  }
}