<?php
//--Tue Sep  4 14:29:23 CEST 2012--
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="patientdata";
$fieldslist=array(
	'patzid'=>'ZID',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
	'modalcode'=>'modal',
	'modalsite'=>'site',
	'rpvstatus' => 'RPV Status',
	'rpvmodifstamp' => 'RPV updated',
	'rpvuser' => 'RPV user',
	);
$where="WHERE rpvstatus IS NOT NULL";
$omitfields=array('patzid');
$listnotes='Use the Quick Search Results to add patient to RPV'; //appears before "Last run"
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	);
$showsql=FALSE;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'rpvlists/rpvlist_incl.php';
