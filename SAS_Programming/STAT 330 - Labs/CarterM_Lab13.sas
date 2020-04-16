******************************
Name: Matthew Carter
Assignment: Lab #13
*****************************;

/* (1) */
%let path = /folders/myshortcuts/SASUniversityEdition/myfolders/;

/* (2) */
proc import
	datafile = "&path.babies.csv"
	out = babydata
	dbms = CSV
	replace;
run;


/* (3) */
	/* (a) */
	*There does appear to be a difference in the baby's weight when comparing
	 mothers who do and do not smoke, as the average baby weight for the mothers
	 who don't smoke is ~9oz higher then for those who do;
	proc means data = babydata;
		var bwt; 
		class smoke;
	run;
	
	/* (b) */
	proc means data = babydata;
		var bwt; 
		class smoke;
		output out = summarystats;
	run;

	proc print data = summarystats;
	run;
	/* (c) */
	proc transpose
		data = summarystats
		out = stats_transposed 
		Name = var;
		ID _stat_;
		by smoke;
		var bwt;
	run;

proc print data = stats_transposed;
run;


	
	/* (d) */
		/* (i) */
		/* (ii) */
		/* (iii) */
		data stats_formatted;
			set stats_transposed;
			
			if smoke = 0 then do smoke1 = "Non-Smoking Mothers";
			end;
			else if smoke = 1 then do smoke1 = "Smoking Mothers";
			end;
			else smoke1 = "All Mothers";
			
			drop var smoke;
		run;

proc print data = stats_formatted;
	format mean std comma5.1;
run;
		
			
	/* (e) */
	proc export 
		data = stats_formatted
		outfile = "&path.BabiesSummaryStats.csv"
		dbms = csv
		replace;
	run;
	

/* (4) */
	/* (a) */
	proc reg data = babydata;
		model bwt = gestation parity age height weight smoke;
	quit;
	
	/* (b) */
		
		/* (i) */
		*Not all of the variables are significant at the 5% sig level. Age has a
		 p-value = 0.9170. This is the only non-significant variable.;
		
		/* (ii) */
		*The variables with a negative association with baby weight are parity (ways less
		 if not the first baby), age (if we are still counting it), and if the mother smokes;
	
	/* (c) */
	*Observations 71, 73, 93, and 146 ave residuals over 50oz;
	
	proc reg data = babydata;
		model bwt = gestation parity age height weight smoke / r;
		output out = b
		p = yhat
		r = yresid;
	quit;
	
	proc sort data = b;
	by yresid;
	run;
	
	proc print data = b;
	run;
	
	data b_filtered;
		set b;
		if abs(yresid) < 50 then delete;
	run;
	
	proc print data = b_filtered;
	run;
	
	proc export 
		data = b
		outfile = "&path.BabiesResids.csv"
		dbms = csv
		replace;
	run;
		
	

	
	/* (d) */


			r = yresid;

