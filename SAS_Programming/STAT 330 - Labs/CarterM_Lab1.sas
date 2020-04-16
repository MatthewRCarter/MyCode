*Matthew Carter;
*STAT 330;
*Professor Glanz;
*September 26, 2018;


data JoeMoney;

*Here I am calculating the time Joe has until he is 16 and 18, respectively. I then
initialize my car savings and college savings variables;

name = "Joe";
now = today();
Jbday = mdy(3,15,2013);
Jsixteen = yrdif(now,mdy(3,15,2029),'Actual');
Jeighteen = yrdif(now,mdy(3,15,2031),'Actual');
carsavings = 600;
collegesavings = 12000;

*I decided to use a do loop to determine how much Joe's parents can save between 
now and the time he turns 16 for his car purchase;
 
	do i = 1 to jsixteen;
		
		carsavings = (carsavings + 600) * 1.02;
		
		
	end;

*Here I used an if statement to determine if his parents had saved enough money ($10,000) 
to buy the used car (yes = Good News and no =  Bad News);

	if carsavings >= 10000 then Car = "Good News";
	else Car = "Bad News";
	
*I repeated the same process for the college savings;	

	do i = 1 to jeighteen;
		
		collegesavings = (collegesavings + 10000) * 1.03;
		
	end;
	
	if collegesavings >= 100000 then College = "Good News";
	else College = "Bad News";

*Here I drop the unneccessary variables from the output;

drop now Jbday i;

run;


*This is my print statement;
proc print data = JoeMoney;
run;


Data MitchMoney;

*Here I am calculating the time Mitch has until he is 16 and 18, respectively. I then
initialize my car savings and college savings variables;

name = "Mitch";
now = today();
Mbday = mdy(1,15,2010);
Msixteen = yrdif(now,mdy(1,15,2026),'Actual');
Meighteen = yrdif(now,mdy(1,15,2028),'Actual');
carsavings = 600;
collegesavings = 12000;
	
*I decided to use a do loop to determine how much Mitch's parents can save between 
now and the time he turns 16 for his car purchase;

	do i = 1 to msixteen;
		
		carsavings = (carsavings + 600) * 1.02;
		
	end;

*Here I used an if statement to determine if his parents had saved enough money ($10,000) 
to buy the used car (yes = Good News and no =  Bad News);
	
	if carsavings >= 10000 then Car = "Good News";
	else Car = "Bad News";
	
*I repeated the same process for the college savings;	
	
	do i = 1 to meighteen;
		
		collegesavings = (collegesavings + 10000) * 1.03;
		
	end;
	
	if collegesavings >= 100000 then College = "Good News";
	else College = "Bad News";

*Here I drop the unneccessary variables from the output;

drop now Mbday i;

run;


*This is my print statement;
proc print data = MitchMoney;
run;


Data ScottMoney;

*Here I am calculating the time Scott has until he is 16 and 18, respectively. I then
initialize my car savings and college savings variables;

name = "Scott";
now = today();
Sbday = mdy(11,25,2006);
Ssixteen = yrdif(now,mdy(11,25,2022),'Actual');
Seighteen = yrdif(now,mdy(11,25,2024),'Actual');
carsavings = 600;
collegesavings = 12000;

*I decided to use a do loop to determine how much Scott's parents can save between 
now and the time he turns 16 for his car purchase;

	do i = 1 to Ssixteen;
		
		carsavings = (carsavings + 600) * 1.02;
		
	end;

*Here I used an if statement to determine if his parents had saved enough money ($10,000) 
to buy the used car (yes = Good News and no =  Bad News);
	
	if carsavings >= 10000 then Car = "Good News";
	else Car = "Bad News";

*I repeated the same process for the college savings;	
	
	do i = 1 to Seighteen;
		
		collegesavings = (collegesavings + 10000) * 1.03;
		
	end;
	
	if collegesavings >= 100000 then College = "Good News";
	else College = "Bad News";

*Here I drop the unneccessary variables from the output;

drop now Sbday i;

run;


*This is my print statement;
proc print data = ScottMoney;
run;

