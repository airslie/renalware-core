<?php
//----Tue 11 Jun 2013----datatable upgrade
//---------------Sun Jan  8 12:00:35 EST 2012 for GP email version
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
//$table="letterdata JOIN gpemaillogs ON letter_id=logletter_id";
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
	'g.log_id as glog'=>'email',
	'c.log_id as clog'=>'CDA',
	);
$where="WHERE printstage=1 AND (g.log_id IS NOT NULL OR c.log_id IS NOT NULL)";
$listnotes="$siteshort Printer Queue of GP Letters sent by email/Docman (Print CC copies only)";
//scr optionlinks-- suggest first 2 at least
makeAlert("IMPORTANT: GP emailing",'Please note that a copy of these letters have been sent electronically to the GP.');
$omitfields=array('letterzid','letter_id');
$optionlinks = array(
	'../letters/editletter.php?' => "view/edit", 
	'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	);
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'letterslists/letterlist_incl.php';
