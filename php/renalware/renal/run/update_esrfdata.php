<?php
//----Wed 06 Aug 2014----handle PRD
//Sun Dec 20 14:41:09 JST 2009
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
if ($_POST["edtacode"])
	{
	$sql= "SELECT esrfcause FROM esrfcauses WHERE edtacode='$edtacode' LIMIT 1";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$EDTAtext=$row['esrfcause'];
	}
//update the table
$table = 'renalware.esrfdata';
$where = "WHERE esrfzid=$zid";
$updatefields = "firstseendate='$firstseendate',esrfweight='$esrfweight', EDTAcode='$edtacode', EDTAtext='$EDTAtext',esrfmodifstamp=NOW(), rreg_prdcode='$rreg_prdcode', rreg_prddate=CURDATE()";
$sql= "UPDATE $table SET $updatefields $where";
$result = $mysqli->query($sql);
//log the event
$eventtype="Patient core ERF Data updated";
if ($rreg_prdcode) {
    $eventtype="Patient core ERF Data/PRD code updated";
}
$eventtext=$mysqli->real_escape_string($updatefields);
include "$rwarepath/run/logevent.php";
header ("Location: $rwareroot/renal/renal.php?zid=$zid&scr=esrf");
