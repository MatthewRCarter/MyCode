/*-------------------------------------*
 Name: Matt Carter                    
 Date: October 10th, 2018            
 Assignment: Lab 4               
*-------------------------------------*/

data debt;
input Name $ School $ Loan Interest CollegeStart NumYears Salary Payment ;

/*initializing the months variable and setting the loan amount equal to the remaining balance*/
months = 0;
balance = Loan;

/*this runs a do loop until the balance of the loan is le to 0, subtracting out payment first 
and then incorporating each persons interest rate in*/
do until (balance <= 0);
	balance = balance - Payment;
	balance = balance + ((Interest/12) * balance);
	months = months + 1;
end;

/*takes into account when each person started college and how long it took them to pay it off to give
us the exact year and when in that year they got their entire loan balance paid off*/

loangone = CollegeStart + NumYears + (months/12);

drop balance;

datalines;
Hank ParkU 45000 .059 2012 4 70000 850
Sarah BlueMtn 40000 .058 2014 4 85000 900
Steve Vassar 204000 .06 2012 5 80000 1200
Chris Trinity 180000 .055 2010 4 90000 925
Emily Amherst 120000 .058 2014 4 75000 950
Jessica Berea 6000 .05 2013 5 65000 800
Mark Rust 38000 .0575 2011 4 60000 850
;

run;

proc print data = debt;
title "Time until debt is paid off";
run;




data incpayments;

input Name $ School $ Loan Interest CollegeStart NumYears Salary Payment ;

/*initializing the months variable and setting the loan amount equal to the remaining balance*/
months = 0;
balance = Loan;

/*this runs a do loop until the balance of the loan is le to 0, subtracting out payment first 
and then incorporating each persons interest rate in*/

do until (balance <= 0);
	balance = balance - Payment;
	balance = balance + ((Interest/12) * balance);
	months = months + 1;

/* this is the addition to the problem for part 2, I use the mod function to increase the salary 
and payment by 3% every year by only increasing when the remainder of month/12 = 0-- if my code is
right, the loangone variable will be earlier then in part 1*/

	if (mod(months, 12) = 0) then do; 
		Salary = Salary + (Salary*.03);
		Payment = Payment + (Payment*.03);
	end;
end;

/*takes into account when each person started college and how long it took them to pay it off to give
us the exact year and when in that year they got their entire loan balance paid off*/

loangone = CollegeStart + NumYears + (months/12);

drop balance;

datalines;
Hank ParkU 45000 .059 2012 4 70000 850
Sarah BlueMtn 40000 .058 2014 4 85000 900
Steve Vassar 204000 .06 2012 5 80000 1200
Chris Trinity 180000 .055 2010 4 90000 925
Emily Amherst 120000 .058 2014 4 75000 950
Jessica Berea 6000 .05 2013 5 65000 800
Mark Rust 38000 .0575 2011 4 60000 850
;

run;

proc print data = incpayments;
title "Time until loan is paid off with salary and monthly payments increasing every 12 months";
run;
