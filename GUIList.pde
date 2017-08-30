//Custom class for P5 controllers

public class GUIList 
{
  ControlP5 cp5;
  RadioButton lstZ;
  int x;
  int y;
  int wid;
  int hei;
  String keyName = "";
  String value = "";
  String[] valueList; 
  boolean badRead = true;
     
  GUIList(ControlP5 aP5, String theName, int iX, int iY, int iWidth, int iHeight, int ifore, int iback, int iactive, PFont ifont, String[] ddl, int irow, int irowspacing, int icolspacing) 
  {
    this.cp5 = aP5;
  
    x = iX;
    y = iY;
    wid = iWidth;
    hei = iHeight;
    valueList = ddl;
    
    lstZ = cp5.addRadioButton(theName)
           .setPosition(iX,iY)
           .setSize(iWidth, iHeight)
           .setColorBackground(iback)
           .setColorForeground(ifore)
           .setColorActive(iactive)
           .setColorLabel(ifore)
           .setItemsPerRow(irow)
           .setSpacingRow(irowspacing)
           .setSpacingColumn(icolspacing)
           .setFont(ifont);
    for (int z = 0; z < ddl.length; z++) 
    {
      lstZ.addItem(ddl[z], z).toUpperCase(false);
    }
  }

  
  //set control's value
  void setValue()
  {
    for (int z = 0; z < valueList.length; z++) 
    {
      if(valueList[z].equals(value))
      {
        lstZ.activate(z);
      }
    }
  }
  
  

}