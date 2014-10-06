<?php
//--Thu Apr 24 08:35:20 BST 2014--
$fieldslist=array(
	'consult_id'=>'ID',
	'consultzid'=>'ZID',
	"CONCAT(consultsite,' ',IFNULL(othersite,''), '<br>',IFNULL(consultward,''),' ',IFNULL(contactbleep,'')) as site"=>'Site/Ward/Bleep',
'consultward' => 'Ward',
	'activeflag'=>'active?',
	'sitehospno'=>'Hosp No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
	'consultmodal' => 'modal',
	'akiriskflag'=>'AKI?',
	'consultstartdate' => 'startdate',
    'consultstaffname' => 'staff name',
	'consultdescr' => 'descr'
	);
