<?php
//----Mon 25 Feb 2013----catheter fields, streamlining
foreach ($_POST as $key => $value) {
	$$key = (is_string($value)) ? $mysqli->real_escape_string($value) : $value ;
}
//append
$procedfull = $proced. ' ' . $procedtext;
$procedtrim=trim($procedfull);
$firstused_date = fixDate($firstused_date);
$failuredate = fixDate($failuredate);
$proceduredate = fixDate($proceduredate);
//add
$insertfields="accessproczid, proced, operator, firstflag, outcome, firstused_date, failuredate, proceduredate, addstamp, accessprocuser, cathetermake, catheterlotno";
$values="$zid, '$procedtrim', '$operator', '$firstflag', '$outcome', '$firstused_date', '$failuredate', '$proceduredate', NOW(), '$user', '$cathetermake','$catheterlotno'";
$table = "accessprocdata";
$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
//log the event
$eventtype="NEW Access Procedure: $proceduredate -- $proced = $operator";
include "$rwarepath/run/logevent.php";
showAlert("The Access Procedure for ' . $firstnames . ' ' . $lastname . ' has been recorded!");
