/** Q1. Import both data sets into SAS and merge them into a single SAS table by Species, i.e.
species1 and species2 are the same variable. Based on the merged SAS table, use PROC TABULATE 
to create a table that contains the number of observations, the minimum, and the maximum of the four variables 
 (sepal length, sepal width, petal length, and petal width) grouped by Species. (30 pt) **/

PROC IMPORT datafile = "/home/u62107656/bmi515/FisherIris1.xlsx"
			out = data1
			DBMS = XLSX
			replace;
run;
PROC IMPORT datafile = "/home/u62107656/bmi515/FisherIris2.xlsx"
			out = data2
			DBMS = XLSX
			replace;
run;

DATA data1;
	set data1(rename=(Species1=species));
run;
DATA data2;
	set data2(rename=(Species2=species));
run;
DATA merged;
	MERGE data1 data2;
	BY species;
run;
proc tabulate data=work.merged;
	class species;
	var SepalLength SepalWidth PetalLength PetalWidth;
	table species,N SepalLength*(min max) SepalWidth*(min max) PetalLength*(min max) PetalWidth*(min max);
	title 'results';
run;

/**  Q2 For Fisherlirl1.xlsx data only, define a new length variable, which is an average of sepal length and petal length, 
and similarly define a new width variable, which is an average of sepal width and petal width. Report summary statistics 
(mean, standard deviation, median, 1st quartile, 3rd quartile) of the two new variables grouped by Species. (30 pt) **/
DATA data1_dataset; 
	SET data1;
	average_length = (SepalLength + PetalLength) / 2;
	average_width =  (SepalWidth + PetalWidth) / 2;
run;
proc tabulate data=data1_dataset;
	class species;
	var average_length average_width;
	table species, average_length*(mean std median q1 q3) average_width*(mean std median q1 q3);
	title 'Average of Length & Width';
run;

/** Q3. For Fisherlirl1.xlsx data only, produce and interpret the plots in the questions below.
a. A scatter plot of sepal length and sepal width grouped by Species. (15 pt)
b. A boxplot of sepal length and sepal width grouped by Species. (15 pt) **/
PROC sgplot data=data1;
	scatter x= SepalLength y = SepalWidth / group = species;
	title 'Scatter Plot of SepalLength & SepalWidth'
run;
PROC sgplot data=data1;
	vbox SepalLength/ category = species;
	vbox SepalWidth/ category = species
	y2axis;
	title 'Boxplot of SepalLength & SepalWidth'
run;

