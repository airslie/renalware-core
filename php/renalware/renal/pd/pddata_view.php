<?php
//Wed Oct 22 13:47:50 IST 2008 ----Thu 04 Aug 2011----
$showfieldsrow1=array(
	'currBP' => 'BP',
	'Weight' => 'Weight',
	'BMI' => 'BMI',
    'endstagedate' => 'ESRF date',
    'EDTAtext' => 'ESRF cause',
	);
?>
<div class="ui-state-default datadiv" >
<?php
	foreach ($showfieldsrow1 as $key => $value) {
		echo "<b>$value</b> ${$key} &nbsp;&nbsp;";
	}
echo "<br><b>Tx Wait List Status</b> $txWaitListStatus";
//----Thu 04 Aug 2011----
if ($mrsaflag) {
	echo "<br><b>Last MRSA</b> $mrsadate <b>Swab site</b> $mrsasite <b>Positive?</b> $mrsaflag";
}
$petadeqdata=array(
'petadeq_id'=>'petadeq_id',
'petadeqzid'=>'petadeqzid',
'addstamp'=>'addstamp',
'adduser'=>'adduser',
'adduid'=>'adduid',
'adddate'=>'updated',
'transporterstatus'=>'transporter status',
'ktv'=>'KT/V',
'cre_clear'=>'CRE clearance',
'fluidremoval_24hrs'=>'24hr fluid removal',
'urinevolume_24hrs'=>'24hr urine vol',
'regimechange'=>'regime change',
);
$table="petadeqdata";
include 'maps/'.$table.'.php';
$fields="adddate, transporterstatus, ktv, cre_clear, fluidremoval_24hrs";
$where="WHERE petadeqzid=$zid";
$orderby="ORDER BY addstamp DESC";
$limit="LIMIT 1";
$sql = "SELECT $fields FROM $table $where $orderby $limit";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
if ($row) {
	echo "<br>PET/Adequacy: ";
	foreach($row AS $key => $value)
		{
		$data = $value;
		$label=$petadeqdata[$key];
		$data = (substr($key,-4)=="date") ? dmyyyy($value) : $value ;
		echo "<b>$label</b>: $data &nbsp;&nbsp;";
		}
	}
?>
</div>