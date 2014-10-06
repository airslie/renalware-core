<?php
//--Mon Jul 29 16:47:25 EDT 2013--
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
	'medmodal'=>'modal at Rx',
	'adddate'=>'started',
	'termdate'=>'ended',
	'drugname'=>'drug name',
	'dose'=>'dose',
	'route'=>'route',
	'freq'=>'freq',
	'immunosuppdrugdelivery'=>'delivery?',
	'medsdata.adduser'=>'added by',
	'termuser'=>'ended by',
	);
$where="WHERE (DATEDIFF(CURDATE(),adddate)<31 or DATEDIFF(CURDATE(),termdate)<31) AND medsdata.immunosuppflag=1";
$listnotes="Includes Immunosuppressants started or ended in last 30 days."; //appears before "Last run"
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	//'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	'pat/patient.php?vw=meds' => "meds", 
);
$omitfields=array('patzid','medsdata_id');
$listnotes.=" Click on headers to sort; search operates across all fields"; //appears before "Last run"
$showsql=false;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'incl/renderdatatable_incl.php';
