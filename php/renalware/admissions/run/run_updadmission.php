<?php
//----Tue 19 Feb 2013----
//Wed Oct 14 13:06:32 CEST 2009
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$admid = $_POST["admid"];
$admdate = $mysqli->real_escape_string($_POST["admdate"]);
$admward = $mysqli->real_escape_string($_POST["admward"]);
$admmodal = $mysqli->real_escape_string($_POST["admmodal"]);
$consultant = $_POST["consultant"];
$admtype = $mysqli->real_escape_string($_POST["admtype"]);
$reason = $mysqli->real_escape_string($_POST["reason"]);
$transferflag = $_POST["transferflag"];
$deleteflag = $_POST["deleteflag"];
$transferward = $_POST["transferward"];
if ( $_POST["transferwardother"] )
	{
	$transferward = $mysqli->real_escape_string($_POST["transferwardother"]);
	}
$transferdate = $mysqli->real_escape_string($_POST["transferdate"]);
$dischdate = $mysqli->real_escape_string($_POST["dischdate"]);
$dischdest = $mysqli->real_escape_string($_POST["dischdest"]);
$transferdate = fixDate($transferdate);
$admdate = fixDate($admdate);
$dischdate = fixDate($dischdate);
$currward=$mysqli->real_escape_string($_POST["currward"]);
//update the table
$table = 'admissiondata';
$updatefields = "admdate='$admdate', admward='$admward', consultant='$consultant', admtype='$admtype', reason='$reason', dischdate='$dischdate', dischdest='$dischdest', currward='$currward', admmodal='$admmodal'";
if ($transferflag)
	{
	$updatefields = "admdate='$admdate', admward='$admward', consultant='$consultant', admtype='$admtype', reason='$reason', transferward='$transferward', transferdate='$transferdate', dischdate='$dischdate', dischdest='$dischdest', currward='$transferward', admmodal='$admmodal'";
	}
$where = "WHERE admission_id = $admid";
$sql= "UPDATE $table SET $updatefields, admmodifstamp=NOW() $where LIMIT 1";
$result = $mysqli->query($sql);
if (!$dischdate)
	{
	//"re-admit"
	$sql= "UPDATE admissiondata SET admittedflag=1 WHERE admission_id = $admid LIMIT 1";
	$result = $mysqli->query($sql);
	}
//log the event OR DELETE
$eventtype="Admission $admid Details updated";
$eventtext=$mysqli->real_escape_string($sql); //store sql!
include "$rwarepath/run/logevent.php";
header ("Location: $rwareroot/admissions/inpatientlist.php");
?>