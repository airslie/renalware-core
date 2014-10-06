<?php
//----Thu 02 Feb 2012----
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$updatefields="tcilistmodifstamp=NOW()";
$omitfields=array('tcilist_id','tcilistzid');
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
//remove any w/ existing rank
if ($tcilistrank) {
	$sql = "UPDATE tcilistdata SET tcilistrank=NULL WHERE tcilistrank=$tcilistrank";
	$result = $mysqli->query($sql);
}
//update the table
$tables = 'tcilistdata';
$where = "WHERE tcilist_id = $tcilist_id LIMIT 1";
$sql= "UPDATE $tables SET $updatefields $where";
$result = $mysqli->query($sql);
//log the event
$eventtype="TCI LIST ID $tcilist_id updated";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
$runmsgtxt="Thank you. The TCI List patient record has been updated.";
$_SESSION['runmsg']=$runmsgtxt;
header ("Location: $rwareroot/ls/tcilist.php?list=usertcilist");
?>