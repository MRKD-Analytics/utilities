

/*
   Calculates different statistical moments given a price series. 
*/

#include <MovingAverages.mqh>


double      CalculateStandardDeviation(int position, int periods, const double &price[]) {

   double sum = 0;
   double mean, sdev; 
   
   if (ArrayGetAsSeries(price)) ArraySetAsSeries(price, false);
   mean = SimpleMA(position, periods, price);
   
   if (position >= periods) {
      for (int i = 0; i < periods; i++) {
         double x_i = price[position-i];
         double diff = MathPow(x_i - mean, 2);
         sum += diff;
      }
   }
   
   sdev = MathSqrt(sum / (periods-1)); 
   return sdev;   
}


double      CalculateSkew(int position, int periods, const double &price[]) {
   
   double sum = 0;
   
   double standard_deviation, mean, skew; 
   
   if (ArrayGetAsSeries(price)) ArraySetAsSeries(price, false); 
   
   standard_deviation = CalculateStandardDeviation(position, periods, price);
   mean = SimpleMA(position, periods, price);
   
   if (position >= periods) {
      for (int i = 0; i < periods; i++) {
         double x_i = price[position - i];
         double diff = MathPow(x_i - mean, 3);
         sum += diff;
      }   
      
      
   }
   if (standard_deviation == 0) return 0;
   skew = (sum) / ((periods - 1) * (MathPow(standard_deviation, 3)));
   return skew;
}

double      CalculateSpread(int position, int periods, const double &price[]) {
   // for univariate mean reversion 
   
   if (ArrayGetAsSeries(price)) ArraySetAsSeries(price, false); 
   
   double price_reference, mean, spread; 
   
   price_reference = price[position];
   
   mean = SimpleMA(position, periods, price);
   
   spread = price_reference - mean;
   return spread;
}


double      CalculateStandardScore (int position, const int period, const double &price[]) {
   /*
   Normalizing with Z Score
   */
   
   if (ArrayGetAsSeries(price)) ArraySetAsSeries(price, false); 
   
   double mu, sigma, spread, z; 
   
   
   mu       = SimpleMA(position, period, price);
   sigma    = CalculateStandardDeviation(position,period, price);
   spread   = price[position];
   
   if (sigma == 0) return 0; 
   
   z = (spread - mu) / sigma;
   return z;
}

