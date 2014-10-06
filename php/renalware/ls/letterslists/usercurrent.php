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
	'letter_id'=>'ID',
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
//$where="WHERE (DATEDIFF(CURDATE(),adddate)<31) AND medsdata.esdflag=1";
$where="WHERE status IN ('DRAFT','TYPED') AND (authorid=$uid OR typistid=$uid)";
$listnotes="DRAFTS or TYPED letters authored or typed by $user.";
$omitfields=array('letterzid','letter_id');
$optionlinks = array(
	'../letters/editletter.php?' => "view/edit", 
	'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	);
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'letterslists/letterlist_incl.php';
