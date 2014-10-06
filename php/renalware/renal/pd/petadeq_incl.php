<?php
//Sun Mar 30 18:41:10 ICT 2008
$table="petadeqdata";
include 'maps/'.$table.'.php';
$fields="adddate, petdate, adeqdate, transporterstatus, ktv, cre_clear, fluidremoval_24hrs, urinevolume_24hrs, regimechange";
$where="WHERE petadeqzid=$zid";
$orderby="ORDER BY addstamp DESC";
$limit="LIMIT 1";
$sql = "SELECT $fields FROM $table $where $orderby $limit";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
if ($row) {
foreach($row AS $key => $value)
	{
	$label=${$table}[$key];
	$data = $value;
	if (substr($key,-4)=="date")
		{
		$data = dmyyyy($value);
		}
	echo "<li><label class=\"displ\">$label</label>&nbsp;&nbsp;$data</li>";
	}
}
?>
