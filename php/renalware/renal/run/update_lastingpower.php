<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$updatefields="modifstamp=NOW(),lastingpowerflag='Y',lastingpowerdate=NOW()";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
			//omit letter_id if passed
			if ($key!="zid") {
				$updatefields .= $value ? ", $key='".${$key}."'" : ", $key=NULL";
			}
}
//update the table
$table = 'renalware.patientdata';
$where = "WHERE patzid = $zid";
$sql= "UPDATE $table SET $updatefields $where";
$result = $mysqli->query($sql);
//log the event
$eventtype="Patient Lasting Power Attorney Info updated";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
$runmsgtxt="Thank you. The Lasting Power details have been updated.";
$_SESSION['runmsg']=$runmsgtxt;
header ("Location: $rwareroot/renal/renal.php?scr=advdir_lpa&zid=$zid");
?>