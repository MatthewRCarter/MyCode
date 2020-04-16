/*-------------------------------------*
 Name: Matthew Carter                 
 Date: October 1st 2018              
 Assignment: Lab 2                    
*-------------------------------------*/

data sundaycounter;

sunday = 0;

*this is a nested do loop, going through each month of each year from 1901 to 2000, checking each first 
of the month to check if it is a sunday-- if it is, its adds to the variable Sunday (sunday ticker);

do year = 1901 to 2000;
	do month = 1 to 12; 
		date = mdy(month, 1, year);
		if weekday(date) = 1 then sunday = sunday + 1;  
		output;
	end;
end;
run;


*print statement with correct format to increase output readibility;
proc print data = sundaycounter;
	format date MMDDYY10.;
run;



data uniform;
call streaminit(20);

*creating array of the samples to make later steps easier;
array sample50 (50) ;
array sample150 (150) ;

*create 50 random numbers from our random distribution, store them in array created above;
do n = 1 to 50;
	sample50(n) = rand("uniform", 0, 10);
end;

**create 100 random numbers from our random distribution, store them in array created above;
do n = 1 to 150;
	sample150(n) = rand("uniform", 0, 10);
end;

*calc the means and S.D of the 50 and 100 random numbers from my arrays;
mean50 = mean(of sample50(*));
std50 = std(of sample50(*));
mean150 = mean(of sample150(*));
std150 = std(of sample150(*));

*clean up output, only show summary stats of arrays;
keep mean50 std50 mean150 std150;

run;

proc print data = uniform;
run;

*The sample means of 5.31030 for n=50 and 5.25302 for n=150 are  relatively close to the theoretical 
mean of 5. As I expected the larger sample size moved closer to the theoretical mean, which exemplifies
central limit theorum

The sample standard deviations of 2.78428 for n=50 and 2.86945 for n=50 are very close but slightly 
lower then the theoretical S.D of 2.89. Again, the larger sample wass closer to the theoretical value, 
which I expected to be the case.;




data centralLimit;


*The theoretical means of each sample mean stays the same for each size sample (n=50 and n=150) if they have 
the same distribution.It remains as stated in #2, at mu=5. 

The theoretical standard deviations of each all the sample means will be calculated like so:
S.D(n=50) = 2.89/sqrt(50) = 0.409
S.D(n=150) = 2.89/sqrt(150) = 0.236

This inituitively makes sense as we expect the larger sample size to have a smaller S.D.;

array sample50 (50) ;
array means50 (500) ;
array sample150 (150) ;
array means150 (500) ;

do i = 1 to 500;
	do n = 1 to 50;
		sample50(n) = rand("uniform", 0, 10);
	end;
	
* Here I am taking the mean of each sample of n=50 to create the mean of many sample means.
  Each mean of the n=50 samples are stored in the array means50;
  
	avg50 = mean(of sample50(*));
	means50(i) = avg50; 
end;

do i = 1 to 500;
	do n = 1 to 150;
		sample150(n) = rand("uniform", 0, 10);
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
run;


*Using this method, I received valued that were much closer to their theoretical values. From the 500 
samples means of the n=150, I got a mean of 4.97623 and from the 500 samples of n=150, I got a mean of
 5.00335. Again, the central limit theorum proved true, as the bigger sample size was almost spot on to 
 the theoretical values for the sample mean.
 
 For the standard deviation of the 500 n=50 samples, I got an S.D. = .40420, compared to my theoretical 
 value of .409. This is a good estimate. For the S.D. of the 500 n=150 samples, I got S.D. = .24465, compared
 to my calculated theoretical S.D. of .236. Again, CLT proves true, showing a very small margin of error for the
 difference between my calcs and the theoretical value.;


	

