#SAMPLE CODE to set diary dates/slots
#to clear FRIDAY SLOTS
UPDATE diarydates SET openflag=0,freeslots=0,availslots=NULL WHERE dayno=6 AND diarydate>'2009-10-08';
#to add e.g. 1 slot every Tuesday
UPDATE diarydates SET openflag=1,freeslots=1,availslots='1' WHERE dayno=3 AND diarydate>'2009-10-08';