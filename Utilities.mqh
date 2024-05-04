
/*
   Utilities and General Purpose Functions
*/



//+------------------------------------------------------------------+
//| Price Information                                                |
//+------------------------------------------------------------------+
double            UTIL_PRICE_ASK()              { return SymbolInfoDouble(Symbol(), SYMBOL_ASK); }
double            UTIL_PRICE_BID()              { return SymbolInfoDouble(Symbol(), SYMBOL_BID); }
double            UTIL_LAST_CANDLE_OPEN()       { return iOpen(Symbol(), PERIOD_CURRENT, 0); }
double            UTIL_LAST_CANDLE_CLOSE()      { return iClose(Symbol(), PERIOD_CURRENT, 0); }
double            UTIL_DAY_OPEN()               { return iOpen(Symbol(), PERIOD_D1, 0); }
double            UTIL_CANDLE_OPEN(const int shift)      { return iOpen(Symbol(), PERIOD_CURRENT, shift); }
double            UTIL_CANDLE_CLOSE(const int shift)     { return iClose(Symbol(), PERIOD_CURRENT, shift); }
double            UTIL_CANDLE_HIGH(const int shift = 1)  { return iHigh(Symbol(), PERIOD_CURRENT, shift); }
double            UTIL_CANDLE_LOW(const int shift = 1)   { return iLow(Symbol(), PERIOD_CURRENT, shift); }

double            UTIL_PREVIOUS_DAY_OPEN()     { 
   
   double open    = iOpen(Symbol(), PERIOD_D1, 1);
   if (open == 0) return iOpen(NULL, PERIOD_CURRENT, UTIL_SHIFT_YESTERDAY());
   return open;
}

double            UTIL_PREVIOUS_DAY_CLOSE()    { 
   
   double close   = iClose(NULL, PERIOD_D1, 1);
   if (close == 0) return iClose(NULL, PERIOD_CURRENT, UTIL_SHIFT_TODAY() + 1);
   return close;

}

double            UTIL_PREVIOUS_DAY_HIGH()     {
   
   double high    = iHigh(NULL, PERIOD_D1, 1);
   return high; 
}

double            UTIL_PREVIOUS_DAY_LOW()      {

   double low     = iLow(NULL, PERIOD_D1, 1);
   return low;

}


//+------------------------------------------------------------------+
//| Symbol Properties                                                |
//+------------------------------------------------------------------+ 
int               UTIL_MARKET_SPREAD()             { return (int)SymbolInfoInteger(Symbol(), SYMBOL_SPREAD); }
double            UTIL_TICK_VAL()                  { return SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE); } 
double            UTIL_TRADE_PTS()                 { return SymbolInfoDouble(Symbol(), SYMBOL_POINT); }
double            UTIL_SYMBOL_MINLOT()             { return SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN); }
double            UTIL_SYMBOL_MAXLOT()             { return SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX); }
int               UTIL_SYMBOL_DIGITS()             { return (int)SymbolInfoInteger(Symbol(), SYMBOL_DIGITS); }
double            UTIL_SYMBOL_CONTRACT_SIZE()      { return SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE); }
double            UTIL_SYMBOL_LOTSTEP()            { return SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP); }



//+------------------------------------------------------------------+
//| Account Properties                                               |
//+------------------------------------------------------------------+ 

ENUM_ACCOUNT_STOPOUT_MODE  UTIL_ACCOUNT_MARGIN_SO_MODE()    { return (ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE); }
ENUM_ACCOUNT_TRADE_MODE    UTIL_ACCOUNT_TRADE_MODE()        { return (ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE); }

int               UTIL_ACCOUNT_LOGIN()             { return (int)AccountInfoInteger(ACCOUNT_LOGIN); }
int               UTIL_ACCOUNT_LEVERAGE()          { return (int)AccountInfoInteger(ACCOUNT_LEVERAGE); }
int               UTIL_ACCOUNT_LIMIT_ORDERS()      { return (int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS); }
bool              UTIL_ACCOUNT_TRADE_ALLOWED()     { return (bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED); }
bool              UTIL_ACCOUNT_TRADE_EXPERT()      { return (bool)AccountInfoInteger(ACCOUNT_TRADE_EXPERT); }

