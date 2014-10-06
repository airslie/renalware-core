<?php
//----Thu 27 Jun 2013----EpisodeHeartFailure, notif
//Sun Dec 20 14:41:50 JST 2009
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
//update the table
$table = 'renalware.esrfdata';
$where = "WHERE esrfzid=$zid";
$updatefields = "esrfmodifstamp=NOW(),Angina='$Angina', PreviousMIlast90d='$PreviousMIlast90d', PreviousMIover90d='$PreviousMIover90d', PreviousCAGB='$PreviousCAGB', EpisodeHeartFailure='$EpisodeHeartFailure', Smoking='$Smoking', COPD='$COPD', CVDsympt='$CVDsympt', DiabetesNotCauseESRF='$DiabetesNotCauseESRF', Malignancy='$Malignancy', LiverDisease='$LiverDisease', Claudication='$Claudication', IschNeuropathUlcers='$IschNeuropathUlcers', AngioplastyNonCoron='$AngioplastyNonCoron', AmputationPVD='$AmputationPVD'";
$sql= "UPDATE $table SET $updatefields $where";
$result = $mysqli->query($sql);
//log the event
$eventtype="Patient ESRF Cormorbidity Data updated";
$eventtext=$mysqli->real_escape_string($updatefields);
include "$rwarepath/run/logevent.php";
$runmsgtxt="Thank you. The Renal Reg comorbidity data have been updated!";
$_SESSION['runmsg']=$runmsgtxt;
header ("Location: $rwareroot/renal/renal.php?zid=$zid&scr=esrf");
