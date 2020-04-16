/*Name: Matthew Carter
Assignment: Lab 7
*************************/

/*---------------------------------------------------------------------------
Question 1 
---------------------------------------------------------------------------*/
*assign a library reference d to my data folder;
libname flash "/folders/myfolders/DATA";

*explore the data set;
proc freq data=flash.adni; run;

/*---------------------------------------------------------------------------
Question 2 
---------------------------------------------------------------------------*/
*create format;
proc format;
value diagnosis 1="Normal"
                2="MCI"
                3="AD";

run;

/*---------------------------------------------------------------------------
Question 3
---------------------------------------------------------------------------*/
*Apply format and label to temporary data set;
data adni;
	set flash.adni;
	format dx diagnosis.;
	label dx="Diagnosis";
run;


/*---------------------------------------------------------------------------
Question 4
---------------------------------------------------------------------------*/
*This sends all graphs to one folder;
ods html gpath = "/folders/myfolders/STAT330/Lab7/Lab7plots/";

*This allows me to name graphs.  The reset=index option overwrites existing 
graphs if the graphs are recreated;
ods graphics on / imagename="Question4a" reset=index;
title "Question 4a";
proc sgplot data=adni;
	vbar dx / group=APOE4 ;
run;
title;
ods graphics off;

ods graphics on / imagename="Question4b" reset=index;
title "Question 4b";
proc sgplot data=adni;
	vbar dx / group=APOE4 groupdisplay=cluster;
run;
title;
ods graphics off;

/*---------------------------------------------------------------------------
Question 5
---------------------------------------------------------------------------*/
proc sort data=adni;
by dx;
run;

ods graphics on / imagename="Question5" reset=index;
title "Question 5";
proc sgplot data=adni;
hbox MMSE / group=dx;
run;
title;
ods graphics off;

/*---------------------------------------------------------------------------
Question 6
---------------------------------------------------------------------------*/
ods graphics on / imagename="Question6a" reset=index;
title "Question 6a";
proc sgplot data=adni;
histogram MMSE /transparency=0.5;
histogram ADAS /transparency=0.5;
run;
title;
ods graphics off;

ods graphics on / imagename="Question6b" reset=index;
title "Question 6b";
proc sgplot data=adni;
histogram MMSE /group=gender transparency=0.5;
run;
title;
ods graphics off;

/*---------------------------------------------------------------------------
Question 7
---------------------------------------------------------------------------*/
ods graphics on / imagename="Question7" reset=index;
title "Question 7";
proc sgplot data=adni;
	scatter y=wholebrain x=age / markerattrs=(symbol=CircleFilled);
run;
title;
ods graphics off;

/*---------------------------------------------------------------------------
Question 8
---------------------------------------------------------------------------*/
%macro make_scatter(cat_var);
title "Scatter plot of whole brain volume versus age by &cat_var";
proc sgplot data=adni;
	scatter y=wholebrain x=age / group=&cat_var markerattrs=(symbol=CircleFilled);
run;
title;
%mend;

ods graphics on / imagename="Question8a" reset=index;
%make_scatter(gender);
ods graphics off;

ods graphics on / imagename="Question8b" reset=index;
%make_scatter(APOE4);
ods graphics off;

ods graphics on / imagename="Question8c" reset=index;
%make_scatter(dx);
ods graphics off;
