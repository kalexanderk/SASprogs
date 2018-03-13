%let city=Dallas;
%let date=05JAN2000;
%let amount=975;

data _null_;
set sashelp.cars;
where invoice>&amount;
run;
proc print data=_null_;
run;
