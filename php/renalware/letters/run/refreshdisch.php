<?php
//only a few fields can be updated:
$recipient = $mysqli->real_escape_string($_POST["recipient"]);
$authorid = $_POST["authorid"];
$admissionid = $_POST["admissionid"];
$salut = $mysqli->real_escape_string($_POST["salut"]);
$lettresults = $mysqli->real_escape_string($_POST["lettresults"]);
$ltext = $mysqli->real_escape_string($_POST["ltext"]);
$lettertype = $_POST["lettertype"];
$cctext = $mysqli->real_escape_string($_POST["cctext"]);
$reason = $mysqli->real_escape_string($_POST["reason"]);
$deathcause = $mysqli->real_escape_string($_POST["deathcause"]);
$elecsigflag = $_POST["elecsigflag"];
$lettertype_id = 1;
//get disch/death letterdescr
if ( $lettertype=="discharge" )
	{
	$lettdescr = "DISCHARGE SUMMARY";
	}
if ( $lettertype=="death" )
	{
	$lettdescr = "DEATH NOTIFICATION";
	$elecsigflag =false;
	}
	//refresh Author data... sigh
//try here for global use
//author... sigh
$authorid = $_POST["authorid"];
$sql= "SELECT userlast, userfirst, inits, authorsig, position FROM userdata WHERE uid=$authorid";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$authorlastfirst=$mysqli->real_escape_string($row["userlast"]) . ', ' . $mysqli->real_escape_string($row["userfirst"]);
$authorsig=$mysqli->real_escape_string($row["authorsig"]);
$position=$mysqli->real_escape_string($row["position"]);
	$_SESSION['authorid'] = $authorid;
	$_SESSION['authorlastfirst'] = $authorlastfirst;
//parse out recipname in case changed
$endfirstline=strpos($recipient, '\r\n');
$recipname=substr($recipient, 0, $endfirstline);
//refresh probs, meds
$lettproblems=$mysqli->real_escape_string($problist);
$lettmeds=$mysqli->real_escape_string($medlist);
//handle all CCs
include "$rwarepath/letters/incl/handleccs_incl.php";
//set update fields
$updatefields = "lettmodifstamp=NOW(), letterdate=NOW(), status='$status', archiveflag='$archiveflag', salut='$salut', lettdescr='$lettdescr', cctext='$cctext', recipname='$recipname', recipient='$recipient', authorid=$authorid, authorlastfirst='$authorlastfirst',  authorsig='$authorsig', position='$position', lettresults='$lettresults', reason='$reason', deathcause='$deathcause', lettproblems='$lettproblems', lettmeds='$lettmeds'";
$sql= "UPDATE letterdata SET $updatefields WHERE letter_id=$letter_id LIMIT 1";
$result = $mysqli->query($sql);
//update ltext
$updatefields = "lettertextuid=$uid, modifstamp=NOW(), ltext='$ltext'";
$sql= "UPDATE lettertextdata SET $updatefields WHERE lettertext_id=$letter_id LIMIT 1";
$result = $mysqli->query($sql);

//update admission prn
$dischstatus="Doc ID $letter_id ($status) by $authorsig";
$sql= "UPDATE admissiondata SET dischsummstatus='$dischstatus'  WHERE admission_id=$admissionid LIMIT 1";
$result = $mysqli->query($sql);
?>