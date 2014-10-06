<?php
//created on 2009-01-18.
//versionstamp 
$fieldslist=array(
	'patzid'=>'ZID',
	'hospno1'=>'KCH No',
	"concat(lastname,', ',firstnames)"=>'patient',
	'age'=>'age',
	'sex'=>'sex',
	'modalcode'=>'modal',
	'modalsite'=>'site',
	'endstagedate' => 'ESRF date',
	'TxNHBconsent' => 'NHB cons?',
	'txWaitListEntryDate' => 'Entry Date',
	'DATEDIFF(CURDATE(),txWaitListEntryDate)' => 'DOL',
	'txBloodGroup' => 'BldGrp',
	'txAbsHighest' => 'HighAbs',
	'txAbsHighestDate' => 'HighAbs date',
	'txAbsLatest' => 'LastAbs',
	'txAbsLatestDate' => 'LastAbs date',
	'txNoGrafts' => 'PrevOps',
	"if(txAbsLatest>60, 'Sens', 'Unsens')" => 'Sens (Abs&gt;60)',
	'txTransplType' => 'Tx Type',
	);
$orderby="ORDER BY lastname, firstnames";
?>