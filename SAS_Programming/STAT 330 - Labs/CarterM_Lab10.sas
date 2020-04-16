**********************************
Name: Matthew Carter
Assignment: Lab #10
**********************************;

*(1)                              ;
%let path = C:\Users\liblabs-user\Desktop\;


* #2 ;
*a;
data steal;
	infile "&path.Data_parking.dat";
	input Date :Monyy7. 
		  State :comma9. 
		  City :comma5.
		  Contractor $;
run;

*b;
proc print data = steal;
run;

*d;
proc means data = steal mean;
	var City;
	class Contractor;
run;
*The average money collected by 24 Brinks contractors was $6933.75, abot $200 higher then the average of $6754.78 
average found for the 23 other contractors.;


* #3 ;
*a, b;
data music;
	infile "&path.Data_music_files.dat";
	input @"ALBUM: " Album :$
		  @"FILE:" Song :$40.
		  Size :comma9.;

	title_length = length(Song);
run;

proc print data = music;
run;

*c;
proc reg data = music;
	model title_length = Size;
quit;
*After using a proc reg to invstigate the linear relationship between title length and bytes,
I found an f value = 1.44,, which corresponds to a p-value = .2368. With such a high p-value, there
isn't enough evidence to suggest a linear relationship between title length and file size. 

To find the correlation, I just took the square root of R-sq, which gave me a value of .187 which
is indicative of a weak positive correlation between title length and file size.;


*d;
proc print data = music;
	where size > 12500000;
run;
*The song that corresponds to this observation with an unusually large size is on album A4, is titled
"The_Suite_Theme.mp3", has a size of 13,267,072 bytes, and has a title length of 19;


*#4 ;

*a;
data quakes;
	infile "&path.Earthquake.dat";
	input map $ 
		  magnitude
		  date_time &YMDDTTM.
		  latitude 34-40 
		  longitude 44-51
		  depth
		  location $42.;
run;

*b;
proc print data = quakes;
run;

*c;
proc sgplot data = quakes;
	series X = date_time Y = magnitude;
	xaxis label = "Date";
	yaxis label = "Earthquake Magnitude";
	format date_time dt datetime.;
quit;

*d;
proc freq data = quakes;
	where location contains "MEXICO";
run;
/* 17 earthquakes occurred in Mexico. */

proc freq data = quakes;
	where location contains "ALASKA";
run;
/* 46 earthquakes occurred in Alaska. */
