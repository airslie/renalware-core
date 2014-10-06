#Renal Reg SQL documentation

30 May 2014

###index.php

* None

###preflight.php

* Miscellaneous queries to display patients missing data based on $where
```sql
SELECT patzid, rregno, CONCAT(lastname,', ', firstnames) as patient, sex, 
        birthdate,deathdate, hospno1, modalcode, modalsite, ethnicity, firstseendate, 
        endstagedate, EDTAcode as edtacode, ethnicityreadcode
        FROM renalware.patientdata JOIN renalware.renaldata ON patzid=renalzid 
        JOIN renalware.esrfdata ON patzid=esrfzid 
        LEFT JOIN renalreg.ethnicreadcodes ON ethnicity=ethnicityname 
        $where ORDER BY endstagedate DESC $limit
```

###preppathology.php

Flushing existing renal reg results data

`DELETE FROM renalreg.qtr_resultsdata`

Flushing existing renal reg average path data

`DELETE FROM renalreg.qtr_pathdata`

Gathering all pathology results for Qtr $sess_sessqtr...
```sql
INSERT INTO renalreg.qtr_resultsdata SELECT * FROM hl7data.pathol_results WHERE resultsdate BETWEEN '$thisstartdate' AND '$thisenddate'
```

Set NULL path values prn

```php
$rregpathflds=array(
'AL',
'ALB',
'CAL',
'CCA',
'CHOL',
'CRE',
'FER',
'HB',
'HBA',
'BIC',
'PHOS',
'NA',
'PTHI',
'URE'
);
foreach ($rregpathflds as $fld) {
    $sql="UPDATE renalreg.qtr_resultsdata SET $fld=NULL WHERE $fld=0";
    $result = $mysqli->query($sql);
    $numrows=$mysqli->affected_rows;
//  if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
    echo "$numrows $fld 0 values set to NULL...<br>";
    }
```

Gathering average pathology datasets for Qtr $sess_sessqtr...

```sql
INSERT INTO renalreg.qtr_pathdata (pathzid, pathqtr, hospno, lastrunstamp,lastdate, QUA24, QUA23, QUA30, QUA31, QUA26, QUA10, QUA22, QUA21, QUA25,QUA33, 
QUA32, QUA34, QUA27, QUA11) SELECT patzid, $sess_sessqtr, resultspid,NOW(), 
MAX(resultsdate), ROUND(AVG(AL),1), ROUND(AVG(ALB),0), ROUND(AVG(CAL),2), 
ROUND(AVG(CCA),2), ROUND(AVG(CHOL),1), ROUND(AVG(CRE),0), ROUND(AVG(FER),0), 
ROUND(AVG(HB),1), ROUND(AVG(HBA),1), ROUND(AVG(BIC),0), ROUND(AVG(PHOS),2), 
ROUND(AVG(NA),0), ROUND(AVG(PTHI),0), ROUND(AVG(URE),1) 
FROM renalreg.qtr_resultsdata 
JOIN renalware.patientdata ON resultspid=hospno1 
WHERE HB<20 GROUP BY resultspid
```

###prepquarter.php

Loop through tables to DELETE existing data

```php
echo "<p><code>Flushing tables…</code></p>";
$flushtables=array(
    'qtr_epodata',
    'qend_epodata',
    'firstmodaldates',
    'qtr_txtdata',
    'qtr_modaldata',
    'qend_modals',
    'lastmodaldata',
);
foreach ($flushtables as $tbl) {
    $sql="DELETE FROM renalreg.$tbl";
    $mysqli->query($sql);
    if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
}
```

Create qtr table if first run 
(NB `$thisqtrpatdata="qtr{$thisqtr}_patientdata";`)

```sql
CREATE TABLE IF NOT EXISTS renalreg.$thisqtrpatdata 
LIKE renalreg.qtrxx_patientdata
```

Ensure empty:

`DELETE FROM TABLE $thisqtrpatdata`

Gather qtr EPO data (all records)

```php
$sql="INSERT INTO renalreg.qtr_epodata 
SELECT medsdata_id, medzid, adddate, termdate, drugname, esdunitsperweek 
FROM renalware.medsdata 
WHERE esdflag=1 AND (adddate<'$qtrend_ymd' AND adddate>'0000-00-00') 
AND (termdate is NULL OR termdate >'$qtrstart_ymd');";
```

From qtr_epodata get the zid and the latest medsdata_id to represent the latest prescription for each patient:

START ACTION Get latest EPO record for quarter in qend_epodata

```sql
INSERT INTO renalreg.qend_epodata (epozid, medsdata_id) 
SELECT medzid, MAX(medsdata_id) FROM renalreg.qtr_epodata GROUP BY medzid
```

Update the qend_epodata values based on the medsdata_id from qtr_epodata:

