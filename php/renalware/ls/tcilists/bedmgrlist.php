<?php
//---------------Thu Feb  2 17:15:25 CET 2012---------------
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="tcilistdata JOIN patientdata ON tcilistzid=patzid LEFT JOIN bedmgt.proceddata ON tciproced_id=pid";
$fieldslist=array(
	'tcilist_id'=>'ID',
	'tcilistzid'=>'ZID',
	'tciproced_id'=>'PID',
	'tcilistrank'=>'Rank',
	'tcipriority'=>'Priority',
	'patlocation'=>'Location',
	"concat(lastname,', ',firstnames)"=>'patient',
	'hospno1'=>'KCH No',
	'age'=>'age',
	'sex'=>'sex',
	'tcireason'=>'Reason',
	'tcilistadddate'=>'added',
	'tcinotes'=>'tcinotes',
	'activeflag'=>'active',
	'status'=>'Bed Mgt status',
	);
$where="WHERE activeflag=1";
$omitfields=array('tcilist_id','tcilistzid','activeflag','tcinotes','tciproced_id');
$listnotes='<a href="ls/printtcilistlist.php">Print this Active list!</a>'; //appears before "Last run"
//scr optionlinks-- suggest first 2 at least
//$optionlinks = array(
//	'bedmgt/index.php?vw=proced&scr=requestsurgcase' => "request proced", 
//	);
$showsql=FALSE;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'tcilists/tcilistbed_incl.php';
?>