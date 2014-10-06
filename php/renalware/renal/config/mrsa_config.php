<?php
//----Sun 15 May 2011----
$mrsa_adddatamap=array(
	'mrsa_id'=>'x^ID',
	'swabstamp'=>'x^added',
	'mrsazid'=>'x^ZID',
	'swabuid'=>'x^UID',
	'swabuser'=>'x^swab user',
	'swabadddate'=>'x^add date',
	'swabdate'=>'c^swab date',
	'swabsite'=>'s^swab site',
	'othersite'=>'t60^other site (max 60 char)',
	'resultstamp'=>'x^result entered',
	'resultuser'=>'x^result user',
	'resultdate'=>'c^result date',
	'swabresult'=>'s^result',
);
$mrsa_upddatamap=array(
	'mrsa_id'=>'x^ID',
	'swabuser'=>'x^swab user',
	'swabadddate'=>'x^add date',
	'swabdate'=>'x^swab date',
	'swabsite'=>'x^swab site',
	'resultdate'=>'c^result date',
	'swabresult'=>'s^result',
);

$mrsa_showdatamap=array(
	'mrsa_id'=>'x^ID',
	'swabstamp'=>'x^added',
	'mrsazid'=>'x^ZID',
	'swabuid'=>'x^UID',
	'swabuser'=>'x^swab user',
	'swabadddate'=>'x^add date',
	'swabdate'=>'c^swab date',
	'swabsite'=>'s^swab site',
	'resultstamp'=>'x^result entered',
	'resultuser'=>'x^result user',
	'resultdate'=>'c^result date',
	'swabresult'=>'s^result',
);
//optionlists
$swabsitearray=array(
	'multiple swab sites',
	'HD line exit site',
	'PD catheter exit site',
	'fistula/PTFE',
	'wound',
	'other--specify below'
);
$swabresultarray=array(
	"POS",
	"NEG",
);

$optionfields=array('swabsite','swabresult');

foreach ($optionfields as $fld) {
	$fldarray=${$fld.'array'};
	${$fld.'_options'}="";
	foreach ($fldarray as $option) {
		${$fld.'_options'}.="<option>$option</option>";
	}
}
?>