<?php
//Wed Oct 22 16:44:40 IST 2008
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="renaldata JOIN patientdata ON renalzid=patzid";
//set fields and preferred labels/headers
//use patzid to build options
include 'txwaitlistfields_incl.php';
$where="WHERE txWaitListStatus ='Active'";
$listnotes=""; //appears before "Last run"
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	'renal/renal.php?scr=txstatus' => "TxStatus", 
	);
//TEST MODE -- set to TRUE to display SQL for debugging
$showsql=FALSE;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
//searchbardiv follows
include 'incl/searchdiv.php';
include 'incl/renderjqlist_incl.php';
?>