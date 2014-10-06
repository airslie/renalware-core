<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$updatefields="txopmodifstamp=NOW()";
foreach ($_POST as $key => $value) {
	${$key}=$mysqli->real_escape_string($value);
	if (substr($key,-4)=="date")
		{
		${$key} = fixDate($value);
		}
	if (substr($key,-3)!="_id")
		{
		$updatefields .= $value ? ", $key='".${$key}."'" : ", $key=NULL";
		}
	}
//upd  the table
$table = 'renalware.txops';
$sql= "UPDATE $table SET $updatefields WHERE txop_id=$txop_id LIMIT 1";
$result = $mysqli->query($sql);
//log the event
$zid=$txopzid;
$eventtype="Patient Tx Op No $txop_id updated";
$eventtext=$mysqli->real_escape_string($sql); //store change!
include "$rwarepath/run/logevent.php";
header ("Location: $rwareroot/renal/txoplist.php");
