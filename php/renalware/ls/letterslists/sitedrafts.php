<?php
//----Tue 11 Jun 2013----datatable upgrade
//Fri May 23 15:35:34 CEST 2008
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="letterdata";
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
	);
//$where="WHERE (DATEDIFF(CURDATE(),adddate)<31) AND medsdata.esdflag=1";
$where="WHERE status='DRAFT'";
$listnotes="$siteshort DRAFTS."; //appears before "Last run"
//scr optionlinks-- suggest first 2 at least
$omitfields=array('letterzid','letter_id');
$optionlinks = array(
	'../letters/editletter.php?' => "view/edit", 
	'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	);
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'letterslists/letterlist_incl.php';