double            UTIL_ACCOUNT_BALANCE()           { return AccountInfoDouble(ACCOUNT_BALANCE); }
double            UTIL_ACCOUNT_EQUITY()            { return AccountInfoDouble(ACCOUNT_EQUITY); }
double            UTIL_ACCOUNT_CREDIT()            { return AccountInfoDouble(ACCOUNT_CREDIT); }
double            UTIL_ACCOUNT_PROFIT()            { return AccountInfoDouble(ACCOUNT_PROFIT); }
double            UTIL_ACCOUNT_MARGIN()            { return AccountInfoDouble(ACCOUNT_MARGIN); } 
double            UTIL_ACCOUNT_MARGIN_FREE()       { return AccountInfoDouble(ACCOUNT_MARGIN_FREE); }
double            UTIL_ACCOUNT_MARGIN_LEVEL()      { return AccountInfoDouble(ACCOUNT_MARGIN_LEVEL); }
double            UTIL_ACCOUNT_MARGIN_SO_CALL()    { return AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL); }
double            UTIL_ACCOUNT_MARGIN_SO_SO()      { return AccountInfoDouble(ACCOUNT_MARGIN_SO_SO); }
double            UTIL_ACCOUNT_MARGIN_INITIAL()    { return AccountInfoDouble(ACCOUNT_MARGIN_INITIAL); }
double            UTIL_ACCOUNT_MARGIN_MAINTENANCE(){ return AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE); }
double            UTIL_ACCOUNT_ASSETS()            { return AccountInfoDouble(ACCOUNT_ASSETS); }
double            UTIL_ACCOUNT_LIABILITIES()       { return AccountInfoDouble(ACCOUNT_LIABILITIES); }
double            UTIL_ACCOUNT_COMMISSION_BLOCKED(){ return AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED); }

string            UTIL_ACCOUNT_NAME()              { return AccountInfoString(ACCOUNT_NAME); }
string            UTIL_ACCOUNT_SERVER()            { return AccountInfoString(ACCOUNT_SERVER); }
string            UTIL_ACCOUNT_CURRENCY()          { return AccountInfoString(ACCOUNT_CURRENCY); }
string            UTIL_ACCOUNT_COMPANY()           { return AccountInfoString(ACCOUNT_COMPANY); }


void  PrintAccountInformation() {
   PrintFormat("Account Login: %i", UTIL_ACCOUNT_LOGIN()); 
   PrintFormat("Account Trade Mode: %s", EnumToString((ENUM_ACCOUNT_TRADE_MODE)UTIL_ACCOUNT_TRADE_MODE()));
   PrintFormat("Account Leverage: %i", UTIL_ACCOUNT_LEVERAGE());     
   
}


//+------------------------------------------------------------------+
//| Time and Offset                                                  |
//+------------------------------------------------------------------+ 
int               UTIL_TIME_HOUR(datetime date) {
   //--- Returns hour
   MqlDateTime tm;
   TimeToStruct(date, tm); 
   return tm.hour; 
}
int               UTIL_TIME_MINUTE(datetime date) {
   //--- Returns minute
   MqlDateTime tm;
   TimeToStruct(date, tm);
   return tm.min; 
}
int               UTIL_TIME_DAY_OF_WEEK(datetime date) {
   //--- Returns day of week 
   MqlDateTime tm;
   TimeToStruct(date, tm); 
   return tm.day_of_week; 
}

int               UTIL_TIME_YEAR(datetime date) {
   //--- Returns Year 
   MqlDateTime tm; 
   TimeToStruct(date, tm);
   return tm.year; 
}

datetime          UTIL_GET_DATE(datetime date) {
   //--- Returns date 
   return StringToTime(TimeToString(date, TIME_DATE)); 
}

bool              UTIL_IS_TODAY(datetime date) {
   //--- Returns true if date is date today 
   return UTIL_GET_DATE(TimeCurrent()) == UTIL_GET_DATE(date); 
}

int            UTIL_SEC_TO_HOURS(const int seconds) { 
   //--- Converts seconds to hours 
   return (seconds / PeriodSeconds(PERIOD_H1)); 
}

