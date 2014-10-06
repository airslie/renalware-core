<?php
$table = "exitsitedata";
$insertfields="addstamp, exitsitezid";
$insertvalues="NOW(), $zid";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
			$insertfields .= $value ? ", $key" : "";
			$insertvalues .= $value ? ", '".${$key}."'" : "";
	}
$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
# //log the event
$eventtype="NEW EXIT SITE INFECTION: $infectiondate -- Org 1: $organism1 Org 2: $organism2";
//$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
showAlert("The Exit Site Infection data for ' . $firstnames . ' ' . $lastname . ' has been recorded!");
?>