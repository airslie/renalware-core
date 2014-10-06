<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$updatefields="modifstamp=NOW()";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
			//omit uid if passed
			if ($key!="uid") {
				$updatefields .= $value !='' ? ", $key='".${$key}."'" : ", $key=NULL";
			}
}
//update the table
$tables = 'userdata u';
$where = "WHERE uid = $uid LIMIT 1";
$sql= "UPDATE $tables SET $updatefields $where";
$result = $mysqli->query($sql);
//log the event
$eventtype="User Details updated";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
$runmsgtxt="Thank you. The user details have been updated.";
$_SESSION['runmsg']=$runmsgtxt;
header ("Location: $rwareroot/user/userlist.php");
?>