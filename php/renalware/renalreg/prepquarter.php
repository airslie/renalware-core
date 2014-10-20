<?php
//----Fri 30 May 2014----formatting and documenting actions
//----Fri 04 Apr 2014----new qtr_epodata and qend_epodata for enhanced EPO transmission
//----Mon 15 Oct 2012----streamlined RReg code/site/location updating
$thistab="prepquarter.php";
require '../config_incl.php';
require '../incl/check.php';
$pagetitle="Renal Reg Export: Data Preparation";
include '../parts/head_bs.php';
include 'incl/renalreg_config.php';
include 'incl/rregmaps_incl.php';
include 'incl/navbar_incl.php';
require '/var/conns/renalregconn.php';
echo '<div id="pagetitlediv"><h1><small>'.$pagetitle.'</small></h1></div>';
$thisqtr=$_GET['qtr'];
$debug = ($_GET['debug']=='Y') ? true : false;
$rundate=date("m/d/Y");
$startdmy=$qtrstartdmys[$thisqtr];
$enddmy=$qtrenddmys[$thisqtr];
$qtrstart_ymd=$qtrstartdates[$thisqtr];
$qtrend_ymd=$qtrenddates[$thisqtr];
$thisqtrpatdata="qtr{$thisqtr}_patientdata";
if ($debug) {
    echo "<p><code>NOTE: DEBUG is ON.</code></p>";
}
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
//make qtr pat data tbl
echo "<p><code>Creating QTR $thisqtr patientdata table and flushing prn...</code></p>";
	$sql="CREATE TABLE IF NOT EXISTS renalreg.$thisqtrpatdata LIKE renalreg.qtrxx_patientdata";
	$mysqli->query($sql);
	if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
	
	$sql="DELETE FROM TABLE $thisqtrpatdata";
	$mysqli->query($sql);
	if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

echo "<p><code>Gathering various datasets...</code></p>";

//START ACTION Quarter EPO data collated (qtr_epodata)
$sql="INSERT INTO renalreg.qtr_epodata 
SELECT medsdata_id, medzid, adddate, termdate, drugname, esdunitsperweek 
FROM renalware.medsdata 
WHERE esdflag=1 AND (adddate<'$qtrend_ymd' AND adddate>'0000-00-00') 
AND (termdate is NULL OR termdate >'$qtrstart_ymd');";
$mysqli->query($sql);
echo "<p><code>Quarter EPO data collated (qtr_epodata)...</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION Get latest EPO record for quarter in qend_epodata
$sql="INSERT INTO renalreg.qend_epodata (epozid, medsdata_id) 
SELECT medzid, MAX(medsdata_id) FROM renalreg.qtr_epodata GROUP BY medzid;";
$mysqli->query($sql);
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

$sql="UPDATE renalreg.qend_epodata qend, renalreg.qtr_epodata qtr
 SET qend.adddate=qtr.adddate, qend.termdate=qtr.termdate, 
 qend.drugname=qtr.drugname, qend.esdunitsperweek=qtr.esdunitsperweek 
 WHERE qend.medsdata_id=qtr.medsdata_id;";
$mysqli->query($sql);
echo "<p><code>Quarter end EPO data calculated (qend_epodata)...</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION First modality dates calculated
$sql="INSERT INTO renalreg.firstmodaldates SELECT modalzid, MIN(modaldate) 
FROM renalware.modaldata GROUP BY modalzid;";
$mysqli->query($sql);
echo "<p><code>First modality dates calculated...</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION set rr code NULL if modal=death
$sql="UPDATE renalware.modaldata SET rrmodalcode=NULL WHERE modalcode='death'";
$mysqli->query($sql);

