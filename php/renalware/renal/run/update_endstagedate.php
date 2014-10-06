<?php
//Sun Dec 20 14:19:15 JST 2009
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$zid = $_POST["zid"];
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
		}
	}
	//renal
	$updatefields = "endstagedate='$endstagedate', renalmodifstamp=NOW()";
	$sql= "UPDATE renalware.renaldata SET $updatefields WHERE renalzid=$zid";
	$result = $mysqli->query($sql);
	//set flag
	$updatefields = "esrfflag=1, modifstamp=NOW()";
	$sql= "UPDATE renalware.patientdata SET $updatefields WHERE patzid=$zid";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="Patient ESRF date set";
	$eventtext="New ESRF date=$endstagedate";
	include "$rwarepath/run/logevent.php";
	//ensure esrfdata record exists
	$sql="INSERT IGNORE INTO renalware.esrfdata (esrfzid, esrfstamp) VALUES ($zid,NOW())";
	$result = $mysqli->query($sql);
	//upd w/ date in case changed
	$updatefields = "esrfdate='$endstagedate', esrfmodifstamp=NOW()";
	$sql= "UPDATE renalware.esrfdata SET $updatefields WHERE esrfzid=$zid";
	$result = $mysqli->query($sql);
header ("Location: $rwareroot/renal/renal.php?zid=$zid&scr=esrf");
?>