<?php
//Wed Aug  6 17:04:17 CEST 2008
//Mon May 11 16:18:14 BST 2009 Fri May 15 09:44:00 BST 2009
$table="homehdassessdata";
include "$rwarepath/renal/maps/$table.php";
$fields="
referraldate,
selfcarelevel,
selfcarenotes,
letterwrittentype,
letterwrittendate,
letterrecvtype,
letterrecvdate,
medicalassess,
medicaldate,
technicalassess,
technicaldate,
socialworkassess,
socialworkdate,
counsellorassess,
counsellordate,
fullindepconfirm,
fullindepconfirmdate,
programmetype,
carername,
carernotes,
acceptancedate,
equipinstalldate,
firstdeliverydate,
trainingstartdate,
firstindepdialdate,
assessmentnotes,
assessor";
$where="WHERE homehdassesszid=$zid";
$limit="LIMIT 1";
$sql = "SELECT $fields FROM $table $where $limit";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
if ($row) {
	echo '<ul class="portal">';
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
	echo "</ul>";
}
?>
