<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$updatefields="modifstamp=NOW()";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
			$updatefields .= $value ? ", $key='".${$key}."'" : ", $key=NULL";
}
$zid=$patzid;
//update the table
$tables = 'renalware.patientdata';
$where = "WHERE patzid = $patzid LIMIT 1";
$sql= "UPDATE $tables SET $updatefields $where";
$result = $mysqli->query($sql);
//log the event
$eventtype="Patient Transport Info updated";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
$runmsgtxt="Thank you. The patient data have been updated.";
$_SESSION['runmsg']=$runmsgtxt;
header ("Location: $rwareroot/pat/patient.php?vw=admin&zid=$patzid");
?>