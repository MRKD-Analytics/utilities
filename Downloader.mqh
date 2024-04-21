
/*

   Base class for downloading from a specified url 

*/

#include <utilities/Console.mqh>


class CDownloader {
protected: 
   string   path_, response_; 
   int      timeout_, error_; 
   
  
   CConsole *Console_;

private:
   void     RaiseError(const int code); 
public:
   CDownloader();
   CDownloader(string path, int timeout); 
   ~CDownloader() { delete Console_; }; 
   
   //--- WRAPPERS
   
   //--- Read/Write
   void     Path(string value)      { path_ = value; }
   string   Path() const            { return path_; }
   
   void     Timeout(int value)      { timeout_ = value; }
   int      Timeout() const         { return timeout_; }
   
   void     Error(int value)        { error_ = value; }
   int      Error() const           { return error_; }
   
   void     Response(string value)  { response_ = value; }
   string   Response() const        { return response_; }
   
   
   //--- METHODS
   bool     Download(const string url, const string filename); 
   
};

//--- Default Constructor 
CDownloader::CDownloader() 
   : path_("")
   , timeout_(10000) {
   
   Console_ = new CConsole(true, false, false);    
}
   
CDownloader::CDownloader(string path,int timeout) 
   : path_ (path)
   , timeout_(timeout) {
   
   Console_ = new CConsole(true, false, false);   
}
   

bool     CDownloader::Download(const string url,const string filename) {
   
   string file_path  = StringFormat("%s\\%s", Path(), filename);
   string cookie     = NULL;
   string referer    = NULL;
     
   char data[], response[];
   string headers; 
   
   response_ = ""; 
   ResetLastError();
   
   int result  = WebRequest("GET", url, cookie, referer, Timeout(), data, 0, response, headers); 
   if (result < 0) {
      Error(GetLastError()); 
      RaiseError(Error());
      return false; 
   }
   
   response_   = CharArrayToString(response); 
   int handle  = FileOpen(file_path, FILE_WRITE | FILE_BIN); 
   if (handle == INVALID_HANDLE) {
      Error(GetLastError());
      RaiseError(Error());
      return false;   
   }
   
   FileWriteArray(handle, response, 0, ArraySize(response));
   FileFlush(handle);
   FileClose(handle); 
   return true; 

}

void     CDownloader::RaiseError(const int code) {
   #ifdef __MQL5__ 
   switch(code) {
      case ERR_FUNCTION_NOT_ALLOWED: 
         Console_.LogError("Failed to download from URL. Try allowing WebRequest URL in options.", __FUNCTION__); 
         break;
      case ERR_INVALID_HANDLE: 
         Console_.LogError("Failed to open file. Filename may be invalid.", __FUNCTION__);
         break; 
   }
   #endif 
   
   #ifdef __MQL4__
   switch(code) {
      case ERR_FUNCTION_NOT_CONFIRMED:
         Console_.LogError("Failed to download from URL. Try allowing WebRequest URL in options.", __FUNCTION__); 
         break;
      case ERR_FILE_INVALID_HANDLE:
         Console_.LogError("Failed to open file. Filename may be invalid.", __FUNCTION__);
         break;
   }
   #endif
}

