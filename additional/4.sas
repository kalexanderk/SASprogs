
/*TASK1*/

proc import out=work.ekon datafile="c:/Економіка.xlsx"
	dbms=xlsx replace;
	getnames=yes;
run;

proc print data=work.ekon noobs label;
run;

/*-------------------------------------------------------------------*/

/*TASK2*/
/*#1*/

libname mylib "c:\mylib";
run;

proc print data=mylib.sales noobs label;
	var Employee_ID First_Name Last_Name Salary Hire_Date;
	format Hire_Date MMDDYY8.
		   Salary DOLLAR6.3;
	label Employee_ID="N"
		  First_Name="Name"
		  Last_Name="Surname"
		  Salary="Total salary"
		  Hire_Date="Date";
run;
/*----------------------------*/

/*#2*/
libname mylib "c:\mylib";
run;

proc sort data=mylib.sales out=mylib.sales_sorted;
  BY Descending Salary;
run;

proc print data=mylib.sales_sorted noobs label;
	var Employee_ID First_Name Last_Name Salary Hire_Date;
	format Hire_Date MMDDYY8.
		   Salary DOLLAR6.3;
	label Employee_ID="N"
		  First_Name="Name"
		  Last_Name="Surname"
		  Salary="Total salary"
		  Hire_Date="Date";
run;
/*-------------------------------------------------------------------*/

/*TASK3*/

data work.nasdaq;
    infile "c:\nasdaq.txt" 
           ENCODING="WCYRILLIC" DLM=","
           FIRSTOBS=2;
    input a1 $ a2 $ a3 a4 a5 $ a6 $ a7 $ a8 $ a9 $ a10 $ a11 $  a12 $;
	newa6a7=catx(',', a6,a7);
	newa8a9=catx(',', a8,a9);
	newa10a11=catx(',', a10, a11);
	keep a1 a2 a3 a4 a5 newa6a7 newa8a9 newa10a11 a12;
	label 
	a1="TICKER" 
	a2="PER" 
	a3="DTYYYYMMDD"
    a4="TIME"
	a5="OPEN"
	newa6a7="HIGH"
    newa8a9="LOW"
    newa10a11="CLOSE"
    a12="VOL";
	format a3 YYMMDD10.
	a4 TIME.;
	N=_N_;
	ERROR=_ERROR_;
RUN; 

proc print data=work.nasdaq noobs label;
 var a1 a2 a3 a4 a5 newa6a7 newa8a9 newa10a11 a12;
run;
/*-------------------------------------------------------------------*/