```sql
UPDATE renalreg.qend_epodata qend, renalreg.qtr_epodata qtr
 SET qend.adddate=qtr.adddate, qend.termdate=qtr.termdate, 
 qend.drugname=qtr.drugname, qend.esdunitsperweek=qtr.esdunitsperweek 
 WHERE qend.medsdata_id=qtr.medsdata_id
```

Get first modality dates for all patients

```sql
INSERT INTO renalreg.firstmodaldates SELECT modalzid, MIN(modaldate) 
FROM renalware.modaldata GROUP BY modalzid
```

START ACTION set rr code NULL if modal=death
`UPDATE renalware.modaldata SET rrmodalcode=NULL WHERE modalcode='death'`

START ACTION TXT tracking data $qtrstart_ymd through $qtrend_ymd gathered
```sql
INSERT INTO renalreg.qtr_txtdata 
SELECT modalzid, modalcode, modalsitecode, modaldate, rregcode 
FROM renalware.modaldata 
JOIN renalreg.rregmodalcodes ON modalcode=rwarecode 
WHERE modaldate BETWEEN '$qtrstart_ymd' AND '$qtrend_ymd' 
ORDER BY modaldate
```

START ACTION Get all patient modaldata for up to quarter end
```sql
INSERT INTO renalreg.qtr_modaldata 
(modal_id,modalzid,modalcode,modalsitecode,modaldate,rrmodalcode) 
SELECT modal_id,modalzid,modalcode,modalsitecode,modaldate,rrmodalcode 
FROM renalware.modaldata 
WHERE modaldate <='$qtrend_ymd' AND modalcode is not NULL
```

START ACTION Update modality data with RRegcode
```sql
UPDATE renalreg.qtr_modaldata, renalreg.rregmodalcodes 
SET rrmodalcode=rregcode WHERE modalcode=rwarecode
```

START ACTION Latest RR modality for each patient through $qtrend_ymd gathered
```sql
INSERT INTO renalreg.qend_modals (qmodalzid, qmodaldate) 
SELECT modalzid, MAX(modaldate) 
FROM renalreg.qtr_modaldata 
GROUP BY modalzid;

UPDATE renalreg.qend_modals q, renalreg.qtr_modaldata m 
SET qmodalcode=modalcode, qmodalsitecode=modalsitecode, 
qrrmodalcode=rrmodalcode 
WHERE qmodalzid=modalzid AND qmodaldate=modaldate;
```

START ACTION Use qend_modals to INSERT lastmodaldata with sitecode, sitetype
```sql
INSERT INTO renalreg.lastmodaldata 
SELECT qmodalzid, qmodaldate, qmodalcode, qmodalsitecode, qrrmodalcode, rregsitecode, sitetype 
FROM renalreg.qend_modals 
LEFT JOIN renalreg.krusitelist ON qmodalsitecode=sitecode 
ORDER BY qmodalzid;
```

START ACTION delete NULLs from lastmodaldata
```sql
DELETE FROM renalreg.lastmodaldata 
WHERE rrmodalcode is NULL AND lastmodalcode !='death';

DELETE FROM renalreg.lastmodaldata 
WHERE lastmodalcode is NULL
```

START ACTION Set RR code=70 for death patients in qtr
```sql
UPDATE renalreg.lastmodaldata 
SET rrmodalcode=70 WHERE lastmodalcode='death';
```

START ACTION Fix various broken dates
```sql
UPDATE renalware.renaldata 
SET firstseendate=NULL WHERE firstseendate='0000-00-00';

UPDATE renalware.patientdata 
SET deathdate=NULL WHERE deathdate='0000-00-00'
```

START ACTION update patientdata with latest RRegno from rregpatlist
```sql
UPDATE renalware.patientdata p, renalreg.rregpatlist r 
SET p.rregno=r.rregno WHERE p.hospno1=r.hospno1;
```

START ACTION set all patient rregflag=0 as default then turn on
`UPDATE renalware.patientdata SET rregflag=0`

START ACTION ensure endstagedate filled in (stored in 2 tables)
```sql
UPDATE renalware.renaldata, renalware.esrfdata 
SET endstagedate=esrfdate WHERE renalzid=esrfzid AND endstagedate IS NULL;
```

START ACTION set rregflag=1 if patient has esrfdate in renaldata
```sql
UPDATE renalware.patientdata, renalware.esrfdata 
SET rregflag=1 WHERE patzid=esrfzid AND esrfdate IS NOT NULL;
```

START ACTION deflag optout patients NOT ENABLED
```php
/*
$sql="UPDATE renalware.patientdata SET rregflag=0 WHERE renalregoptout='Y'";
$mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
echo "<br><p><code>Patients with renalregoptout=Y purged ($numaffected patients)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
*/
```

START ACTION deflag dead patients where deathdate unknown
```sql
UPDATE renalware.patientdata SET rregflag=0 
WHERE modalcode='death' AND deathdate is NULL;
```

