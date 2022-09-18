//+------------------------------------------------------------------+
//|                                          strength-oscillator.mq4 |
//|                                                   Mozheykin Igor |
//|                    https://www.UpWork.com/freelancers/legalwings |
//+------------------------------------------------------------------+
#property copyright "Mozheykin Igor"
#property link      "https://www.UpWork.com/freelancers/legalwings"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_plots   5
//--- plot FirstSymbol
#property indicator_label1  "FirstSymbol"
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot SecondSymbol
#property indicator_label2  "SecondSymbol"
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
#property indicator_label3  "Zerro"
#property indicator_color3  clrGray
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
#property indicator_label4  "Up"
#property indicator_color4  clrGreen
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
#property indicator_label5  "Down"
#property indicator_color5  clrRed
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//--- indicator buffers
double         FirstSymbolBuffer[];
double         SecondSymbolBuffer[];
double         ZerroBuffer[];
double         UpBuffer[];
double         DownBuffer[];
//--- inputs
string gen = "----General inputs----";
bool autoSymbols = false;
string symbolsToWeigh = "AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,CADJPY,CHFJPY,EURAUD,EURCAD,EURJPY,EURNZD,EURUSD,GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,GBPUSD,NZDCHF,NZDJPY,NZDUSD,USDCAD,USDCHF,USDJPY";
int maxBars = 370;
bool weighOnlySymbolOnChart = false;
string nonPropFont = "Lucida Console";
bool addSundayToMonday = true;
bool showOnlySymbolOnChart = true;
string ind = "----Indicator inputs----";
bool autoTimeFrame = true;
string ind_tf = "timeFrame M1,M5,M15,M30,H1,H4,D1,W1,MN";
string timeFrame = "D1";
string extraTimeFrame = "D1";
bool ignoreFuture = true;
bool showCrossAlerts = true;
double differenceThreshold = 0.0;
bool showLevelCross = true;
double levelCrossValue = 0.2;
bool PopupAlert = true;
bool EmailAlert = false;
bool PushAlert = false;
string cur = "----Currency inputs----";
bool USD = true;
bool EUR = true;
bool GBP = true;
bool CHF = true;
bool JPY = true;
bool AUD = true;
bool CAD = true;
bool NZD = true;
string colour = "----Colo(u)r inputs----";
color Color_USD = 255;
color Color_EUR = 16760576;
color Color_GBP = 14772545;
color Color_CHF = 15658671;
color Color_JPY = 55295;
color Color_AUD = 42495;
color Color_CAD = 128;
color Color_NZD = 9221330;
color colorWeakCross = 55295;
color colorNormalCross = 55295;
color colorStrongCross = 55295;
color colorDifferenceUp = 3158016;
color colorDifferenceDn = 48;
color colorDifferenceLo = 21588;
color colorTimeframe = 16777215;
color colorLevelHigh = 3329330;
color colorLevelLow = 3937500;
input double Cofficent_USD = 0.1;
input double Cofficent_EUR = 0.2;
input double Cofficent_GBP = 0.3;
input double Cofficent_CHF = 0.4;
input double Cofficent_JPY = 0.5;
input double Cofficent_AUD = 0.6;
input double Cofficent_CAD = 0.7;
input double Cofficent_NZD = 0.8;

int getWindowIndicator()
{
   return ChartWindowFind(0, "SO("+Symbol()+")");
}

double getDataBuffers(int Buffer, int shift)
{
   double result = iCustom(Symbol(), 0, "advanced-currency-strength-oscillator", gen, autoSymbols, symbolsToWeigh, maxBars, weighOnlySymbolOnChart, nonPropFont, addSundayToMonday, showOnlySymbolOnChart, ind,
   autoTimeFrame, ind_tf, timeFrame, extraTimeFrame, ignoreFuture, showCrossAlerts, differenceThreshold, showLevelCross, levelCrossValue, PopupAlert, EmailAlert, PushAlert, cur, USD, EUR, GBP, CHF, JPY, AUD,
   CAD, NZD, colour, Color_USD, Color_EUR, Color_GBP, Color_CHF, Color_JPY, Color_AUD, Color_CAD, Color_NZD, colorWeakCross, colorNormalCross, colorStrongCross, colorDifferenceUp, colorDifferenceDn,
   colorDifferenceLo, colorTimeframe, colorLevelHigh, colorLevelLow, Buffer, shift);
   return result;
}

