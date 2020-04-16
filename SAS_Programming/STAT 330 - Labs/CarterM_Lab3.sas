/*-------------------------------------*
 Name: Matthew Carter                 
 Date: October 7th 2018              
 Assignment: Lab 3                    
*-------------------------------------*/

%macro day_counter(day=);
	data sundaycounter;
	counter = 0;
	
	*this is a nested do loop, going through each month of each year from 1901 to 2000, checking each first 
	of the month to check if it is a sunday-- if it is, its adds to the variable Sunday (sunday ticker);
	
	do year = 1901 to 2000;
		do month = 1 to 12; 
			date = mdy(month, 1, year);
			if weekday(date) = &day then counter = counter + 1;
			if &day = 1 then Weekday = "Sun";
			else if &day = 2 then Weekday = "Mon";
			else if &day = 3 then Weekday = "Tue";
			else if &day = 4 then Weekday = "Wed";
			else if &day = 5 then Weekday = "Th";
			else if &day = 6 then Weekday = "Fri";
			else Weekday = "Saturday";
		end;
	end;
	drop year month date
	run;

	
	*print statement with correct format to increase output readibility;
	proc print data = sundaycounter;
		format date MMDDYY10.;
		title "This is how many day = &day are the first of a month";
	run;
%mend day_counter;

%day_counter(day = 1);
%day_counter(day = 2);
%day_counter(day = 3);
%day_counter(day = 4);
%day_counter(day = 5);
%day_counter(day = 6);
%day_counter(day = 7);



%macro shifting_center(n1=,n2=,z=,a=,b=);	
	data centralLimit;
	
	
	*The theoretical means of each sample mean stays the same for each size sample (n=50 and n=150) if they have 
	the same distribution.It remains as stated in #2, at mu=5. 
	
	The theoretical standard deviations of each all the sample means will be calculated like so:
	S.D(n=50) = 2.89/sqrt(50) = 0.409
	S.D(n=150) = 2.89/sqrt(150) = 0.236
	
	This inituitively makes sense as we expect the larger sample size to have a smaller S.D.;
	
	array sample50 (&n1) ;
	array means50 (&z) ;
	array sample150 (&n2) ;
	array means150 (&z) ;
	
	do i = 1 to &z;
		do n = 1 to &n1;
			sample50(n) = rand("uniform", &a, &b);
		end;
		
	* Here I am taking the mean of each sample of n=50 to create the mean of many sample means.
	  Each mean of the n=50 samples are stored in the array means50;
	  
		avg50 = mean(of sample50(*));
		means50(i) = avg50; 
	end;
	
	do i = 1 to &z;
		do n = 1 to &n2;
			sample150(n) = rand("uniform", &a, &b);
		end;
		
	*same process as with the n=50 samples;
		
		avg150 = mean(of sample150(*));
		means150(i) = avg150;
	end;
	
	*calculate the mean and standard deviation of the 500 samples (n=50 and n=150);
	
	mean50 = mean(of means50(*));
	mean150 = mean(of means150(*));
	std50 = std(of means50(*));
	std150 = std(of means150(*));
	
	keep mean50 mean150 std50 std150;
	
	run;
	
	proc print data = centralLimit;
	title "This is the mean of the &z samples of &n1 and &n2 sample sizes with the distribution from &a to &b";
	run;

%mend shifting_center;

%shifting_center(n1=50,n2=150,z=500,a=0,b=10);
%shifting_center(n1=25,n2=100,z=200,a=0,b=20);


%macro party_days(month=,day=,current=,n=);
	data birthday_fun;
	
	
	do i = 0 to &n;
		dayofweek = weekday(mdy(&month, &day, &current + i));
		party1 = nwkdom(2,6,&month,&current + i);
		party2 = nwkdom(4,6,&month,&current + i);
		output;
	end;
	drop i;

proc print data = birthday_fun;
format party1 party2 mmddyy10.;
title "For the birthday on &month &day, we will celebrate on these dates";
run;

%mend party_days;

%party_days(month = 3, day = 29, current = 2018, n = 5);




	
	
	

	