START ACTION deflag patients who died prior to qtr start
```sql
UPDATE renalware.patientdata SET rregflag=0 
WHERE deathdate<'$qtrstart_ymd';
```

START ACTION deflag patients with ESRF date after qtr end
```sql
UPDATE renalware.patientdata, renalware.esrfdata 
SET rregflag=0 WHERE patzid=esrfzid AND esrfdate >'$qtrend_ymd';
```

START ACTION deflag pats with first modaldate after qtr end
```sql
UPDATE renalware.patientdata, renalreg.firstmodaldates 
SET rregflag=0 WHERE firstmodaldate >'$qtrend_ymd' AND patzid=modalzid;
```

START ACTION deflag pats who transferred out before qtr start
```sql
UPDATE renalware.patientdata, renalreg.qend_modals 
SET rregflag=0 WHERE qmodalcode='transferout' 
AND qmodaldate<'$qtrstart_ymd' AND patzid=qmodalzid;
```

GET FINAL COUNT where rregflag=1
`SELECT patzid FROM renalware.patientdata WHERE rregflag=1;`

INSERT core data into thisqtrpatdata
```sql
INSERT INTO renalreg.$thisqtrpatdata 
SELECT patzid,$thisqtr, rregno, hospno1,lastname, firstnames, 
sex,birthdate,deathdate,modalcode,modalsite,postcode,ethnicity,
firstseendate,endstagedate,esdflag,rrmodalcode,rregsitecode,sitetype,NULL,NULL
FROM renalware.patientdata 
JOIN renalware.renaldata ON patzid=renalzid 
JOIN renalware.esrfdata ON patzid=esrfzid 
JOIN renalreg.lastmodaldata m ON patzid=lastmodalzid 
WHERE rregflag=1 ORDER BY lastname, firstnames;
```

###runquarter.php

```sql
SELECT patzid, rregno, lastname, firstnames, 
IF(sex='M', '1', '2') as PAT00, 
DATE_FORMAT(birthdate, '%d/%m/%Y') AS dob,
DATE_FORMAT(deathdate, '%d/%m/%Y') AS PAT40, 
hospno1, modalcode, modalsite, LEFT(addr1,40) as PAT20, LEFT(addr2,40) as PAT21, postcode as PAT23, 
ethnicity, gp_postcode as PAT27,
deathCauseEDTA1 as PAT42, 
DATE_FORMAT(firstseendate, '%d/%m/%Y') as PAT33,
DATE_FORMAT(endstagedate, '%d/%m/%Y') AS ERF00, 
EDTAcode as ERF04, 
IF(Angina='Y','2','1') as ERF20,
IF(PreviousMIlast90d='Y','2','1') as ERF21,
IF(PreviousMIover90d='Y','2','1') as ERF22,
IF(PreviousCAGB='Y','2','1') as ERF23,
IF(EpisodeHeartFailure='Y','2','1') as ERF24,
IF(Smoking='Y','2','1') as ERF30,
IF(COPD='Y','2','1') as ERF31,
IF(CVDsympt='Y','2','1') as ERF32,
IF(DiabetesNotCauseESRF='Y','2','1') as ERF33,
IF(Malignancy='Y','2','1') as ERF34,
IF(LiverDisease='Y','2','1') as ERF35,
IF(Claudication='Y','2','1') as ERF40,
IF(IschNeuropathUlcers='Y','2','1') as ERF41,
IF(AngioplastyNonCoron='Y','2','1') as ERF42,
IF(AmputationPVD='Y','2','1') as ERF43,
LEFT(txWaitListStatus,1) as QUA06,
IF(patientdata.esdflag=1,'2','1') as QUA51,
rrmodalcode as QUA02,
rregsitecode as QUA04,
sitetype as QUA05,
QUA10, QUA11, QUA21, QUA22, QUA23, QUA24, QUA25, QUA26, QUA27, QUA30, QUA31, QUA32, QUA33, QUA34, ethnicityreadcode as PAT25,
hdpatdata.hours as QUA65hhmm,
hdpatdata.currsite as hdcurrsite,
BPsyst, BPdiast,
renalreg.qend_epodata.*
FROM renalware.patientdata 
JOIN renalware.renaldata ON patzid=renalzid 
JOIN renalware.esrfdata ON patzid=esrfzid 
JOIN renalware.currentclindata ON patzid=currentclinzid 
LEFT JOIN renalware.hdpatdata ON patzid=hdpatzid 
LEFT JOIN renalreg.qend_epodata ON patzid=epozid 
JOIN renalreg.lastmodaldata m ON patzid=lastmodalzid 
LEFT JOIN renalreg.qtr_pathdata ON patzid=pathzid 
LEFT JOIN renalreg.ethnicreadcodes ON ethnicity=ethnicityname 
WHERE rregflag=1 ORDER BY lastname, firstnames $limit;
```


