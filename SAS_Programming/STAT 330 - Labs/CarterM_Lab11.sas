**********************************
Name: Matthew Carter
Assignment: Lab #11
**********************************;

* (1);
libname flash "C:\Users\statstudent.CALPOLY\Desktop\";

* (2);
proc contents data = flash.o2012;
run;
proc print data = flash.o2012;
run;

*There are 496 obsevations sorted by age.
*The observations represent each person that won a medal at the 2012 olympic games;

* (3);
proc sort data = flash.o2012 out = sorted2012;
	by Country;
run;

proc print data = sorted2012;
run;

* (4);
data lab4_4;
	set sorted2012;
	by Country;

	*initialize variables I will be using to track medal and weight totals;
	if first.Country then do;
		num_medalists = 0;
		num_gold = 0;
		num_silver = 0;
		num_bronze = 0;
		num_total = 0;
		num_wt = 0;
		num_age = 0;
		num_ht = 0;
		num_nomisswt = 0;
		num_realwt = 0;
	end;
*creating running counter of medals, weight, age, and height;
	num_medalists + 1;
	num_gold + Gold;
	num_silver + silver;
	num_bronze + bronze;
	num_total + Total;
	num_wt + weight;
	num_age + age;
	num_ht + height;
	

	if weight ne . then do;
	num_realwt + weight;
	num_nomisswt + 1;
	end;

	If last.Country then do;
		ratio = num_total / num_medalists;
		avg_wt = num_wt / num_medalists;
		avg_age = num_age / num_medalists;
		avg_ht = num_ht / num_medalists;
		avg_wt2 = num_realwt / num_nomisswt;
	end;
	run;

proc print data = lab4_4;
run;


* (5)
	a: A country can't have a ratio of less then 1 because that would mean they have more medalists
	   medals. Since no one can be a medalist and have less then one medal, a ratio < 1 is impossible.
	b: Spain and Great Britain have a ratio less then one. I combed through that data and only found two countries.
	
	c;
	proc freq data = lab4_4;
	where ratio < 1;
	run;

* (6);
	*a&b;
	proc print data = lab4_4;
	where weight = .;
	run;
*The 6 sports with missing weight are rowing, gymastics, shooting, cycling, fencing, and trampoline.
*By an overwhleming amount, Gymastics has the most missing weight values.;

	*c done above;

	*d;

	proc means data = lab4_4;
	by Country;
	where avg_wt2 ne .;
	run;


* (7);
	proc means data = lab4_4;
	Var avg_age avg_wt2 avg_ht;
	by Country;
	run;
	
