<?php
//--Sun Mar  3 16:50:53 EST 2013--
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="patientdata JOIN akidata ON patzid=akizid";
$fieldslist=array(
	'patzid'=>'ZID',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
	'modalcode'=>'modal',
	'episodedate' => 'Episode date',
	'stopdiagnosis' => 'STOP Diagnosis',
	'akioutcome' => 'Outcome',
	);
$where="";
$omitfields=array('patzid');
$listnotes='';
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	'renal/renal.php?scr=aki' => "AKI", 
	);
$showsql=false;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'akilists/akilist_incl.php';