//START ACTION TXT tracking data from $qtrstart_ymd through $qtrend_ymd gathered
$sql="INSERT INTO renalreg.qtr_txtdata 
SELECT modalzid, modalcode, modalsitecode, modaldate, rregcode 
FROM renalware.modaldata 
JOIN renalreg.rregmodalcodes ON modalcode=rwarecode 
WHERE modaldate BETWEEN '$qtrstart_ymd' AND '$qtrend_ymd' 
ORDER BY modaldate";
$mysqli->query($sql);
echo "<p><code>TXT tracking data from $qtrstart_ymd through $qtrend_ymd gathered...</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION Get all patient modaldata up to end quarter
$sql="INSERT INTO renalreg.qtr_modaldata 
(modal_id,modalzid,modalcode,modalsitecode,modaldate,rrmodalcode) 
SELECT modal_id,modalzid,modalcode,modalsitecode,modaldate,rrmodalcode 
FROM renalware.modaldata 
WHERE modaldate <='$qtrend_ymd' AND modalcode is not NULL";
$mysqli->query($sql);
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION Update modality data with RRegcode
$sql="UPDATE renalreg.qtr_modaldata, renalreg.rregmodalcodes 
SET rrmodalcode=rregcode WHERE modalcode=rwarecode";
$mysqli->query($sql);
echo "<p><code>Modality data through $qtrend_ymd gathered...</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION Latest RR modality for each patient through $qtrend_ymd gathered
$sql="INSERT INTO renalreg.qend_modals (qmodalzid, qmodaldate) 
SELECT modalzid, MAX(modaldate) 
FROM renalreg.qtr_modaldata 
GROUP BY modalzid";
$mysqli->query($sql);
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
$sql="UPDATE renalreg.qend_modals q, renalreg.qtr_modaldata m 
SET qmodalcode=modalcode, qmodalsitecode=modalsitecode, 
qrrmodalcode=rrmodalcode 
WHERE qmodalzid=modalzid AND qmodaldate=modaldate";
$mysqli->query($sql);
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
echo "<p><code>Latest RR modality for each patient through $qtrend_ymd gathered...</code></p>";

//START ACTION Use qend_modals to construct lastmodaldata for qtr with sitecode, sitetype
$sql="INSERT INTO renalreg.lastmodaldata 
SELECT qmodalzid, qmodaldate, qmodalcode, qmodalsitecode, qrrmodalcode, rregsitecode, sitetype 
FROM renalreg.qend_modals 
LEFT JOIN renalreg.krusitelist ON qmodalsitecode=sitecode 
ORDER BY qmodalzid";
$mysqli->query($sql);
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }


//START ACTION delete NULLs from lastmodaldata
$sql="DELETE FROM renalreg.lastmodaldata 
WHERE rrmodalcode is NULL AND lastmodalcode !='death'";
$mysqli->query($sql);
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

$sql="DELETE FROM renalreg.lastmodaldata 
WHERE lastmodalcode is NULL";
$mysqli->query($sql);
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION Set RR code=70 for death patients in qtr
$sql="UPDATE renalreg.lastmodaldata 
SET rrmodalcode=70 WHERE lastmodalcode='death'";
$mysqli->query($sql);
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
echo "<p><code>lastmodaldata for quarter gathered and processed...</code></p>";

echo "<p><code>Starting miscellaneous date fixes...</code></p>";

//START ACTION Fix various broken dates
$sql="UPDATE renalware.renaldata 
SET firstseendate=NULL WHERE firstseendate='0000-00-00'";
$mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
echo "<br><p><code>0000-00-00 firstseendates set to NULL ($numaffected dates)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
//START ACTION fix death date
$sql="UPDATE renalware.patientdata 
SET deathdate=NULL WHERE deathdate='0000-00-00'";
$mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
echo "<br><p><code>0000-00-00 deathdates set to NULL ($numaffected dates)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }


//START ACTION update patientdata with latest RRegno from rregpatlist
$sql="UPDATE renalware.patientdata p, renalreg.rregpatlist r 
SET p.rregno=r.rregno WHERE p.hospno1=r.hospno1";
$mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
echo "<p><code>Patient list updated with latest R Reg Numbers ($numaffected patients)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION set all patient rregflag=0 as default then turn on
$sql = "UPDATE renalware.patientdata SET rregflag=0";
$mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
for ($i=0; $i < $numaffected/10; $i++) { echo "&lowast;"; }
echo "<p><code>All renal reg flags set to 0 ($numaffected patients)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION ensure endstagedate filled in (stored in 2 tables)
$sql="UPDATE renalware.renaldata, renalware.esrfdata 
SET endstagedate=esrfdate WHERE renalzid=esrfzid AND endstagedate IS NULL";
$mysqli->query($sql);