int            UTIL_SERVER_GMT_OFFSET() {
   //--- Returns Server-GMT Offset in hours 
   return UTIL_SEC_TO_HOURS(TimeCurrent() - TimeGMT());
}

int            UTIL_LOCAL_GMT_OFFSET() {
   //--- Returns Local-GMT offset in hours 
   return UTIL_SEC_TO_HOURS(TimeLocal() - TimeGMT()); 
   
}
//--- Number of bars from opening candle
int               UTIL_SHIFT_TODAY()           { return iBarShift(NULL, PERIOD_CURRENT, UTIL_DATE_TODAY()); }
//--- Number of bars from yesterday
int               UTIL_SHIFT_YESTERDAY()       { return iBarShift(NULL, PERIOD_CURRENT, UTIL_DATE_YESTERDAY()); }
//--- Number of seconds in 1 day
int               UTIL_INTERVAL_DAY()          { return PeriodSeconds(PERIOD_D1); }
//--- Number of seconds in current timeframe
int               UTIL_INTERVAL_CURRENT()      { return PeriodSeconds(PERIOD_CURRENT); }


bool              UTIL_DATE_MATCH(datetime target, datetime reference) {
   //--- Checks if dates match 
   if (StringFind(TimeToString(target), TimeToString(reference, TIME_DATE)) == -1) return false;
   //--- Can also use:
   // return UTIL_GET_DATE(target) == UTIL_GET_DATE(reference) 
   return true;

}
//--- Returns the date today 
datetime          UTIL_DATE_TODAY()            { return (UTIL_GET_DATE(TimeCurrent())); }
//--- Returns the date yesterday
datetime          UTIL_DATE_YESTERDAY()        { return UTIL_DATE_TODAY() - UTIL_INTERVAL_DAY(); }



//+------------------------------------------------------------------+
//| Conversion                                                       |
//+------------------------------------------------------------------+ 

string         UTIL_PRICE_STRING(double value) {
   //--- Converts price to string 
   return DoubleToString(value, UTIL_SYMBOL_DIGITS()); 
}


string         UTIL_LOT_STRING(double value) {
   //--- Converts lot to string
   return StringFormat("%.2f", value); 
}


string            UTIL_NORM_PRICE(double value) {
   //--- Another method for converting price to string 
   //--- FAULTY! 4/29/2024
   string format_string    = StringFormat("%%.df", UTIL_SYMBOL_DIGITS());
   return StringFormat(format_string, value);
   
}

double            UTIL_NORM_VALUE(double value) {
   //--- Normalizes to 2 decimal points. Ideally for percentages
   return NormalizeDouble(value, 2);
}

double            UTIL_TO_PRICE(double value) { 
   //--- Normalizes digits to price digits
   return NormalizeDouble(value, UTIL_SYMBOL_DIGITS());
}


//+------------------------------------------------------------------+
//| Terminal                                                         |
//+------------------------------------------------------------------+ 
bool              UTIL_IS_TESTING() {
   //--- Checks if using strategy tester
   return (bool)MQLInfoInteger(MQL_TESTER); 
}

double            UTIL_SCREEN_DPI() {
   return (double)TerminalInfoInteger(TERMINAL_SCREEN_DPI);
}

double            UTIL_DPI_SCALE_FACTOR() {
   return (UTIL_SCREEN_DPI() / 96); 
}

int               UTIL_SCALE_DPI(double value) {
   return (int)MathRound(value * UTIL_DPI_SCALE_FACTOR()); 
}


//+------------------------------------------------------------------+
//| Operations                                                       |
//+------------------------------------------------------------------+ 


bool           UTIL_IS_NEW_CANDLE() {
   //--- Checks if current candle is new candle. 
   static datetime saved_candle_time; 
   datetime current_time = iTime(Symbol(), PERIOD_CURRENT, 0); 
   
   bool new_candle = current_time != saved_candle_time; 
   
   saved_candle_time = current_time; 
   return new_candle; 
   
}

template <typename T>
bool           UTIL_IS_POINTER_INVALID(T object_ptr) {
   return (CheckPointer(object_ptr) == POINTER_INVALID); 
}


template <typename T>
bool           UTIL_IS_POINTER_DYNAMIC(T object_ptr) {
   return (CheckPointer(object_ptr) == POINTER_DYNAMIC); 
}