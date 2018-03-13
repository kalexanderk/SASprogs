/*%let city=Dallas;*/
/*%let date=05JAN2000;*/
/*%let amount=975;*/
/**/
/*data _null_;*/
/*set sashelp.cars;*/
/*where invoice>&amount;*/
/*run;*/
ods html;
%let name=qtr;
%let year=2012;
proc print data=mylib.&name.1_&year;
run;
proc print data=mylib.&name.2_&year;
run;
