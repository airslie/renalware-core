#--Mon Jan  7 08:48:27 EST 2013--
INSERT INTO diarydates (diarydate) select adddate(diarydate, INTERVAL + 1 YEAR) as ddate FROM diarydates WHERE diarydate>'2012-02-08' AND diarydate !='2012-02-29';
INSERT INTO diarydates (diarydate) select adddate(diarydate, INTERVAL + 1 YEAR) as ddate FROM diarydates WHERE diarydate>'2013-02-08';
UPDATE diarydates SET dayno=DAYOFWEEK(diarydate), weekno=WEEKOFYEAR(diarydate), dayname=DAYNAME(diarydate) WHERE dayno is NULL;
UPDATE diarydates SET openflag=0 WHERE openflag is NULL AND diarydate>'2013-01-01';
UPDATE diarydates SET openflag=1 WHERE dayno IN ('2','3','5') AND diarydate>'2013-01-01';
UPDATE diarydates SET freeslots=0 WHERE openflag=0;
