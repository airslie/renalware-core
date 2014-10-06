<?php
//----Mon 16 May 2011----
$fieldslist=array(
	'patzid'=>'ZID',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
	"mrsa_id"=>'ID',
	"swabdate"=>'swab date',
	"swabsite"=>'swab site',
	"swabuser"=>'swab user',
	"resultdate"=>'result date',
	"swabresult"=>'result',
	);
$omitfields=array('patzid','mrsa_id');
?>