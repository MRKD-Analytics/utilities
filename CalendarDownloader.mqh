

/*
   Main class for downloading weekly economic calendar. 
   
   Make sure to allow web requests in options 
*/

#include <utilities/Utilities.mqh> 
#include <utilities/Downloader.mqh> 

struct CalendarEvent {
   string   title, country, impact, forecast, previous;
   datetime date, time; 
}; 


//--- Source for downloading calendar data 
enum Source { FXFactory, Robots4Forex }; 


//--- Source for time conversion 
enum TimeConversion { GMT, Server, Local };

#define FXFACTORY_WEEKLY_URL     "https://nfs.faireconomy.media/ff_calendar_thisweek.csv";
#define R4F_WEEKLY_URL           "http://www.robots4forex.com/news/week.php";


class CCalendarDownload : public CDownloader {
   protected:
      void        ParseFXFACTORYResponse();
      void        ParseR4FResponse();
      string      ParseImpact(string impact);
    
   private: 
      TimeConversion time_mode_; 
      Source      data_source_; 
   public:
      CCalendarDownload():time_mode_(Server), CDownloader(){};
      CCalendarDownload(string path, int timeout):CDownloader(path, timeout){};
      CCalendarDownload(string path, int timeout, TimeConversion mode):time_mode_(mode),CDownloader(path,timeout){}; 
      CCalendarDownload(string path, int timeout, TimeConversion mode, Source src) : time_mode_(mode), data_source_(src), CDownloader(path, timeout) {}
      ~CCalendarDownload(){};
      
      void           TimeMode(TimeConversion value)      { time_mode_ = value; }
      TimeConversion TimeMode() const                    { return time_mode_; }
      
      void           DataSource(Source value)            { data_source_ = value; }
      Source         DataSource() const                  { return data_source_; }
      
      CalendarEvent     Events[];
      int         Count; 
      
      
      bool        DownloadFile(string file_name);
      string      URL();
      int         ResetEvents();
      int         Offset(); 
};



string   CCalendarDownload::URL() {
   
   switch(data_source_) {
      case FXFactory: return FXFACTORY_WEEKLY_URL;
      case Robots4Forex: return R4F_WEEKLY_URL;
      default: return "";
   }
}


string   CCalendarDownload::ParseImpact(string impact) { 
   if (impact == "H") return "High";
   if (impact == "M") return "Medium";
   if (impact == "L") return "Low";
   if (impact == "N") return "Neutral"; 
   return "";
}


bool     CCalendarDownload::DownloadFile(string file_name) { 

   ResetEvents();
   
   string   url      = URL();
   Console_.LogInformation(StringFormat("Downloading calendar data. Source: %s, URL: %s",
      EnumToString(data_source_),
      url), __FUNCTION__); 
   bool     result   = CDownloader::Download(url, file_name);
   if (!result) return false; 
   
   switch (data_source_) {
      case FXFactory:  ParseFXFACTORYResponse(); break; 
      case Robots4Forex:        ParseR4FResponse();  break;
   }
   
   return true;
   
}

int      CCalendarDownload::ResetEvents(void) { 
   ArrayFree(Events);
   ArrayResize(Events, 0);
   return ArraySize(Events);
}


void     CCalendarDownload::ParseR4FResponse(void){
   string lines[], columns[], date_parts[];
   int size = StringSplit(response_, '\n', lines);
   
   Count = size - 1; 
   ArrayResize(Events, Count);
   
   for (int i = 0; i < Count; i++) {
      #ifdef __MQL4__ 
      StringSplit(StringTrimLeft(StringTrimRight(lines[i+1])), ',', columns);
      #endif 
      #ifdef __MQL5__
         StringTrimRight(lines[i + 1]);
         StringTrimLeft(lines[i + 1]);
         StringSplit(lines[i + 1], ',', columns);
      #endif
      int num_columns = ArraySize(columns);
      
      if (num_columns == 0) continue;
      if (StringFind(columns[0], "/", 0) < 0) continue;
      
      // build date string YYYY.MM.DD HH:MM from M/D/YYYY
      StringSplit(columns[0], '/', date_parts);
      string datetime_string = StringFormat("%s.%s.%s %s", date_parts[0], date_parts[1], date_parts[2], columns[1]);
      MqlDateTime r4fdate; 
      TimeToStruct(StringToTime(datetime_string), r4fdate); 
      r4fdate.hour = r4fdate.hour + Offset(); 
      
      datetime r4fdatetime = StructToTime(r4fdate);
      
      Events[i].time = r4fdatetime;
      Events[i].country = columns[2];
      Events[i].impact = ParseImpact(columns[3]);
      Events[i].title = columns[4];
      
   }
}


void     CCalendarDownload::ParseFXFACTORYResponse(void){
   string   lines[];
   string   columns[];
   int      size  =  StringSplit(response_, '\n', lines);
   
   //Remember the size includes the heading line
   Count    =  size - 1;
   ArrayResize(Events, Count);
   string   dateParts[];
   string   timeParts[];
   for (int i = 0; i < Count; i++){
      #ifdef __MQL4__
         StringSplit(StringTrimLeft(StringTrimRight(lines[i + 1])), ',', columns);
      #endif
      #ifdef __MQL5__
         StringTrimRight(lines[i + 1]);
         StringTrimLeft(lines[i + 1]);
         StringSplit(lines[i + 1], ',', columns);
      #endif
      // some items are simple strings
      Events[i].title   =  columns[0];
      Events[i].country =  columns[1];
      Events[i].impact  =  columns[4];
      
      //Date and time are stored separately and not in a format 
      //easy to convert
      //stored as MM-DD-YYYY HH:MM(am/pm)
      //break up the date and time into parts
      StringSplit(columns[2], '-', dateParts);
      StringSplit(columns[3], ':', timeParts);
      
      // converting am/pm to 24h 
      if (timeParts[0] == "12"){
         timeParts[0]   =  "00";
      }
      // if pm just add 12 hrs
      if (StringSubstr(timeParts[1], 2, 1) =="p"){
         timeParts[0]   =  IntegerToString(StringToInteger(timeParts[0] + (string)12));
      }
      // take only the first 2 characters from the minutes (remove am/pm)
      timeParts[1]   = StringSubstr(timeParts[1], 0, 2);
      
      //Join back to YYYY.MM.DD HH:MM
      string timeString = dateParts[2] + "." + dateParts[0] + "." + dateParts[1]
                           + " " + timeParts[0] + ":" + timeParts[1];
                  
      Events[i].time    =  StringToTime(timeString);
      MqlDateTime adjTime;
      TimeToStruct(Events[i].time, adjTime);
      adjTime.hour = adjTime.hour + 3;
      
      Events[i].time    = StructToTime(adjTime);
      
      
      
      //Values in forecast and previous may be in different formats
      // just store as string to make it simple
      Events[i].forecast   =  columns[5];
      Events[i].previous   =  columns[6];
   }
   
  
}

int         CCalendarDownload::Offset() {
   switch(time_mode_) {
      case Server: return UTIL_SERVER_GMT_OFFSET(); 
      case Local: return UTIL_LOCAL_GMT_OFFSET(); 
   }
   return 0; 
}