<?php
$table="renalware.capdworkups";
$update_id="workupzid";
$workupzid=$zid;
$updatefields="workupmodifstamp=NOW()";
//-----------END CONFIG--------
foreach ($_POST as $field => $value) {
	$fieldvalue=$mysqli->real_escape_string($value);
	${$field} = (strtolower(substr($field,-4))=="date") ? fixDate($fieldvalue) : $fieldvalue;
	$updatefields .= ", $field='${$field}'";
}
$sql = "UPDATE $table SET $updatefields WHERE $update_id=${$update_id} LIMIT 1";
$result = $mysqli->query($sql);
//log the event
$eventtype="Patient ID ".${$update_id}." PD Workup updated";
$eventtext=$updatefields;
include "$rwarepath/run/logevent.php";
if (!$debug) {
	header ("Location: $rwareroot/renal/renal.php?scr=renalsumm&zid=$zid"); //****UPDATE
}
?>