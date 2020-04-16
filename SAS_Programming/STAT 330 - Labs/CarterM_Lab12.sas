*******************************************
Name: Matthew Carter
Assignment: Lab #12
******************************************;

/* (1)  */
%let path = C:\Users\statstudent.CALPOLY\Desktop\;

/* (2)  */

*(a) After looking at the file in notepad, I will be using a space deliminator. The problem
	 with this is that some of the variables have spaces in it, which will have to be addressed
	 in the code. Also, the date will have to be formatted into a more readable format;

*(b);
data rosebowl;
	infile "&path.rosebowl.dat";
	input Game_Date Date11.
		  Home_Team $ &22.
		  Home_Team_Score
		  Away_Team $ &22.
		  Away_Team_Score;

run;

*(c);
proc print data = rosebowl;
format Game_Date Date11.;
run;

*(d);
data newset1;
	set rosebowl;
	if Home_Team_Score > Away_Team_Score then Winning_Team = "Home Team Wins!";
	else if Home_Team_Score < Away_Team_Score then Winning_Team = "Away Team Wins!";
	else do Winning_Team = "Tie";
	end;

	set rosebowl;
	if Home_Team_Score > Away_Team_Score then Winning_Team1 = Home_Team;
	else if Home_Team_Score < Away_Team_Score then Winning_Team1 = Away_Team;
	else do Winning_Team1 = "Tie";
	end;
run;

proc print data = newset1;
format Game_Date Date11.;
run;

*(d) There were 3 ties in the rosebowl data;
proc freq data = newset1;
where Winning_Team = "Tie";
run;


proc sort data = newset1 out = newset2;
	by Winning_Team1;
run;

Data KOH;
	set newset2;
	by Winning_Team1;

	if first.Winning_Team1 then do;
		num_wins = 0;
	end;

	num_wins + 1;

	if last.Winning_Team1 then output;
run;

proc print data = KOH;
var num_wins Winning_Team1;
run;


/* (3)  */


data bjs;	
	infile "&path.BenandJerrys2.dat" dsd dlm = ",";
	input flavor :$49.
		  prt_size
		  calories
		  fat_cal
		  fat
		  sat_fat
		  trans_fat
		  cholesterol
		  sodium
		  carbs
		  fiber $
		  sugars
		  protein
		  Y_intro $
		  T_retire $
		  desc :$110.
		  notes :$185.;

	if notes = "Scoop Shop Exclusive" then delete;
run;

proc print data = bjs;
run;

proc sgplot data = bjs;
Scatter x = fat y = calories;
title "Grocery Store Ben & Jerrys Flavors";
run;
