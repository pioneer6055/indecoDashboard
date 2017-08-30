/*
    Indeco Dashboard
    Dashboard for First Robotics competition written in Processing (see processing.org)
    written by Chester Marshall, mentor for 6055 and 5721, August 2017
    
    This is a quick and dirty dashboard with two guiding principles - be simple and reliable
    All screen objects are defined in the indecDashboard.json file, be careful with syntax
    GUILabels are static strings set via the json file
    GUIValues are float values read from networktables and are written by the roboRIO program
    GUIStrings are string values read from networktables and are written by the roboRIO program
    GUISliders are operator inputs written to networktables by this program
    GUIInputs are operator inputs written to networktables by this program
    GUILists are operator inputs written to networktables by this program
    GUISwitches are operator inputs written to networktables by this program
*/
import edu.wpi.first.wpilibj.networktables.NetworkTable;
import controlP5.*;
import ipcapture.*;

IPCapture cam;
NetworkTable table;
NTListener ntlisten;
ControlP5 cp5;
int lastTime = 0;
int nowTime = 0;
boolean firstRead = false;

GUILabel[] GUILabels;
int GUILabelCount = 0;
GUIValue[] GUIValues;
int GUIValueCount = 0;
GUIString[] GUIStrings;
int GUIStringCount = 0;
GUISlider[] GUISliders;
int GUISliderCount = 0;
GUIInput[] GUIInputs;
int GUIInputCount = 0;
GUIList[] GUILists;
int GUIListCount = 0;
GUISwitch[] GUISwitches;
int GUISwitchCount = 0;

GUILabel txtConnection;

JSONObject json,jsonLabel,jsonValue,jsonSlider,jsonInput,jsonList,jsonSwitch,jsonString;
JSONArray jsonLabelData,jsonValueData,jsonSliderData,jsonInputData,jsonListData,jsonSwitchData,jsonStringData;
int screenUpdateRate,screenLeft, screenTop, screenWidth, screenHeight, screenFontSize;
int cameraImageLeft, cameraImageTop, cameraImageWidth, cameraImageHeight;
String screenTitle, screenFont, networkTablesAddress, networkTablesTableName, cameraURL, cameraImageDocked, teamNumber;
String lastError = "";

public class NTListener implements ITableListener 
{
  @Override
  public void valueChanged(ITable itable, String ntkey, Object ntval, boolean isnew) 
  {
    for (int i = 0; i < GUIValueCount; i++) 
    {
      if(table.isConnected())
      {
        if(ntkey.equals(GUIValues[i].keyName)) 
        {
          GUIValues[i].value = Float.valueOf(ntval.toString());
          GUIValues[i].badRead = false;
        }
      }
      else GUIValues[i].badRead = true;
    }
    for (int i = 0; i < GUIStringCount; i++) 
    {
      if(table.isConnected())
      {
        if(ntkey.equals(GUIStrings[i].keyName)) 
        {
          GUIStrings[i].value = ntval.toString();
          GUIStrings[i].badRead = false;
        }
      }
      else GUIValues[i].badRead = true;
    }
    for (int i = 0; i < GUISliderCount; i++)
    {
      if(table.isConnected())
      {
        if(ntkey.equals(GUISliders[i].keyName)) 
        {
          GUISliders[i].value = Float.valueOf(ntval.toString());
          GUISliders[i].badRead = false;
        }
      }
      else GUISliders[i].badRead = true;
    }
    for (int i = 0; i < GUIInputCount; i++)
    {
      if(table.isConnected())
      {
        if(ntkey.equals(GUIInputs[i].keyName)) 
        {
          GUIInputs[i].value = Float.valueOf(ntval.toString());
          GUIInputs[i].badRead = false;
        }
      }
      else GUIInputs[i].badRead = true;
    }
    for (int i = 0; i < GUIListCount; i++)
    {
      if(table.isConnected())
      {
        if(ntkey.equals(GUILists[i].keyName)) 
        {
          GUILists[i].value = ntval.toString();
          GUILists[i].badRead = false;
        }
      }
      else GUILists[i].badRead = true;
    }
    for (int i = 0; i < GUISwitchCount; i++)
    {
      if(table.isConnected())
      {
        if(ntkey.equals(GUISwitches[i].keyName)) 
        {
          GUISwitches[i].value = Float.valueOf(ntval.toString());
          GUISwitches[i].setValue();
          GUISwitches[i].badRead = false;
        }
      }
      else GUISwitches[i].badRead = true;
    }
  }
}

