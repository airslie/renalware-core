<?php
//----Tue 11 Jun 2013----datatable upgrade and CDA handling
//Fri May 23 15:35:34 CEST 2008
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
//$table="letterdata LEFT JOIN gpemaillogs ON letter_id=logletter_id";
$table="letterdata LEFT JOIN gpemaillogs g ON letter_id=g.logletter_id LEFT JOIN gpCDAlogs c ON letter_id=c.logletter_id";
//set fields and preferred labels/headers
//use patzid to build options
$fieldslist=array(
	'letter_id'=>'letter_id',
	'status'=>'status',
	'letterzid'=>'letterzid',
	'typistinits'=>'typist',
	'authorlastfirst'=>'author',
	'patlastfirst'=>'patient',
	'letthospno'=>'Hosp No',
	'letterdate'=>'letter date',
	'lettertype'=>'type',
	'clinicdate'=>'clinic date',
	'lettdescr'=>'descr',
	'recipname'=>'recipient',
	'typeddate'=>'typed date',
	'reviewdate'=>'review date',
	'printdate'=>'print date',
	);
$where="WHERE printstage=1 AND (c.log_id IS NULL AND g.log_id IS NULL)";
$listnotes="$siteshort Printer Queue Including GP Letters NOT sent by email"; //appears before "Last run"
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	'../letters/editletter.php?' => "view/edit", 
	'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	);
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
makeAlert("IMPORTANT: GP emailing",'Please note that letters have NOT been emailed to the practice and a hard copy needs to be posted to the GP.');
$omitfields=array('letterzid','letter_id');
include 'letterslists/letterlist_incl.php';
