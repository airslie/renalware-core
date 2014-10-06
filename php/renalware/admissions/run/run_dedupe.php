<?php
//Wed Nov 18 12:58:16 CET 2009 fix for multiple EPR inserts

require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$admid = $mysqli->real_escape_string($_GET["duplicateid"]);
if ( $wardclerkflag)
	{
		$table = 'renalware.admissiondata';
		$where = "WHERE admission_id = $admid";
		$sql= "UPDATE $table SET admstatus='Cancelled',admittedflag=0,dischsummflag=1,dischsummstatus='Duplicate Admission--Unnecess', admmodifstamp=NOW() $where LIMIT 1";
		$result = $mysqli->query($sql);
		//echo "<br>TEST: $sql <br>";
	$eventtype="Admission $admid Cancelled";
	$eventtext=$mysqli->real_escape_string($sql); //store sql!
	include "$rwarepath/run/logevent.php";
	}
else
	{
		$runmsgtxt="You do not have DELETE ADMISSION privileges!";
		$_SESSION['runmsg']=$runmsgtxt;
	}
header ("Location: $rwareroot/admissions/dischargesummlist.php?show=outstanding&dedupe=yes");
?>