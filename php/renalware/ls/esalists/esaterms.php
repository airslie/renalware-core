<?php
//Mon May 19 15:42:44 CEST 2008 START
//Mon May 19 15:44:03 CEST 2008 END!
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="medsdata JOIN patientdata ON medzid=patzid";
//set fields and preferred labels/headers
//use patzid to build options
$fieldslist=array(
	'patzid'=>'ZID',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
	'termdate'=>'date ended',
	'termuser'=>'ended by',
	'medmodal'=>'modal at Rx',
	'drugname'=>'drug name',
	'dose'=>'dose',
	'route'=>'route',
	'freq'=>'freq',
	'esdunitsperweek'=>'Units/Week',
	'adddate'=>'started',
	'medsdata.adduser'=>'added by',
	);
$where="WHERE (DATEDIFF(CURDATE(),termdate)<31) AND medsdata.esdflag=1";
$listnotes="Includes ESA prescriptions ended in last 30 days."; //appears before "Last run"
$optionlinks = array(
	//'pat/patient.php?vw=admin' => "admin", 
	//'pat/patient.php?vw=clinsumm' => "clinsumm", 
//	'pat/patient.php?vw=meds' => "meds", 
	'renal/renal.php?scr=esa' => "view", 
	);
$omitfields=array('patzid','medsdata_id');
$listnotes.=" Click on headers to sort; search operates across all fields"; //appears before "Last run"
$showsql=FALSE;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'incl/renderdatatable_incl.php';
?>