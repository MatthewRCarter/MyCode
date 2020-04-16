*****************************
Name: Matthew Carter
Assignment: Lab 14
****************************;

/* (1) */
%let path = C:\Users\liblabs-user\Desktop\;

/* (2) */
libname flash "&path";

/* (3) */
	/* (a) Each country defines "boy" and "girl" in their own language, so the variable names
		   must be made the same in order to properly combine datasets*/
data aus;
		set flash.australia;
	run;
proc contents data = aus; run;

data can;
		set flash.canada;
	run;
proc contents data = can; run;

data brz;
		set flash.brazil;
	run;
proc contents data = brz; run;

data fra;
		set flash.france;
	run;
proc contents data = fra;run;

data ind;
		set flash.india;
	run;
proc contents data = ind; run;

data russ;
		set flash.russia;
	run;
proc contents data = russ; run;

data US;
		set flash.unitedstates;
	run;
proc contents data = US; run;

	/* (b/c/d/e) */

data brz_new;
	set brz;
	rename Menina=Girl Menino=Boy;
	rank  = _N_;
	country = "Brazil";
run;


data aus_new;
	set aus;
	rank  = _N_;
	country = "Australia";
run;


data fra_new;
	set fra;
	rename Fille=Girl Garcon=Boy;
	country = "France";
	rank  = _N_;
run;

data ind_new;
	set ind;
	rename Laraki=Girl Laraka=Boy;
	rank  = _N_;
	country = "India";
run;


data russ_new;
	set russ;
	rename Devushka=Girl Malchik=Boy;
	rank  = _N_;
	country = "Russia";
run;

data us_new;
	set us;
	rank  = _N_;
	country = "United States";
run;

data merged;
	set aus_new brz_new fra_new ind_new russ_new us_new;
	by rank;
run;

proc print data = merged;
run;

/* (4) */
	/* (a) There are 1797 observations in users and 7266 observatios in projects. I plan on using a 
		   one to many merge because there are multiple projects associated with a single User ID */
	data users;
		set flash.users;
	run;
	data projects;
		set flash.projects;
	run;
	
	proc contents data = users; run;
	proc contents data = projects; run;


	/* (b) */
	proc sort data = users;
	by UserID;
	run;
	proc sort data = projects;
	by UserID;
	run;

	data ITS;
		merge users projects;
		by UserID;
	run;

	proc print data = ITS; run;
	*There at 7273 observations in the new data set;

	/* (c) */
	data inc_proj;
		set ITS;
		if EndDate ^= . then delete;
	run;
	proc contents data = inc_proj; run;

	data comp_proj;
		set ITS;
		if EndDate = . then delete;
	run;
	proc contents data = comp_proj; run;

	data no_proj;
		set ITS;
		if ProjectID ^= . then delete;
	run;
	proc print data = no_proj; run;


	/* (d) */
		/* (i) */
		data d_i;
			set comp_proj;
			by UserID;

			if first.UserID then do;
				num_projects = 0;
			end;

			num_projects + 1;
		run;

		proc print data = d_i; run;

		/* (ii/iii) Joseph Turner had the most completed projects with 8*/
		proc sort data = d_i;
			by num_projects;
		run;
		proc print data = d_i; run;

		/* (iv) */
		proc print data = ITS;
		where UserID = 1669;
		run;


