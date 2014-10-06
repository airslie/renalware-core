<?php
//Mon Dec 17 14:56:28 CET 2007
/*
	Mon Slots:     slot 1     slot 2  slot 3    Emerg NONE
	Thur Slots:     slot A    slot B     slot C    slot D   (Dr Valenti's Vascular List)
	Fri Slots:     slot 1    slot 2    slot 3    slot 4     slot 5     slot 6    slot 7

	<b>Mon (I), Thurs (I) Sur Slot:</b> <input type="radio" name="surgslot" value="1">slot 1 &nbsp; &nbsp; <input type="radio" name="surgslot" value="2">slot 2&nbsp;&nbsp;<input type="radio" name="surgslot" value="3">slot 3 &nbsp; &nbsp; <input type="radio" name="surgslot" value="E">Emerg <br>
	<b>Thurs (II) Slot (after Apr 12):</b> <input type="radio" name="surgslot" value="4">slot 4 &nbsp; &nbsp; <input type="radio" name="surgslot" value="5">slot 5&nbsp;&nbsp;<input type="radio" name="surgslot" value="6">slot 6 &nbsp; &nbsp; <input type="radio" name="surgslot" value="e">Emerg 2 
CREATE TABLE diarydates_bu as select * from diarydates;
UPDATE diarydates SET openflag=1, freeslots=7, availslots='1234567' WHERE dayno=6 AND diarydate>NOW();
UPDATE diarydates SET availslots=REPLACE(availslots,' abcd','') WHERE dayno=2 AND diarydate>NOW();
UPDATE diarydates SET availslots=REPLACE(availslots,' 456e','') WHERE dayno=5 AND diarydate>NOW();
UPDATE diarydates SET availslots=REPLACE(availslots,'E','4') WHERE dayno=5 AND diarydate>NOW();
UPDATE diarydates SET freeslots=LENGTH(REPLACE(availslots,' ','')) WHERE dayno IN (2,5,6) AND diarydate>NOW();
*/
?>
