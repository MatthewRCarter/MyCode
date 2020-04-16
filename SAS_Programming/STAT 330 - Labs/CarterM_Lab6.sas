libname labsix "/folders/myfolders/Lab #6/";


proc contents data = labsix.craftbeer;
run;


proc means data = labsix.craftbeer;
run;
/* 2. The mean size of craft beer is 13.59 oz in this dataset
   3. The mean abv of craft beer is 5.977% */

   
   

proc freq data = labsix.craftbeer order = freq;
table brewery;
run;
/* 4. The 3 breweries who produce the most types of beer are Brewery Vivant (62),
      Oskar Blues Brewery (46), and Sun King Brewing Company (38). Of the smallest
      breweries, there are 119 that only produce 1 beer. */
  
 
 
 proc freq data = labsix.craftbeer;
 table abv*brewery / list;
 run;
/* 5. The 3 breweries with the highest abv's are Tin Man Brewing Company (12%),
	  Against the Grain Brewery (12.5%), and Upslope Brewing Company (12.8%)
	  The 3 breweries with the lowest abv's are are Uncommon Brewers (.1%), Evil 
	  Twin Brewing (.27%), and Hopworks Urban Brewery (.27%)*/


proc freq data = labsix.craftbeer order = freq;
table city;
run;
/* 6. The 3 cities with the largest number of craft beers produced are Grand Rapids (66), 
      Portland (64), and Chicago (55). Boston came in pretty high on the list with (22) 
      types of craft beer produced. */



proc freq data = labsix.craftbeer order = freq;
table style;
run;
proc means data = labsix.craftbeer order = freq;
class style;
var abv oz;
run;
/* 7. If were are talking about specific types of American IPAs, American Ales, and American
      Lagers, then the American IPA holds the largest portion of the craft beer market at 17.63%
      of the market, with American Pale Ales coming in with 10.19% of the market, and American
      Lagers coming in with 1.62% of the market. */
     


proc format;
value PintSize 0 -< 16 = "Sub-Pint"
			   16 = "Pint"
			   16.1 -< 100 = "Super-Pint";

proc print data = labsix.craftbeer;
format oz PintSize.;
run;
/* 8. used proc format to assign values to the OZ variable based on the size of the recommended beer */
      

      

