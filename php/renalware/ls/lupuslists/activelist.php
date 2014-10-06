<?php
//--Fri Oct 26 16:11:33 SGT 2012--
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="patientdata JOIN lupusdata ON patzid=lupuszid";
$fieldslist=array(
	'patzid'=>'ZID',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
	'modalcode'=>'modal',
	'modalsite'=>'site',
	'lupusadddate' => 'Add date',
	'lupusdxdate' => 'Lupus Dx date',
	'lupususer' => 'Added by',
	);
$where="";
$omitfields=array('patzid');
$listnotes='';
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	'renal/renal.php?scr=lupus' => "lupus", 
	);
$showsql=FALSE;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'lupuslists/lupuslist_incl.php';
