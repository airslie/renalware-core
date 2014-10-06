<?php
//--Wed Aug  6 14:15:07 EDT 2014--
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="patientdata JOIN esrfdata ON patzid=esrfzid LEFT JOIN rreg_prdcodes ON rreg_prdcode=prdcode";
$fieldslist=array(
	'patzid'=>'ZID',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
    'esrfdate'=>'ESRF date',
	'EDTAcode'=>'EDTA',
	'LEFT(EDTAtext,60)' => 'EDTA Diagnosis (may be truncated)',
	'rreg_prdcode'=>'PRD',
	'LEFT(prdterm,60)' => 'Primary Renal Diagnosis (may be truncated)'
);
$where="WHERE esrfdate IS NOT NULL";
$omitfields=array('patzid');
$listnotes='';
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	'renal/renal.php?scr=esrf' => "ESRF", 
	);
$showsql=false;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'esrflists/esrflist_incl.php';
