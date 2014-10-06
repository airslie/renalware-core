<?php
//----Fri 30 May 2014---- formatting
$thistab="preppathology.php";
require '../config_incl.php';
require '../incl/check.php';
$pagetitle="Renal Reg Export: Pathology Data Prep";
include '../parts/head_bs.php';
include 'incl/renalreg_config.php';
include 'incl/rregmaps_incl.php';
include 'incl/navbar_incl.php';
echo '<div id="pagetitlediv"><h1><small>'.$pagetitle.'</small></h1></div>';
$rundate=date("m/d/Y");
echo "Flushing existing renal reg results data<br>";
//START ACTION
$sql="DELETE FROM renalreg.qtr_resultsdata";
$mysqli->query($sql);
if ($debug) {
	echo "$sql <br>";
}
echo "Flushing existing renal reg average path data<br>";
//START ACTION
$sql="DELETE FROM renalreg.qtr_pathdata";
$mysqli->query($sql);
if ($debug) {
	echo "$sql <br>";
}
//get all results for renal pats for qtr
echo "Gathering all pathology results for Qtr $sess_sessqtr...<br>";
$sql="INSERT INTO renalreg.qtr_resultsdata SELECT * FROM hl7data.pathol_results 
WHERE resultsdate BETWEEN '$thisstartdate' AND '$thisenddate';";
$mysqli->query($sql);
echo "<br>QUA $sess_sessqtr results data collected.<br>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
//run fixes
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
//	if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
	echo "$numrows $fld 0 values set to NULL...<br>";
	}
echo "Gathering average pathology datasets for Qtr $sess_sessqtr...<br>";
$sql="INSERT INTO renalreg.qtr_pathdata (pathzid, pathqtr, hospno, lastrunstamp, 
lastdate, QUA24, QUA23, QUA30, QUA31, QUA26, QUA10, QUA22, QUA21, QUA25, QUA33, 
QUA32, QUA34, QUA27, QUA11) SELECT patzid, $sess_sessqtr, resultspid,NOW(), 
MAX(resultsdate), ROUND(AVG(AL),1), ROUND(AVG(ALB),0), ROUND(AVG(CAL),2), 
ROUND(AVG(CCA),2), ROUND(AVG(CHOL),1), ROUND(AVG(CRE),0), ROUND(AVG(FER),0), 
ROUND(AVG(HB),1), ROUND(AVG(HBA),1), ROUND(AVG(BIC),0), ROUND(AVG(PHOS),2), 
ROUND(AVG(NA),0), ROUND(AVG(PTHI),0), ROUND(AVG(URE),1) 
FROM renalreg.qtr_resultsdata 
JOIN renalware.patientdata ON resultspid=hospno1 
WHERE HB<20 GROUP BY resultspid;";
$mysqli->query($sql);
echo "<br>QUA $sess_sessqtr path data collated. Please check the PATHQTR and LASTRUNSTAMP columns in the QTR_PATH table to ensure it has run properly.<br>";
if ($debug){ echo '<p class="alert">'.$sql.'</p>'; }
include 'incl/footer_incl.php';
