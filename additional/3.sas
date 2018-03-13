/*libname ia "c:\prog1";*/
/*libname mylib "c:\mylib";*/
/*proc print data=ia.empdata;*/
/*run;*/
/*proc sort data=ia.empdata out=work.empdata;*/
/*by JobCode;*/
/*run;*/
/*proc print work.empdata;*/
/*run;*/
/*proc print data=work.empdata;*/
/*   title1 'The First Line';*/
/*   title3 'The Second Line';*/
/*run;*/
/*proc print data=work.empdata;*/
/*   title; 	*/
/*run;*/
/*proc print data=ia.empdata label;*/
/*   label LastName='Last Name' */
/*         FirstName='First Name'*/
/*         Salary='Annual Salary'; */
/*   title1 'Salary Report';*/
/*run;*/
/*proc print data=ia.empdata split=' ';*/
/*   label LastName='Last Name' */
/*         FirstName='First Name'*/
/*         Salary='Annual Salary'; */
/*   title1 'Salary Report';*/
/*run;*/
/*proc print data=ia.empdata split='*';*/
/*   label LastName='Last*Name' */
/*         FirstName='First*Name'*/
/*         Salary='Annual*Salary'; */
/*   title1 'Salary Report';*/
/*run;*/
options date number;
ods html close;
ods listing;
options nodate pageno=789; //nomer stranichki s kotoroj nachinajem
FOOTNOTE;

proc print data=work.empdata;
   by JobCode;
   pageby JobCode;
   sum Salary;
run;
