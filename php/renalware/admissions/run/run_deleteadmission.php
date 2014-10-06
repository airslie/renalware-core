<?php
//Wed Nov 18 12:58:16 CET 2009 fix for multiple EPR inserts
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$admid = $_POST["admid"];
$deleteflag = $_POST["deleteflag"];
$admstatus = $_POST["admstatus"];
if ( $deleteflag=='yes')
	{
		$table = 'admissiondata';
		$where = "WHERE admission_id = $admid";
		$sql= "UPDATE $table SET admstatus='$admstatus',admdate=NULL,dischdate=NULL,admdays=0,admittedflag=0, admmodifstamp=NOW(),dischsummstatus='Unnecess: Adm $admstatus',dischsummflag=1 $where LIMIT 1";
		$result = $mysqli->query($sql);
	$eventtype="Admission $admid $admstatus";
	$eventtext=$mysqli->real_escape_string($sql); //store sql!
	include "$rwarepath/run/logevent.php";
	}
else
	{
		$runmsgtxt="You did not confirm the DELETE ADMISSION checkbox!";
		$_SESSION['runmsg']=$runmsgtxt;
	}
header ("Location: $rwareroot/admissions/inpatientlist.php");
?>