/*Çäåñü âìåñòî äàòû ðåãèñòðàöèè íàêëàäíîé ÅÐÏÍ - 'DateOfBirth'n, âìåñòî ñòîèìîñòè ñ ÍÄÑ - 'Salary'n.*/
/*Âìåñòî êîäà ïðîäàâöà - JobCode (èùåì ñóììû ïî îäèíàêîâûì JobCode).*/


LIBNAME TEST "C:\workshop\Ex01_DateOfBirth";

/*Óêàçàòü êîëè÷åñòâî ìåñÿöåâ, êîòîðûå èññëåäóåì äî óêàçàííîé äàòû.*/
%let months = 30; *number of months in the interval;
%put months = &months.;

*----------------------------------------------------------;

/*Ñîçäàåì âñïîìîãàòåëüíûé íàáîð äàííûõ.
Çäåñü Minus_DateOfBirth - íûíåøíÿÿ äàòà ìèíóñ &months., ò.å. íà÷àëî èíòåðâàëà. â êîòîðîì ñ÷èòàåì ñóììó.
Â ìàêðîïåðåìåííóþ &num_obs. çàïèñàëè êîëè÷åñòâî ñòðîê äàííîãî íàáîðà äàííûõ. */
DATA WORK.TEMPORARY_INITIAL;
SET TEST.PAYROLLMASTER (OBS=148) END=LastRec;
Minus_DateOfBirth = intnx('day', intnx('month', 'DateOfBirth'n, -&months.), day('DateOfBirth'n)-1);
rownum = _N_;
FORMAT Minus_DateOfBirth : DATE9.;
IF LastRec THEN DO; 
  call symput('num_obs', strip(input(rownum, $CHAR1000.))); 
END;
RUN; 

%put num_obs = &num_obs.; /*Ïðîâåðêà ñâÿçè. :)*/


/*Ñîçäàåì "íóëåâîé" íàáîð äàííûõ äëÿ ïîñëåäóþùåãî åãî çàïîëíåíèÿ â ïðîöåññå âûïîëíåíèÿ ìàêðîöèêëà.
Ýòî áóäåò ôèíàëüíûé íàáîð äàííûõ. Ñîõðàíÿåì åãî â îñíîâíîé áèáëèîòåêå TEST.*/
DATA TEST.FINAL_RESULT;
SET WORK.TEMPORARY_INITIAL (OBS=0);
SUM_MONEY = 0;
AVG_MONEY = 0;
LENGTH RISK $ 3;
RUN;


/*Âûïîëíÿåì ìàêðîöèêë, îáðàáàòûâàÿ äàòàñýò WORK.TEST_V1 ïîñòðî÷íî.*/
%MACRO CYCLE;
%DO J=1 %TO &num_obs.;
%let J=&J.;
	
	/*Âûâåëè â ìàêðîïåðåìåííóþ &Unique_identifier. çíà÷åíèå 'JobCode'n èç òåêóùåé ñòðîêè.*/
	PROC SQL NOPRINT;
		SELECT 'JobCode'n INTO: Unique_identifier
		FROM WORK.TEMPORARY_INITIAL
		WHERE rownum=&J.;
	QUIT;
	%let Unique_identifier = &Unique_identifier.;
	%put Unique_identifier = &Unique_identifier.;


    /*Âûâåëè â ìàêðîïåðåìåííóþ &Dat_start. çíà÷åíèå 'Minus_DateOfBirth'n èç òåêóùåé ñòðîêè.*/
	PROC SQL NOPRINT;
		SELECT 'Minus_DateOfBirth'n INTO: Dat_start
		FROM WORK.TEMPORARY_INITIAL
		WHERE rownum=&J.;
	QUIT;
	%let Dat_start = &Dat_start.;
	%put Dat_start = &Dat_start.;

	/*Âûâåëè â ìàêðîïåðåìåííóþ &Dat_end. çíà÷åíèå 'DateOfBirth'n èç òåêóùåé ñòðîêè.*/
	PROC SQL NOPRINT;
		SELECT 'DateOfBirth'n INTO: Dat_end
		FROM WORK.TEMPORARY_INITIAL
		WHERE rownum=&J.;
	QUIT;
	%let Dat_end = &Dat_end.;
	%put Dat_end = &Dat_end.;

	/*Âûâåëè â ìàêðîïåðåìåííóþ &SUM_SAL ñóììó ïî ïîëþ 'Salary'n äëÿ òåõ ñòðîê, çíà÷åíèÿ 'DateOfBirth'n êîòîðûõ
	ïîïàäàþò â íóæíûé èíòåðâàë èç &months. ìåñÿöåâ â îáðàòíîì îòñ÷åòå.*/
	PROC SQL NOPRINT;
		SELECT SUM('Salary'n) INTO: SUM_MONEY
		FROM WORK.TEMPORARY_INITIAL
		WHERE 'DateOfBirth'n >= input("&Dat_start.", DATE9.) AND 
        'DateOfBirth'n <= input("&Dat_end.", DATE9.) AND 'JobCode'n = "&Unique_identifier.";
	QUIT;
	%put SUM_MONEY = &SUM_MONEY;
    %let SUM_MONEY = &SUM_MONEY.;

    /*Ñîçäàåì âñïîìîãàòåëüíûé íàáîð äàííûõ, â êîòîðîì ñîäåðæèòñÿ ëèøü òåêóùàÿ ñòðîêà è äîïèñàí â êîíöå ñòîëáèê ñî
	çíà÷åíèåì &SUM_SAL.*/
	DATA WORK.HELP;
	SET WORK.TEMPORARY_INITIAL;
	WHERE rownum = &J.;
	SUM_MONEY = &SUM_MONEY.;
	AVG_MONEY = &SUM_MONEY./&months.;
	LENGTH RISK $ 3;
	IF 'Salary'n GE AVG_MONEY THEN RISK = "YES";
		ELSE RISK = "NO";
	RUN;

    /*Äîáàâëÿåì âñïîìîãàòåëüíûé íàáîð WORK.HELP (ò.å. òåêóùóþ ñòðîêó) â ôèíàëüíûé íàáîð äàííûõ TEST.FINAL.*/
	PROC APPEND BASE=TEST.FINAL_RESULT DATA=WORK.HELP;
	RUN;

%END;

%MEND;
%CYCLE;

/*Óäàëÿåì èç ôèíàëüíîãî íàáîðà äàííûõ âñïîìîãàòåëüíûå ñòîëáöû rownum è Minus_DateOfBirth.*/
DATA TEST.FINAL_RESULT;
SET TEST.FINAL_RESULT (DROP=rownum Minus_DateOfBirth);
RUN;

/*Óäàëÿåì óæå íåíóæíûå âñïîìîãàòåëüíûå íàáîðû äàííûõ.*/
PROC DATASETS LIBRARY=WORK NOPRINT;
	DELETE HELP TEMPORARY_INITIAL;
	QUIT;
RUN;




