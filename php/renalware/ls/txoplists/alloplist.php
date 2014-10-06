<?php
//--Sun Mar  3 16:50:53 EST 2013--
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="patientdata JOIN txops ON patzid=txopzid";
$fieldslist=array(
	'patzid'=>'ZID',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'patage'=>'age at Op',
	'sex'=>'sex',
	'modalcode'=>'modal',
	'txopdate' => 'Op date',
	'txoptype' => 'Op type',
	'failuredate' => 'Failed?',
	);
$where="";
$omitfields=array('patzid');
$listnotes='';
//scr optionlinks-- suggest first 2 at least
//NB view op link in _incl file
//<a href="renal/txop/view_txop.php?zid='.$zid.'&amp;id='.$row["txop_id"].'">View Op</a>';
$optionlinks = array(
	'pat/patient.php?vw=admin' => "admin", 
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
);
$showsql=false;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'txopslists/txoplist_incl.php';
