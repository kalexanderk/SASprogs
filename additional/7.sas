libname mylib "c:\mylib";

proc contents data=mylib._ALL_;
run;
proc contents data=mylib._ALL_ NODS;
run;
proc print data=mylib.sales;
run;
data work.staff;
infile 'c:\prog1\emplist.dat';
input LastName $ 1-20 FirstName $ 21-30
JobTitle $ 36-43 Salary 54-59;
run;
proc print data=work.staff;

proc means data=work.staff;
   class JobTitle;
   var Salary;
run;
data work.flat1;
   infile 'c:\prog1\flat1.dat';
   input @1 EmpID $5.
           @7 HireDate date9.
           @17 Salary 5.;
   Bonus=.05*Salary;
run;
proc print data=work.flat1;