//----Wed 19 Jan 2011----updated to use esrfdata
//START ACTION set rregflag=1 if patient has esrfdate in renaldata
$sql="UPDATE renalware.patientdata, renalware.esrfdata 
SET rregflag=1 WHERE patzid=esrfzid AND esrfdate IS NOT NULL";
$mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
echo "<br><p><code>Patients with ESRF dates flagged for renal reg ($numaffected patients)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
echo "<p><code>Starting miscellaneous purges...</code></p>";
//START ACTION deflag optout patients NOT ENABLED
/*
$sql="UPDATE renalware.patientdata SET rregflag=0 WHERE renalregoptout='Y'";
$mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
echo "<br><p><code>Patients with renalregoptout=Y purged ($numaffected patients)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
*/

//START ACTION deflag dead patients where deathdate unknown
$sql="UPDATE renalware.patientdata SET rregflag=0 
WHERE modalcode='death' AND deathdate is NULL";
$mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
echo "<br><p><code>Dead patients with unknown deathdates purged ($numaffected patients)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION deflag patients who died prior to qtr start
$sql = "UPDATE renalware.patientdata SET rregflag=0 
WHERE deathdate<'$qtrstart_ymd'";
$result = $mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
echo "<br><p><code>Patients who died prior to QTR start ($qtrstart_ymd) purged ($numaffected patients)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION deflag patients with ESRF date after qtr end
$sql="UPDATE renalware.patientdata, renalware.esrfdata 
SET rregflag=0 WHERE patzid=esrfzid AND esrfdate >'$qtrend_ymd'";
$result = $mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
echo "<br><p><code>Patients with ESRF dates after QTR end ($qtrend_ymd) purged ($numaffected patients)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION deflag pats with first modaldate after qtr end
$sql = "UPDATE renalware.patientdata, renalreg.firstmodaldates 
SET rregflag=0 WHERE firstmodaldate >'$qtrend_ymd' AND patzid=modalzid";
$result = $mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
echo "<br><p><code>Patients with first modality dates after QTR end ($qtrend_ymd) purged ($numaffected patients)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }

//START ACTION deflag pats who transferred out before qtr start
$sql = "UPDATE renalware.patientdata, renalreg.qend_modals 
SET rregflag=0 WHERE qmodalcode='transferout' 
AND qmodaldate<'$qtrstart_ymd' AND patzid=qmodalzid;";
$result = $mysqli->query($sql);
$numaffected=$mysqli->affected_rows;
echo "<br><p><code>Patients who transferred out before QTR start ($qtrstart_ymd) purged ($numaffected patients)</code></p>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
echo "<p><code>Data preparation finished!</code></p>";

//GET FINAL COUNT where rregflag=1
$sql="SELECT patzid FROM renalware.patientdata WHERE rregflag=1";
$result = $mysqli->query($sql);
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
$numrows=$result->num_rows;
echo "<p><code>$numrows patient records prepared.</code></p>";

//INSERT core data into thisqtrpatdata
$sql="INSERT INTO renalreg.$thisqtrpatdata 
SELECT patzid,$thisqtr, rregno, hospno1,lastname, firstnames, 
sex,birthdate,deathdate,modalcode,modalsite,postcode,ethnicity,
firstseendate,endstagedate,esdflag,rrmodalcode,rregsitecode,sitetype,NULL,NULL
FROM renalware.patientdata 
JOIN renalware.renaldata ON patzid=renalzid 
JOIN renalware.esrfdata ON patzid=esrfzid 
JOIN renalreg.lastmodaldata m ON patzid=lastmodalzid 
WHERE rregflag=1 ORDER BY lastname, firstnames";
$result = $mysqli->query($sql);
$numrows=$result->affected_rows;
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
echo "<p><code>$numrows records inserted into Quarter $thisqtr Patient Data table</code></p>";
echo '<div class="alert">Continue by generating output file (ensure Path has been run for Qtr '.$thisqtr.')</div>
<a class="btn btn-success" href="renalreg/runquarter.php?qtr='.$thisqtr.'&amp;debug='.$get_debug.'" >View Renal Reg output (new window)</a>';
include 'incl/footer_incl.php';
