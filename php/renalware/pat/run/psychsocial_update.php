<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$updatefields="psychsoc_stamp=NOW(), renalmodifstamp=NOW()";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if ($key!="zid") {
			$updatefields .= $value ? ", $key='".${$key}."'" : ", $key=NULL";
		}
	}
	//specials
	//update the table
	$tables = 'renaldata';
	$where = "WHERE renalzid=$zid";
	$sql = "UPDATE $tables SET $updatefields $where LIMIT 1";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="Patient Psych/Social data updated";
	$eventtext=$mysqli->real_escape_string($updatefields);
	include "$rwarepath/run/logevent.php";
	header ("Location: $rwareroot/pat/patient.php?zid=$zid&vw=psychsocial");
?>