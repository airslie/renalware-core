<?php
//----Wed 10 Jul 2013----goldregflag display
//--Fri Oct 26 16:11:33 SGT 2012--
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="patientdata JOIN arcdata ON patzid=arczid LEFT JOIN esrfdata ON patzid=esrfzid";
$fieldslist=array(
	'patzid'=>'ZID',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
	'modalcode'=>'modal',
	'modalsite'=>'site',
	'goldregisterflag'=>'Gold Reg?',
	'LEFT(EDTAtext,60)' => 'Renal Diagnosis (may be truncated)',
	'arcmodifstamp' => 'Last updated',
	);
$where="";
$omitfields=array('patzid');
$listnotes='';
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	'renal/renal.php?scr=advrenalcare' => "ARC", 
	);
$showsql=FALSE;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'arclists/arclist_incl.php';
