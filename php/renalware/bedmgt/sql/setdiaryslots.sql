--for alternate weeks, e.g. TEST
SELECT diarydate, dayno, weekno, CONCAT(availslots, ' 456e') as newslots FROM diarydates WHERE dayno=5 AND diarydate > '2007-04-11' AND (weekno/2 != floor(weekno/2));

--update
UPDATE diarydates SET freeslots=freeslots+4, availslots=CONCAT(availslots, ' 456e') WHERE dayno=5 AND diarydate > '2007-04-11' AND (weekno/2 != floor(weekno/2));