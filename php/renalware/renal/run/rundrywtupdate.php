<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$insertfields="addstamp";
$insertvalues="NOW()";
foreach ($_POST as $key => $value) {
	if ($value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
			$insertfields.= ", $key";
			$insertvalues.= ", '".${$key}."'";
	}
}
	//insert into the table
	$zid=$drywtzid;
	$table = 'renalware.hddryweightdata';
	$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	//update the profile
	$sql = "UPDATE renalware.hdpatdata SET hdmodifstamp=NOW(), dryweight='$dryweight', drywtassessdate='$drywtassessdate', drywtassessor='$drywtassessor' WHERE hdpatzid=$zid";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="Patient HD Dry Weight updated: $dryweight by $drywtassessor";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	header ("Location: $rwareroot/renal/renal.php?zid=$zid&scr=hdnav&hdmode=profile");
?>