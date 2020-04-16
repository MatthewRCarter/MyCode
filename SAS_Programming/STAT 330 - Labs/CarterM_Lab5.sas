*I feel like my code is very close, but I could not get my computer to recognize the NY dataset, so it
would not fully run on my machine-- hopefully it is just a minor syntax error that I couldn't find!;


libname gymtimes "/folders/myfolders/permdata/";

data gym; 
set gymtimes.NewYears;

*Creates arrays for each persons' arrival and checkout time for the 119 observedd days;
	array checkin (119) inday1-inday119;
	array checkout (119) outday1-outday119;
	array duration (119) ;

	set gymtimes.newyears;

*run do loop to see the distribution of when people are arriving at the gym and calculate the amount 
of minutes they spent at the gym;
	do i = 1 to 119;
		duration(i) = ((checkout(i) - checkin(i))/60);
		if 18000 < checkin(i) < 36000 then type = "Early-Birds";
		else if 36000 < checkin(i) < 61200 then type = "Afternooners";
		else if 61200 < checkin(i) < 79200 then type = "Late-Nighters";
		end;

*calc average duration and check in time for each gym goer;
	avgduration = mean(of duration(*));
	avgcheckin = mean(of checkin(*));

	run;

proc print data = gym;
format avgchecckin TIME8.;
run;

*created 3 seperate datasteps as to be able to use proc print steps on each of the 3 types of
gym goers;
proc print data = gym;
title "Afternooners";
format avgcheckin TIME8.;
where type = "Afternooners";
run;

proc print data = gym;
title "Early-Birds";
format avgcheckin TIME8.;
where type = "Early-Birds";
keep avgcheckin avgduration type;
run;

proc print data = gym;
title "Late-Nighters";
format avgcheckin TIME8.;
where type = "Late-Nighters";
run;







