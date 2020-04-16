*1. For each of the following scenarios, implement the appropriate statistical method. In a
comment in your SAS code, indicate (1) the method you chose, and (2) a brief interpretation
of your results. All tests may be done at the a = 0.05 level of significance;

libname flash "C:\Users\liblabs-user\Desktop";

proc contents data = flash.lead;
run;

*(a) Researchers would like to know if population average lead blood concentration changed
between 1972 (Ld72) and 1973 (Ld73);

	*To see whether the average lead blood concentration between 1972 and 1973 were different, 
	I conducted a paired t-test which tests whether the means are not statisically different(Ho).
	After conducting the t-test, I found that the two means were statistically significant. With 
	an alpha level of .05, we got a p-value of .0003, indicating there was a change in the average
	level of lead found in the blood of the samples from 1972 to 1973;

	proc ttest data = flash.lead alpha = .05;
	paired Ld72*Ld73;
	run;

*(b) The CDC recommends that “safe” limits for lead blood levels to be no more than 5
micrograms per 100 mL. Did the population average in 1973 (Ld73) exceed this safe
limit?;

	*I used a proc mean with the Ld73 data to find the mean lead level from the data.
	The average blood lead levels per 100ml was 31.7096774 micrograms, far higher then
	the DCD recomendation of 5 micrograms.;

	proc means data = flash.lead;
	var Ld73;
	run;

*(c) Describe the strength of the association between verbal IQ (Iqv) and performance IQ
2(Iqp);

	*I decided to use a proc reg to determine the association between the two variables.
	After conducting the proc reg, the two variables have a .33 R-squared value, indicating
	that 33% of the variability in verbal IQ (Iqv) can be expained by variance in performance
	IQ 2 (Iqp);

	proc reg data = flash.lead;
	model Iqv = Iqp;
	run;

*(d) Does population average left hand finger wrist tapping ability (FWT l) differ by whether
or not children were in the lead or control group (Group)?;

	*I decided to use a proc anova to test whether left finger wrist tapping ability differed 
	among those in the test group vs the control group. With a p-value of .0794 and an alpha 
	level of .05, I would fail to reject the null hypothesis that left finger wrist tapping 
	ability differed among those in the test group vs the control group;

	proc anova data =  flash.lead;
	class Group;
	model FWT_l = Group;
	run;


*2. As you can see, there is a lot of data to analyze!;

*(a) Create a macro that can perform a two-sample t-test with the following four parameters:
• dsn - data set name
• quantvar - the quantitative variable to analyze
• catvar - the categorical grouping variable
• siglev - the level of significance
• doplot - this should take two values (please review macro conditional logic for this
one!):
Y - all two sample t-test plots produced
N - no plots produced

(b) Your SAS output should have an informative title that displays information about the
macro variables.;

%macro labtesting(dsn=,quantvar=,catvar=,siglev=,doplot=);
	proc ttest data = &dsn alpha = &siglev;
		var &quantvar;
		class &catvar;
		title "From dataset &dsn, this is testing if &catvar effects &quantvar at alpha = &siglev";
		run;

	%if &doplot = "Y" %then %do;
		proc sgplot data = &dsn;
		vbox &quantvar / category = &catvar;
		run;
	%end;
	%else %do;
	run;
	%end;
%mend labtesting;
	

*(c) Execute your macro for the following two scenarios to test it out:

• At the 0.01 significance level, does population average full scale IQ (Iqf) differ by
whether or not the children had pica (Pica)? Do not produce any plots.;

%labtesting(dsn=flash.lead,quantvar=Iqf,catvar=Pica,siglev=.01,doplot=N);

*• At the 0.05 significance level, does population average visual reaction time in the
left hand (Visrea l) differ by gender (Sex)? Do produce plots;

%labtesting(dsn=flash.lead,quantvar=Visrea_l,catvar=Sex,siglev=.05,doplot=Y);



*(d) Investigate the effects of lead poisoning on your own by choosing three quantitative
variables of interest to you. Execute your macro on these three variables with the
categorical grouping variable of Group to see if the lead and control groups have different
characteristics. In a comment in your SAS code, note which variable(s) has the
strongest evidence of an association with Group.;


%labtesting(dsn=flash.lead,quantvar=X2Plat_r,catvar=Group,siglev=.01,doplot=N);
*Testing # of taps for right hand in the 2-plate tapping test against the two
control groups, I wanted to see if the lead group would have less average taps.
With a p-value of .8239, it does not seem that the control group has a statistically
significant advantage in this test;


%labtesting(dsn=flash.lead,quantvar=Iqv_ar,catvar=Group,siglev=.01,doplot=N);
*Testing arithmetic subtest in WISC and WPPSI against the two control groups, I 
wanted to see if the lead group would have a decreased avg score. With a p-value of 
.5521, it does not seem that the control group has a statistically significant 
advantage in this test;



%labtesting(dsn=flash.lead,quantvar=Iqp_oa,catvar=Group,siglev=.01,doplot=N);
*Testing object assembly subtest (WISC), animal house subtest (WPPSI) against the two
control groups, I wanted to see if the lead group would have decreased motor skills.
With a p-value of .1307, it does not seem that the control group has a statistically
significant advantage in this test, although there does appear to be some difference 
amongst the two groups;