void setup() 
{
  try {
   json = loadJSONObject("indecoDashboard.json");
  } catch(RuntimeException e) { println(e.getMessage()); }
  if(json != null)
  {
    teamNumber = json.getString("teamNumber","0000");
    screenUpdateRate = json.getInt("screenUpdateRate",500);
    screenLeft = json.getInt("screenLeft",1);
    screenTop = json.getInt("screenTop",1);
    screenWidth = json.getInt("screenWidth",640);
    screenHeight = json.getInt("screenHeight",240);
    screenTitle = json.getString("screenTitle","IndeCo Dashboard");
    screenFont = json.getString("screenFont","arial");
    screenFontSize = json.getInt("screenFontSize",12);
    networkTablesAddress = json.getString("networkTablesAddress","127.0.0.1");
    networkTablesTableName = json.getString("networkTablesTableName","datatable");
    cameraURL = json.getString("cameraURL","http://127.0.0.1/mjpg/video.mjpg");
    cameraImageLeft = json.getInt("cameraImageLeft",500);
    cameraImageTop = json.getInt("cameraImageTop",1);
    cameraImageWidth = json.getInt("cameraImageWidth",140);
    cameraImageHeight = json.getInt("cameraImageHeight",240);
    cameraImageDocked = json.getString("cameraImageDocked","right");
  }
  surface.setSize(screenWidth,screenHeight);
  surface.setLocation(screenLeft,screenTop);
  surface.setTitle(screenTitle);
  surface.setAlwaysOnTop(true);
  surface.setResizable(true);
  //register pre-draw callback function
  registerMethod ("pre", this ) ;
  try {
    jsonLabelData = json.getJSONArray("GUILabels");
    GUILabelCount = jsonLabelData.size();
    GUILabels = new GUILabel[jsonLabelData.size()];
  } catch(RuntimeException e) { GUILabelCount = 0; }
  try {
    jsonValueData = json.getJSONArray("GUIValues");
    GUIValueCount = jsonValueData.size();
    GUIValues = new GUIValue[jsonValueData.size()];
  } catch(RuntimeException e) { GUIValueCount = 0; }
  try {
    jsonStringData = json.getJSONArray("GUIStrings");
    GUIStringCount = jsonStringData.size();
    GUIStrings = new GUIString[jsonStringData.size()];
  } catch(RuntimeException e) { GUIStringCount = 0; }
  try {
    jsonSliderData = json.getJSONArray("GUISliders");
    GUISliderCount = jsonSliderData.size();
    GUISliders = new GUISlider[jsonSliderData.size()];
  } catch(RuntimeException e) { GUISliderCount = 0; }
  try {
    jsonInputData = json.getJSONArray("GUIInputs");
    GUIInputCount = jsonInputData.size();
    GUIInputs = new GUIInput[jsonInputData.size()];
  } catch(RuntimeException e) { GUIInputCount = 0; }
  try {
    jsonListData = json.getJSONArray("GUILists");
    GUIListCount = jsonListData.size();
    GUILists = new GUIList[jsonListData.size()];
  } catch(RuntimeException e) { GUIListCount = 0; }
  try {
    jsonSwitchData = json.getJSONArray("GUISwitches");
    GUISwitchCount = jsonSwitchData.size();
    GUISwitches = new GUISwitch[jsonSwitchData.size()];
  } catch(RuntimeException e) { GUISwitchCount = 0; }
  //PImage titlebaricon = loadImage("myicon.png");
  //surface.setIcon(titlebaricon);
  PFont font = createFont(screenFont,screenFontSize);
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  NetworkTable.setClientMode();
  NetworkTable.setIPAddress(networkTablesAddress);
  table = NetworkTable.getTable(networkTablesTableName);
  
  background(ControlP5.BLACK);
  for (int i = 0; i < GUILabelCount; i++) 
  {
    jsonLabel = jsonLabelData.getJSONObject(i);
    GUILabels[i] = new GUILabel(cp5,"lbl"+str(i),jsonLabel.getInt("x"),jsonLabel.getInt("y"),jsonLabel.getInt("width"),jsonLabel.getInt("height"),unhex("FF"+jsonLabel.getString("foreColor")),unhex("FF"+jsonLabel.getString("backColor")),font);
    GUILabels[i].label = jsonLabel.getString("label");
  }
  for (int z = 0; z < GUIValueCount; z++) 
  {
    jsonValue = jsonValueData.getJSONObject(z);
    GUIValues[z] = new GUIValue(cp5,"val"+str(z),jsonValue.getInt("x"),jsonValue.getInt("y"),jsonValue.getInt("width"),jsonValue.getInt("height"),jsonValue.getInt("decimals"),unhex("FF"+jsonValue.getString("foreColor")),unhex("FF"+jsonValue.getString("backColor")),font);
    GUIValues[z].keyName = jsonValue.getString("keyName");
  }
  for (int z = 0; z < GUIStringCount; z++) 
  {
    jsonString = jsonStringData.getJSONObject(z);
    GUIStrings[z] = new GUIString(cp5,"str"+str(z),jsonString.getInt("x"),jsonString.getInt("y"),jsonString.getInt("width"),jsonString.getInt("height"),unhex("FF"+jsonString.getString("foreColor")),unhex("FF"+jsonString.getString("backColor")),font);
    GUIStrings[z].keyName = jsonString.getString("keyName");
  }
  for (int z = 0; z < GUISliderCount; z++) 
  {
    jsonSlider = jsonSliderData.getJSONObject(z);
    GUISliders[z] = new GUISlider(cp5,"sld"+str(z),jsonSlider.getInt("x"),jsonSlider.getInt("y"),jsonSlider.getInt("width"),jsonSlider.getInt("height"),unhex("FF"+jsonSlider.getString("foreColor")),unhex("FF"+jsonSlider.getString("backColor")),font,unhex("FF"+jsonSlider.getString("slideColor")),jsonSlider.getInt("rangeMin"),jsonSlider.getInt("rangeMax"));
    GUISliders[z].keyName = jsonSlider.getString("keyName");
  }
  for (int z = 0; z < GUIInputCount; z++) 
  {
    jsonInput = jsonInputData.getJSONObject(z);
    GUIInputs[z] = new GUIInput(cp5,"inp"+str(z),jsonInput.getInt("x"),jsonInput.getInt("y"),jsonInput.getInt("width"),jsonInput.getInt("height"),unhex("FF"+jsonInput.getString("foreColor")),unhex("FF"+jsonInput.getString("backColor")),font);
    GUIInputs[z].keyName = jsonInput.getString("keyName");
  }
  for (int z = 0; z < GUIListCount; z++) 
  {
    jsonList = jsonListData.getJSONObject(z);
    String[] strs = jsonList.getJSONArray("dataList").getStringArray();
    GUILists[z] = new GUIList(cp5,"lst"+str(z),jsonList.getInt("x"),jsonList.getInt("y"),jsonList.getInt("width"),jsonList.getInt("height"),unhex("FF"+jsonList.getString("foreColor")),unhex("FF"+jsonList.getString("backColor")),unhex("FF"+jsonList.getString("activeColor")),font,strs,jsonList.getInt("itemsPerRow"),jsonList.getInt("rowSpacing"),jsonList.getInt("colSpacing"));
    GUILists[z].keyName = jsonList.getString("keyName");
  }
  for (int z = 0; z < GUISwitchCount; z++) 
  {
    jsonSwitch = jsonSwitchData.getJSONObject(z);
    GUISwitches[z] = new GUISwitch(cp5,"btn"+str(z),jsonSwitch.getInt("x"),jsonSwitch.getInt("y"),jsonSwitch.getInt("width"),jsonSwitch.getInt("height"),unhex("FF"+jsonSwitch.getString("onColor")),unhex("FF"+jsonSwitch.getString("offColor")),unhex("FF"+jsonSwitch.getString("foreColor")),font,jsonSwitch.getString("caption"));
    GUISwitches[z].keyName = jsonSwitch.getString("keyName");
  }
    
  //txtConnection = new GUILabel(cp5,"txtConnection",10,10,110,25,ControlP5.BLACK,ControlP5.GRAY,font);
  
  
  //setup listener to read changed values from server
  ntlisten = new NTListener();
  table.addTableListener(ntlisten);

  //setup camera driver to capture stream
  cam = new IPCapture(this, cameraURL, "", "");
  cam.start();
}

