data work.flat1;
   infile 'c:\prog1\flat1.dat';
   input @1 EmpID $5.
           @7 HireDate date9.
           @17 Salary 5.;
   Bonus=.05*Salary;
run;
proc print data=work.flat1 noobs;
VAR Salary EmpID;
run;
libname mylib "c:\mylib";
proc print data=mylib.country noobs;
VAR country population;
run;
proc sort data=mylib.customer OUT=work.Customer_sort;
  BY Descending Customer_LastName;
run;

proc print data=work.Customer_sort;
run;
proc sort data=mylib.customer OUT=work.Customer_sort;
  BY Gender Descending Salary;
run;

proc print data=work.Customer_sort;
run;

PROC SETINIT;
RUN;
DATA work.subset;
    INPUT Employee_ID First_Name $ Last_Name $;
DATALINES;
120102 Федор Шпиг
120103 Роман Лунин
120104 Андрей Иванов
;
RUN;

proc print data=work.subset;
run;

libname mylib "c:\mylib";

DATA work.subset;
    INFILE "c:\mylib\sales.csv" 
           ENCODING="WCYRILLIC" DLM=";"
           FIRSTOBS=2;
    INPUT Employee_ID First_Name $ Last_Name $
          Gender $ Salary Job_Title $ Country $;
RUN;

PROC PRINT DATA=work.subset;
RUN;

ods html close;
ods listing;

libname mylib "c:\mylib";

DATA work.subset;
    INFILE "c:\mylib\sales.csv" 
           ENCODING="WCYRILLIC" DLM=";"
           FIRSTOBS=2;
    INPUT Employee_IDFirst_Name $ Last_Name $
          Gender $ Salary Job_Title $ Country $;
	N=_N_;
	ERROR=_ERROR_;
RUN;

PROC PRINT DATA=work.subset noobs;
RUN;



---------------------------

libname ia "c:\prog1";
libname mylib "c:\mylib";
ods listing close;
ods html;

proc print data=ia.empdata;
run;

proc print data=ia.empdata noobs;
var JobCode EmpID Salary;
run;

proc print data=ia.empdata noobs;
var JobCode EmpID Salary;
where JobCode='PILOT' or FirstName='ROBERT A.';
run;

proc print data=ia.empdata noobs;
   var JobCode EmpID Salary FirstName;
   where Salary>23000;
run;

proc print data=ia.empdata noobs;
   var JobCode EmpID Salary;
   where JobCode='FLTAT' and Salary>10000;
run;
proc print data=ia.empdata noobs;
   var JobCode EmpID Salary;
   where JobCode not in('FLTAT');
run;

proc print data=ia.Employees noobs;
   var LastName JobCode EmpID Salary;
   where LastName ? 'LAND'; 
run;

proc sort data=ia.empdata out=work.empdata;
by JobCode;
run;

proc print data=work.empdata;
   by JobCode;
   pageby JobCode;
   sum Salary;
run;


data ia.test1;
X='abc';
output;
X='a_b';
output;
X='axb';
output;
X='fdfsfdfd';
output;
X='dfdfsddfdsdb';
output;
run;

proc print data=test;
WHERE X LIKE '___';
run;

proc print data=mylib.budget;
where month=1 or month=3;
run;
