<?php
//----Thu 02 Feb 2012----
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
}
	//add to tcilists
$insertfields="
	tcilistuid,
	tcilistuser,
	tcilistzid,
	tcilistmodal,
	tcilistadddate,
	tcireason,
	tcipriority,
	patlocation,
	tcinotes";
	$insertvalues="$uid,'$user',$tcilistzid, '$tcilistmodal', CURDATE(),'$tcireason','$tcipriority','$patlocation','$tcinotes'";
if ($get_tciconsult_id) {
	$tciconsult_id=(int)$get_tciconsult_id;
	$insertfields.=",tciconsult_id";
	$insertvalues.=",$tciconsult_id";
}
	$table = "renalware.tcilistdata";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	$result = $mysqli->query($sql);
	//log the event
	$zid=$tcilistzid;
	$eventtype="NEW TCI LIST PATIENT: $tcipriority -- $patlocation";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	header ("Location: $rwareroot/ls/tcilist.php");	
?>