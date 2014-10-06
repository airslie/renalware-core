<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$zid=$get_zid;
	$table="renalware.exitsitedata";
	$update_id="exitsitedata_id";
	$updatefields="modifstamp=NOW()";
	//-----------END CONFIG--------
	foreach ($_POST as $field => $value) {
		$fieldvalue=$mysqli->real_escape_string($value);
		${$field} = (strtolower(substr($field,-4))=="date") ? fixDate($fieldvalue) : $fieldvalue;
		$updatefields .= ", $field='${$field}'";
	}
	$sql = "UPDATE $table SET $updatefields WHERE $update_id=${$update_id} LIMIT 1";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="$table Data ID ".${$update_id}." updated";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	header ("Location: $rwareroot/renal/renal.php?zid=$zid&scr=pd");
?>