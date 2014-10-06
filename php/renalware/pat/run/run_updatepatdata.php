<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$updatefields="modifstamp=NOW()";
$letter_id=FALSE;
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
			//omit letter_id if passed
			if ($key!="letter_id") {
				$updatefields .= $value ? ", $key='".${$key}."'" : ", $key=NULL";
			}
}
$zid=$patzid;
//update the table
$tables = 'renalware.patientdata';
$where = "WHERE patzid = $patzid LIMIT 1";
$sql= "UPDATE $tables SET $updatefields $where";
$result = $mysqli->query($sql);
//log the event
$eventtype="Patient Admin Details updated";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
$runmsgtxt="Thank you. The admin details have been updated.";
$_SESSION['runmsg']=$runmsgtxt;
if ($letter_id) {
	header ("Location: $rwareroot/letters/letters/editletter.php?letter_id=$letter_id&zid=$patzid");
} else {
	header ("Location: $rwareroot/pat/patient.php?vw=admin&zid=$patzid");
}
?>