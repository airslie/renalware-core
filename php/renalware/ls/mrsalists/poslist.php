<?php
//----Mon 16 May 2011----
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
$listcode="mrsa";
$listtable="mrsadata";
$listitems="Positive MRSA swabs";
//set tables incl JOINs
$table="$listtable JOIN patientdata ON {$listcode}zid=patzid";
//set fields and preferred labels/headers
//use patzid to build options
include "{$listcode}listfields_incl.php";
$orderby="ORDER BY swabdate DESC";
$where="WHERE swabresult='POS'";
$listnotes="Displaying all positive MRSA swabs. Links open in new windows. Click on headers to sort. The Search operates across all fields.";
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
//	'pat/patient.php?vw=admin' => "admin", 
//	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	'renal/renal.php?scr=mrsa' => "MRSA screen", 
	);
//TEST MODE -- set to TRUE to display SQL for debugging
$showsql=FALSE;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'incl/renderdatatable_incl.php';
?>