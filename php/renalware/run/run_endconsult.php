<?php
require '../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$zid=$get_zid;
$consult_id=$get_consult_id;
	$sql= "UPDATE consultdata SET consultmodifstamp=NOW(), activeflag='N', consultenddate=NOW() WHERE consult_id=$consult_id LIMIT 1";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="Consult No $consult_id COMPLETED";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	$runmsgtxt="Thank you. The consult has been marked COMPLETE.";
	$_SESSION['runmsg']=$runmsgtxt;
	header ("Location: $rwareroot/ls/consultlist.php?list=activelist");
?>