<?php
$letter_id = $_POST['letter_id'];
//even though deleted we will store in EVENTS
//first get existing data:
include "$rwarepath/letters/data/letterdata.php";
//then override with anything entered
//in case anything has been entered
//2011-12-18
foreach ($_POST as $key => $value) {
	$$key = (is_string($value)) ? $mysqli->real_escape_string($value) : $value ;
}
//compile the whole letter for storage before deletion
include ('incl/compiletext.php');
$letterfulltext=$mysqli->real_escape_string($letterfulltext);
//delete from letterdata
$sql= "DELETE FROM letterdata WHERE letter_id=$letter_id LIMIT 1";
$result = $mysqli->query($sql);
//delete from lettertextdata
//no let's not... just mark as DELETED
$sql= "UPDATE lettertextdata set lettertextuid=$uid, deletestamp=NOW(), deleteflag=1 WHERE lettertext_id=$letter_id LIMIT 1";
$result = $mysqli->query($sql);
//log the event w/ deleted fulltext
	$eventtype="DRAFT DELETED $lettdescr [ID $letter_id] by UID $uid AUTHOR $authorsig";
	$eventtext=$letterfulltext;
	include "$rwarepath/run/logevent.php";
//Mon Aug  4 13:51:21 CEST 2008
//delete letter CCs
$sql = "DELETE FROM letterccdata WHERE ccletter_id=$letter_id";
$result = $mysqli->query($sql);
?>