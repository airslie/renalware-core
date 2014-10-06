<?php
require '../../config_incl.php';
include '../../incl/check.php';
include '../../fxns/fxns.php';
include '../../fxns/formfxns.php';
$zid=$get_zid;
	$table="renalware.homehdassessdata";
	$update_id="homehdassess_id";
	$updatefields="";
	//-----------END CONFIG--------
	foreach ($_POST as $field => $value) {
		$fieldvalue=$mysqli->real_escape_string($value);
		${$field} = (strtolower(substr($field,-4))=="date") ? fixDate($fieldvalue) : $fieldvalue;
		$updatefields .= ", $field='${$field}'";
	}
	$updatefields=substr($updatefields,1);//init comma
	$sql = "UPDATE $table SET $updatefields WHERE $update_id=${$update_id} LIMIT 1";
	$result = $mysqli->query($sql);
//	echo "<br>TEST: $sql <br>";
	//log the event
	$zid=$homehdassesszid; //*****UPDATE
	$eventtype="$table Data ID ".${$update_id}." updated";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	header ("Location: $rwareroot/renal/renal.php?scr=homehdnav&zid=$zid"); //****UPDATE
?>