void pre () 
{
  //detect screen size change
  if (screenWidth != width || screenHeight != height) 
  {
    ;
    screenWidth=width ;
    screenHeight=height ;
    if(cameraImageDocked.equals("right"))
    {
      cameraImageLeft = screenWidth - cameraImageWidth;
      cameraImageTop = 1;
      cameraImageHeight = screenHeight - 1; 
    }
  } 
}

void draw() 
{
  for (int i = 0; i < GUILabelCount; i++) 
  {
    GUILabels[i].drawLabel();
  }
  if(!firstRead) getFirstRead();
  nowTime = millis();
  if(nowTime - lastTime > screenUpdateRate)
  {
    lastTime = nowTime;
    for (int i = 0; i < GUIValueCount; i++) 
    {
      GUIValues[i].drawFloat();
    }
    for (int i = 0; i < GUIStringCount; i++) 
    {
      GUIStrings[i].drawText();
    }
    if(table.isConnected()) surface.setTitle(teamNumber+ ":" +screenTitle+ " -- CONNECTED to "+networkTablesTableName+" @ "+networkTablesAddress);
    else surface.setTitle(teamNumber+ ":" +screenTitle+ " -- NOT CONNECTED to "+networkTablesTableName+" @ "+networkTablesAddress);
  }
  
  cp5.draw();
  
  //process the video feed
  if (cam.isAvailable()) 
  {
    cam.read();
    image(cam,cameraImageLeft,cameraImageTop,cameraImageWidth,cameraImageHeight);
  }
  else
  {
    fill(0,0,255);
    rect(cameraImageLeft,cameraImageTop,cameraImageWidth,cameraImageHeight);
    fill(255,0,0);
    text("NO CAMERA FEED", cameraImageWidth/5 + cameraImageLeft,cameraImageHeight/2 + cameraImageTop); 
  }
}

