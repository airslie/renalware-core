<?php
$insertfields="addstamp, peritzid";
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
$table = "peritonitisdata";
$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
# //log the event
$eventtype="NEW PERITONITIS DATA ADDED: started $rxstartdate -- Org 1: $organism1 Org 2: $organism2";
include "$rwarepath/run/logevent.php";
showAlert("The Peritonitis data for ' . $firstnames . ' ' . $lastname . ' has been recorded!");
?>