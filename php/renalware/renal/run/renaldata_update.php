<?php
$table="renalware.renaldata";
$update_id="renalzid";
$renalzid=$zid;
$updatefields="renalmodifstamp=NOW()";
//-----------END CONFIG--------
foreach ($_POST as $field => $value) {
	$fieldvalue=$mysqli->real_escape_string($value);
	${$field} = (strtolower(substr($field,-4))=="date") ? fixDate($fieldvalue) : $fieldvalue;
	$updatefields .= ", $field='${$field}'";
}
$sql = "UPDATE $table SET $updatefields WHERE renalzid=$zid";
$result = $mysqli->query($sql);
//log the event
$eventtype="Patient ID ".${$update_id}." renal data updated";
$eventtext=$updatefields;
include "$rwarepath/run/logevent.php";
?>