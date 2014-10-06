<?php
//Fri May 16 22:54:02 CEST 2008
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
	"REPLACE(drugname,' (Epoetin Alfa)','') as drugname"=>'ESA',
	'dose'=>'dose',
	'route'=>'route',
	'freq'=>'freq',
	);
$where="WHERE (DATEDIFF(CURDATE(),adddate)<31 OR DATEDIFF(CURDATE(),termdate)<31) AND medsdata.esdflag=1 AND medmodal NOT IN ('HD_unit','HD_ward')";
$orderby="ORDER BY adddate";
$listnotes="Includes ESA prescriptions started or ended in last 30 days."; //appears before "Last run"
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