string getSymbol(int paramSplit)
{
   string symbol = "";
   if (paramSplit == 1) symbol = StringSubstr(Symbol(),0, 3);
   if (paramSplit == 2) symbol = StringSubstr(Symbol(),3, 3);
   return symbol;
}

color getColorSymbol(int paramSplit)
{
   if (getSymbol(paramSplit) == "USD") return Color_USD;
   if (getSymbol(paramSplit) == "EUR") return Color_EUR;
   if (getSymbol(paramSplit) == "GBP") return Color_GBP;
   if (getSymbol(paramSplit) == "CHF") return Color_CHF;
   if (getSymbol(paramSplit) == "JPY") return Color_JPY;
   if (getSymbol(paramSplit) == "AUD") return Color_AUD;
   if (getSymbol(paramSplit) == "CAD") return Color_CAD;
   if (getSymbol(paramSplit) == "NZD") return Color_NZD;
   return clrBlack;
}

double getCofficentSymbol(int paramSplit)
{
   if (getSymbol(paramSplit) == "USD") return Cofficent_USD;
   if (getSymbol(paramSplit) == "EUR") return Cofficent_EUR;
   if (getSymbol(paramSplit) == "GBP") return Cofficent_GBP;
   if (getSymbol(paramSplit) == "CHF") return Cofficent_CHF;
   if (getSymbol(paramSplit) == "JPY") return Cofficent_JPY;
   if (getSymbol(paramSplit) == "AUD") return Cofficent_AUD;
   if (getSymbol(paramSplit) == "CAD") return Cofficent_CAD;
   if (getSymbol(paramSplit) == "NZD") return Cofficent_NZD;
   return 1.0;
}


void createLabel(string text, int x, int y, color clrLabel)
{
   ObjectCreate(0,"SO_" + text,OBJ_LABEL,getWindowIndicator(),0,0);
   ObjectSetInteger(0,"SO_" + text,OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0,"SO_" + text,OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0,"SO_" + text,OBJPROP_CORNER, CORNER_RIGHT_UPPER);
   ObjectSetString(0,"SO_" + text,OBJPROP_TEXT, text);
   ObjectSetString(0,"SO_" + text,OBJPROP_FONT,nonPropFont);
   ObjectSetInteger(0,"SO_" + text,OBJPROP_FONTSIZE, 14);
   ObjectSetInteger(0,"SO_" + text,OBJPROP_COLOR,clrLabel);
   ObjectSetInteger(0,"SO_" + text,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
}

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   IndicatorShortName("SO("+Symbol()+")");
   SetIndexBuffer(0,FirstSymbolBuffer);
   SetIndexBuffer(1,SecondSymbolBuffer);
   SetIndexBuffer(2, ZerroBuffer);
   SetIndexBuffer(3, UpBuffer);
   SetIndexBuffer(4, DownBuffer);
   
   color color0buf = getColorSymbol(1);
   color color1buf = getColorSymbol(2);
   
   SetIndexStyle(0,DRAW_LINE,EMPTY,2,color0buf);
   SetIndexStyle(1,DRAW_LINE,EMPTY,2,color1buf);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   double cof0buf = getCofficentSymbol(1);
   double cof1buf = getCofficentSymbol(2);
   for (int i=0; i<= maxBars; i++){
   FirstSymbolBuffer[i] = getDataBuffers(0, i) * cof0buf;
   SecondSymbolBuffer[i] = getDataBuffers(1, i) * cof1buf;
   ZerroBuffer[i] = 0;
   UpBuffer[i] = levelCrossValue;
   DownBuffer[i] = -levelCrossValue;
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

   
  }
//+------------------------------------------------------------------+
