<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$updatefields="consultmodifstamp=NOW()";
$omitfields=array('consult_id','consultzid');
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
			if (!in_array($key, $omitfields)) {
				$updatefields .= $value ? ", $key='".${$key}."'" : ", $key=NULL";
			}
}
//update the table
$tables = 'consultdata';
$where = "WHERE consult_id = $consult_id LIMIT 1";
$sql= "UPDATE $tables SET $updatefields $where";
$result = $mysqli->query($sql);
//log the event
$eventtype="Consult ID $consult_id updated";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
$runmsgtxt="Thank you. The consult details have been updated.";
$_SESSION['runmsg']=$runmsgtxt;
header ("Location: $rwareroot/ls/consultlist.php?list=userconsults");
