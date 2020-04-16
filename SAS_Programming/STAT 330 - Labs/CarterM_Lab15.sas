*******************************
Name: Matthew Carter
Assignment: Lab #15
******************************;

/* (1) */
	/* (a) In Lab #11, the process of making that table was much more complicated then the
		   strategies we have learned since. In our data steps, we had to use the first and
		   last commands to create tickers that allowed us the gather data for number of 
		   medalists and medals for each country. We also had to sum all of the weights and
		   ages to then devide it by the number of medalists to find averages.*/

	/* (b) In our proc steps, we just had to print with certain restrictions using the where 
		   statement */


/* (2) */
	/* (a) Technically, we did not need to use a data step at all. I chose to use one so I
		   didn't have to use the libreif every time I referenced our data set.*/

	/* (b) In our proc steps, we use proc tabulate to produce our tables. No additional 
		   "prepping" of the data set is neccessary like Lab #11, showing how powerful
		   proc steps like tabulate and report can be.*/

	/* (c.i) 2 Dimensional Table */

	/* (c.ii) Each row is an individual country, while the collumns serve to show us 
			  summary stats for each country.*/


/* (3) */
libname flash "C:\Users\statstudent.CALPOLY\Documents";

/* (4) */
data olympics;
	set flash.o2012;
run;

	/* (a) */
	proc tabulate data = olympics;
	class country;
	table country, ALL;
	run;

	/* (b) */
	proc tabulate data = olympics;
	class country;
	var total;
	table country,ALL total;
	run;

	/* (c) */
	proc tabulate data = olympics;
	class country;
	var total;
	table country, ALL total*(SUM Mean Max);
	run;

	/* (d) */
	proc tabulate data = olympics;
	class country;
	var total age weight;
	table country, ALL total*(SUM Mean Max) age*(Mean) weight*(Mean);
	run;

	/* (e) */
	proc tabulate data = olympics;
	class country gender;
	var total age weight;
	table country,ALL total*(SUM Mean Max) age*(Mean) weight*(Mean) gender*(RowPctN);
	run;

/* (5) */
	proc tabulate data = olympics;
	class country gender;
	var total age weight;
	table country,
		  ALL="# of Medalists" 
		  total="Total Medals"*(SUM Mean="Ratio" Max) 
		  age="Age (yrs)"*(Mean) 
		  weight="Weight (kg)"*(Mean) 
		  gender*(RowPctN);
		  keylabel Max = "Max Per Athlete" Mean = "Average" N=" " RowPctN=" ";
	run;

/* (6) */
	
	/* (a) */
	
	proc tabulate data = olympics;
	class country gender;
	var total age weight;
	table country,
		  ALL="# of Medalists" 
		  total="Total Medals"*(SUM*f=3. Mean="Ratio"*f=5.2 Max*f=3.) 
		  age="Age (yrs)"*(Mean*f=5.1) 
		  weight="Weight (kg)"*(Mean*f=5.1) 
		  gender*(RowPctN);
		  keylabel Max = "Max Per Athlete" Mean = "Average" N=" " RowPctN=" ";
	run;


	/* (b) */
	proc format;
		value $mygender "M"="Male" "F"="Female";
		picture pct(round) low-high='.009.9%';
	run;


/* (7) */
	proc format;
		value num 20-high="blue";
	run; 

	
	proc tabulate data = olympics;
	class country gender;
	var total age weight;
	table country,
		  ALL="# of Medalists"*{style={background=num.}} 
		  total="Total Medals"*(SUM*f=3. Mean="Ratio"*f=5.2 Max*f=3.) 
		  age="Age (yrs)"*(Mean*f=5.1) 
		  weight="Weight (kg)"*(Mean*f=5.1) 
		  gender*(RowPctN);
		  keylabel Max = "Max Per Athlete" Mean = "Average" N=" " RowPctN=" ";
	run;

/* (8) */
	%let path= :\Users\statstudent.CALPOLY\Documents\;

	ods pdf file="&path.Lab15tableQ6.pdf";
	options NODATE ;

	proc tabulate data = olympics;
	class country gender;
	var total age weight;
	table country,
		  ALL="# of Medalists"*{style={background=num.}} 
		  total="Total Medals"*(SUM*f=3. Mean="Ratio"*f=5.2 Max*f=3.) 
		  age="Age (yrs)"*(Mean*f=5.1) 
		  weight="Weight (kg)"*(Mean*f=5.1) 
		  gender*(RowPctN);
		  keylabel Max = "Max Per Athlete" Mean = "Average" N=" " RowPctN=" ";
	run;
