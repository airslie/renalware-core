<?php
//Wed Oct 22 16:44:40 IST 2008
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="tcilistdata JOIN patientdata ON tcilistzid=patzid";
$fieldslist=array(
	'tcilist_id'=>'ID',
	'tcilistzid'=>'ZID',
	'tcilistrank'=>'Rank',
	'tcipriority'=>'Priority',
	'patlocation'=>'Location',
	"concat(lastname,', ',firstnames)"=>'patient',
	'hospno1'=>'KCH No',
	'age'=>'age',
	'sex'=>'sex',
	'tcireason'=>'tcireason',
	'tcilistadddate'=>'added',
	'tcilistremovaldate'=>'removed',
	'tcilistremovalcause'=>'removal cause',
		);
$where="WHERE activeflag=0";
$omitfields=array('tcilist_id','tcilistzid');
$listnotes=""; //appears before "Last run"
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	);
$showsql=FALSE;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'tcilists/tcilist_incl.php';
?>