void checkError(String emessage)
{
  if(!emessage.equals(lastError))
  {
    lastError = emessage;
    println("Exception: "+lastError);
  } 
}

void getFirstRead()
{
  if(table.isConnected())
  {
    firstRead = true;
    for (int i = 0; i < GUIValueCount; i++) 
    {
      try
      {
        GUIValues[i].value = (float)table.getNumber(GUIValues[i].keyName);
        GUIValues[i].badRead = false;
        //GUIValues[i].drawFloat(1);
      }
      catch(RuntimeException e)
      {
        GUIValues[i].badRead = true;
        checkError("[VALUE] "+e.getMessage());
      }
    }
    for (int i = 0; i < GUIStringCount; i++) 
    {
      try
      {
        GUIStrings[i].value = table.getString(GUIStrings[i].keyName);
        GUIStrings[i].badRead = false;
      }
      catch(RuntimeException e)
      {
        GUIStrings[i].badRead = true;
        checkError("[STRING] "+e.getMessage());
      }
    }
    for (int i = 0; i < GUISliderCount; i++) 
    {
      try
      {
        try
        {
          GUISliders[i].value = (float)table.getNumber(GUISliders[i].keyName);
        } catch(RuntimeException z) {}
        GUISliders[i].badRead = false;
        GUISliders[i].setValue();
      }
      catch(RuntimeException e)
      {
        GUISliders[i].badRead = true;
        checkError("[SLIDER] "+e.getMessage());
      }
    }
    for (int i = 0; i < GUIInputCount; i++) 
    {
      try
      {
        try
        {
          GUIInputs[i].value = (float)table.getNumber(GUIInputs[i].keyName);
        } catch(RuntimeException z) {}
        GUIInputs[i].badRead = false;
        GUIInputs[i].setValue();
      }
      catch(RuntimeException e)
      {
        GUIInputs[i].badRead = true;
        checkError("[INPUT] "+e.getMessage());
      }
    }
    for (int i = 0; i < GUIListCount; i++) 
    {
      try
      {
        GUILists[i].value = table.getString(GUILists[i].keyName);
        GUILists[i].badRead = false;
        GUILists[i].setValue();
      }
      catch(RuntimeException e)
      {
        GUILists[i].badRead = true;
        checkError("[LIST] "+e.getMessage());
      }
    }
    for (int i = 0; i < GUISwitchCount; i++) 
    {
      try
      {
        GUISwitches[i].value = (float)table.getNumber(GUISwitches[i].keyName);
        GUISwitches[i].badRead = false;
        GUISwitches[i].setValue();
      }
      catch(RuntimeException e)
      {
        GUISwitches[i].badRead = true;
        checkError("[BUTTON] "+e.getMessage());
      }
    }
  }
}

void keyPressed() {
  if (key == ESC) {
    key = 0;  //don't escape
  }
}

void controlEvent(ControlEvent theEvent) 
{
  if(table.isConnected() && firstRead)
  {
    for (int i = 0; i < GUISliderCount; i++) 
    {  
      if (theEvent.isFrom(cp5.getController("sld"+str(i)))) 
      {
        table.putNumber(GUISliders[i].keyName, theEvent.getController().getValue());
      }
    }
    for (int i = 0; i < GUIInputCount; i++) 
    {  
      if (theEvent.isFrom(cp5.getController("inp"+str(i)))) 
      {
        table.putNumber(GUIInputs[i].keyName, Float.valueOf(theEvent.getController().getStringValue()));
      }
    }
    for (int i = 0; i < GUIListCount; i++) 
    {  
      if (theEvent.getName().equals("lst"+str(i))) 
      {
        table.putString(GUILists[i].keyName, GUILists[i].valueList[int(theEvent.getValue())]);
      }
    }
    for (int i = 0; i < GUISwitchCount; i++) 
    {  
      if (theEvent.getName().equals("btn"+str(i))) 
      {
        if(GUISwitches[i].value == 0.0) GUISwitches[i].value = 1.0;
        else  GUISwitches[i].value = 0.0;
        table.putNumber(GUISwitches[i].keyName, GUISwitches[i].value);
      }
    }
  }
}