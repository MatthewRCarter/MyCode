***************************************
Name: Matthew Carter
Assignment: Lab #9
**************************************;

libname flash "C:\Users\statstudent.CALPOLY\Downloads";

proc contents data = flash.mariokart;
run;


*1. Observation #20 and #65, both are auctions that include a lot more then just Mario
	Kart, which is why they are much more expensive then the others;

*2. Because the two outliers were the only observations above $100 total price, I used
	a conditional statement to delete all observations with Total Price > $100;

*3 & 4. Used a conditional to create a dummy variable for the previously non-numeric variables
	    of cond and stockphoto;

data mario;
		set flash.mariokart;
		if totalPr > 100 then delete;

		if cond = "new" then cond1 = 1;
		else if cond = "used" then cond1 = 0;

		if stockphoto = "yes" then photo1 = 1;
		else if stockphoto = "no" then photo1 = 0;

		if wheels ge 2 then wheelsnew = 2;
		else if wheels = 1 then wheelsnew = 1;
		else if wheels = 0 then wheelsnew = 0;
	run;

	proc print data = mario;
	run;


*5. 
	*a. Yes you can use a Proc Anova statement, as long as you use wheelsnew in a 
	   class statement-- Even though those being sold with 0 wheels have slightly less 
		in their sample, it is balanced enough to warant using proc anova;

	*b. After conducting a t-test, a t-score = 123.18 and p-value <.0001 indicates that 
	   the number of wheels is a significant predictor of total price at a = .05.;

		Proc anova data = mario;
		class wheelsnew;
		model totalPr = wheelsnew;
		means wheelsnew / tukey lines hovtest;
		quit;


	*c.  According to our pairwise comparison, none of the comparisons contain zero
		and therefore are statistically significant at the 5% significanc level.;
		Proc anova data = mario;
		class wheelsnew;
		model totalPr = wheelsnew;
		means wheelsnew / tukey hovtest;
		quit;


	*d. 
		(1) observations are independant
		(2) n>=30 in each group
		(3)each group has about the same variability;


*6. 
	a; 
		Proc corr data = mario;
		var totalPr;
		with duration nBids startPr shipPr SellerRate;
		run;

	*b. Suprisingly, Duration was the variable with the strongest correlation to
		total price. With an r = -0.37416 and an R^2 = .1400, this means that the 14.00%
		of the variance in Total Price can be explained by variance in Duration.

	 c. totalPr(hat) = 52.37358 - 1.31716(duration);

	proc reg data = mario;
		model totalPr = duration;
	run;

	*d. Yes, the conditions are satisfied

		(1) observations are independant
		(2) there is a moderate to weak linear relationship
		(3) errors or normally distributed
		(4) there is constant variance in y around the regression line 

	*e. variables = duration nBids startPr sellerRate wheels cond1;

proc reg data = mario;
model totalpr = duration nBids startPr shipPr SellerRate wheels cond1 photo1/ selection =  ADJRSQ;
run;

		
