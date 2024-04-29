
/*
   This script contains generic console logging functions.
   
   Allows logging information, sending notifications, alerts, errors, and implementation errors. 
*/


#include <utilities/Utilities.mqh> 

class CConsole {

private:
               bool     logging_allowed_, notification_allowed_, alert_allowed_; 
public:
   CConsole(bool logging, bool notify, bool alerts);
   ~CConsole(); 
            
   const       bool     LoggingAllowed()  const       { return logging_allowed_; }
   const       bool     NotificationAllowed() const   { return notification_allowed_; }
   const       bool     AlertAllowed() const          { return alert_allowed_; }
               
               void     Status(); 

   virtual     void     LogInformation(string message, string function, bool debug=false, bool notify=false); 
   virtual     void     LogDebugInformation(string message, string function); 
   virtual     void     LogNotification(string message); 
   virtual     void     LogAlert(string message); 
   virtual     void     LogError(string message, string function); 
   virtual     void     LogNotImplemented(string function); 

}; 



CConsole::CConsole(bool logging, bool notify, bool alerts)
   : logging_allowed_(logging)
   , notification_allowed_ (notify)
   , alert_allowed_ (alerts) {
    
   }

CConsole::~CConsole() {

}

void        CConsole::Status() {
   PrintFormat("Logging Allowed: %s, Notification Allowed: %s, Alert Allowed: %s", 
      (string)LoggingAllowed(), 
      (string)NotificationAllowed(), 
      (string)AlertAllowed()); 
}

void        CConsole::LogInformation(string message, string function, bool debug=false, bool notify=false) {
   if (!LoggingAllowed()) return; 
   if (debug) {
      LogDebugInformation(message, function); 
      return; 
   }
   
   PrintFormat("LOGGER - %s: %s", function, message); 
}

void        CConsole::LogDebugInformation(string message,string function) {
   
   PrintFormat("DEBUGGER - %s: %s", function, message); 
}

void        CConsole::LogNotification(string message) {
   if (UTIL_IS_TESTING()) return; 
   if (!NotificationAllowed()) return; 
   ResetLastError(); 
   
   if (!SendNotification(message)) 
      LogInformation(StringFormat("Failed to send notification. Code: %i", GetLastError()), __FUNCTION__);  
}

void        CConsole::LogAlert(string message) {
   if (!AlertAllowed()) return; 
   Alert(message); 
}

void        CConsole::LogError(string message, string function) {
   PrintFormat("ERROR - %s: Code: %i, Message: %s", function, GetLastError(), message);
}

void        CConsole::LogNotImplemented(string function) {
   PrintFormat("%s: Function not implemented.", __FUNCTION__); 
}