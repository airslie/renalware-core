<?php
//--Tue Sep 30 16:23:11 EDT 2014--
require 'req_fxnsconfig.php';
$insertfields="sharedcareuid, sharedcareuser";
$insertvalues="$sess_uid, '$sess_user'";
foreach ($_POST as $field => $value) {
  if ($value) {
      $fieldvalue=$mysqli->real_escape_string($value);
      ${$field} = (strtolower(substr($field,-4))=="date") ? fixDate($fieldvalue) : $fieldvalue;
      $insertfields .= ", $field";
      $insertvalues .= ", '${$field}'";  }
}
echo "INSERT FIELDS: $insertfields";
echo "INSERT VALS: $insertvalues";

$sql = "INSERT INTO sharedcaredata ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
$newsharedcare_id = $mysqli->insert_id;
//echo "TEST: $sql \n\n";
//flush previous currentflag prn
$sql = "UPDATE sharedcaredata SET currentflag=0 WHERE sharedcarezid=$sharedcarezid AND sharedcare_id != $newsharedcare_id";
$result = $mysqli->query($sql);
//echo "TEST: $sql \n\n";

$sql = "UPDATE patientdata SET lasteventstamp=NOW(),lasteventdate=CURDATE(),lasteventuser='$sess_user' WHERE patzid=$newzid LIMIT 1";
$result = $mysqli->query($sql);
//log the event
$eventtype="Shared Care form $newsharedcare_id added";
$eventtext=$newzid;
include "$rwarepath/run/logevent.php";
$_SESSION['successmsg']=$eventtype;

header ("Location: list_forms.php");
