//Custom class for P5 controllers
public class GUIInput 
{
  ControlP5 cp5;
  Textfield inpZ;
  int x;
  int y;
  int wid;
  int hei;
  String keyName = "";
  Float value = 0f;
  boolean badRead = true;
  
     
  GUIInput(ControlP5 aP5, String theName, int iX, int iY, int iWidth, int iHeight, int ifore, int iback, PFont ifont) 
  {
    this.cp5 = aP5;
  
    x = iX;
    y = iY;
    wid = iWidth;
    hei = iHeight;
    inpZ = cp5.addTextfield(theName).setPosition(iX,iY).setHeight(iHeight).setWidth(iWidth).setFont(ifont);
    inpZ.getCaptionLabel().setVisible(false);
    inpZ.setColorForeground(ifore);
    inpZ.setColorBackground(iback);
    inpZ.setAutoClear(false);
    inpZ.setBroadcast(true);

  }

  //set control's value
  void setValue()
  {
    inpZ.setText(str(value));
  }

}