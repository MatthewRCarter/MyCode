/*****************************************************************************
* Name:        Matthew Carter
* Assignment:  Homework 13-22
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
By now you should have realized that there is usually more than one way to 
accomplish a task in SAS.  We have already used the INFILE statement in a
DATA step to read in delimited raw data.  Now we will use PROC IMPORT.  The 
general syntax is:

PROC IMPORT DATAFILE="filename" 
			OUT=DataSetName
			DBMS = identifier
			REPLACE ;
RUN;

Note that all of those options go on the PROC IMPORT line (so there is just one semi-colon
from PROC IMPORT to REPLACE.  

DATAFILE= takes the full path of the data file, the data file name, and the extension of
the data file - so this should look something like:

		DATAFILE="Computer Location/mydata.csv"


OUT= specifies the name of the SAS data set that you want to create

The DBMS (database management system) option specifies the type of data to import and can 
accept values like 
	CSV  for .csv files (comma delimiter)
	TAB  for .txt files (tab delimiter)
	DLM  for files with other delimiters

The REPLACE option overwrites an existing SAS data set with DataSetName.

*****************************************************************************/


/****************************************************************************** 
It's your turn to give it a shot.  The US Census Bureau is best known for 
conducting the annual census every 10 year.  In 2005, the US Census Bureau
initiated the American Community Survey (ACS) to collect more detailed 
information about the US population.  The acs.csv data provides a small 
snapshot of this data.  For more info go to: 
	http://www.census.gov/programs-surveys/acs/

NOTE: a CSV file cannot be physically open in excel when you use
PROC IMPORT.

-Use PROC IMPORT to read in the acs.csv data set
-Print the data so that you can get familar with it.
-Identify the number of survey respondents that are NOT US citizens.  Note
your findings as a comment in your SAS code.
-Do you think the values of the US citizen variable read in correctly?  
Why or why not?  Note this as a comment in your SAS code.  (Note, if you
don't think it read in correctly you don't have to fix it.)
*****************************************************************************/

PROC IMPORT DATAFILE="C:\Users\liblabs-user\Desktop\acs.csv" 
			OUT= Community
			DBMS = CSV
			REPLACE ;
RUN;

proc contents data = Community;
run;

*There are 62 non-citizen repondents;

*No, I don't think the data read in correctly. There are way to many people with incomes
that do not make sense, and alot of poeple with an income with zero hours worked.;

proc print data = Community;
by USCitizen;
run;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;


