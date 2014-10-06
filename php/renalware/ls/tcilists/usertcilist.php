<?php
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
$thissite=$get_site;
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
	'tcinotes'=>'tcinotes',
	'activeflag'=>'active',
	);
$where="WHERE tcilistuid='$uid' AND activeflag =1";
$omitfields=array('tcilist_id','tcilistzid','activeflag','tcinotes');
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