<?php
//----Mon 06 Jan 2014----fix JOIN and WHERE
//----Sun 29 Dec 2013----JOIN akidata
//----Fri 28 Jun 2013----akirisk
//Wed Oct 22 16:44:40 IST 2008
//------------SETUP--------------
//set DB for max flexibility
$mysqli->select_db("renalware");
//set tables incl JOINs
$table="consultdata JOIN patientdata ON consultzid=patzid JOIN akidata ON consult_id=consultid";
$fieldslist=array(
	'consult_id'=>'ID',
	'aki_id'=>'aki ID',
	'consultzid'=>'ZID',
	'consultsite'=>'Site',
	'othersite'=>'Site 2',
	'activeflag'=>'active?',
	'sitehospno'=>'HospNo',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
	'consultstaffname' => 'staff name',
//	'akiriskflag'=>'AKI risk?',
	'consultmodal' => 'modal',
	'consultstartdate' => 'startdate',
	'consultenddate' => 'end date',
	'consulttype' => 'consult type',
//	'consultward' => 'consult ward',
//	'consultdescr' => 'descr',
		);
//$where="WHERE akiriskflag ='Y'";
$where=""; //no need due to JOIN
$omitfields=array('consult_id','consultzid','activeflag','aki_id');
$listnotes="Patients with the Consult AKI Risk marked Y will have an AKI Episode created automatically"; //appears before "Last run"
//scr optionlinks-- suggest first 2 at least
$optionlinks = array(
	'pat/patient.php?vw=clinsumm' => "clinsumm", 
	);
$showsql=false;
//------------END SET UP---------
//------------DO NOT MODIFY BELOW THIS LINE!---------
include 'consultlists/akiconsultlist_incl.php';
