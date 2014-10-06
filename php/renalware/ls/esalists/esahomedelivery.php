<?php
//Fri May 16 22:54:02 CEST 2008
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="esddata JOIN patientdata ON esdzid=patzid";
//set fields and preferred labels/headers
//use patzid to build options
$fieldslist=array(
	'patzid'=>'patzid',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'sex'=>'sex',
	'age'=>'age',
	'esdstartdate'=>'ESA started',
	'esdmodifdate'=>'ESA modified',
	'modalcode'=>'modality',
	"REPLACE(esdregime,' (Epoetin Alfa)','') as esdregime"=>'Current ESA Regime',
	);
$where="WHERE esdstatus='Current' AND prescriber='Home Delivery'";
$listnotes=""; //appears before "Last run"
//scr optionlinks-- suggest first 2 at least
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