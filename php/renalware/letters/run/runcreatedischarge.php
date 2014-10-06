<?php
//----Sun 28 Oct 2012----cctext fix
//Wed Oct 14 13:06:32 CEST 2009
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$zid = $_POST['zid'];
include "$rwarepath/letters/data/letterpatdata.php";
include "$rwarepath/letters/data/letterpatholdata.php";
include "$rwarepath/data/currentclindata.php";
include "$rwarepath/data/probs_meds.php";
$lettertype = $_POST["lettertype"];
$lettertype_id=1;
$letterdate = $mysqli->real_escape_string($_POST["letterdate"]);
$letterdate = fixDate($letterdate);
$ltext = $mysqli->real_escape_string($_POST["ltext"]);
//author data
$authorid = $_POST["authorid"];
$sql= "SELECT userlast, userfirst, inits, authorsig, position FROM userdata WHERE uid=$authorid";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
	$authorlastfirst=$mysqli->real_escape_string($row["userlast"]) . ', ' . $mysqli->real_escape_string($row["userfirst"]);
	$authorsig=$mysqli->real_escape_string($row["authorsig"]);
	$position=$mysqli->real_escape_string($row["position"]);
//typist==user
$typistid = $uid;
$sql= "SELECT inits FROM userdata WHERE uid=$uid";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$typistinits=$row["inits"];
$recipient = $mysqli->real_escape_string($_POST["gpreciptext"]);
//parse out recipname
$endfirstline=strpos($recipient, '\r\n');
$recipname=substr($recipient, 0, $endfirstline);
$templateflag = $_POST["templateflag"];
if ($templateflag=="y") {
	$templateid = $_POST["templateid"];
	$sql= "SELECT templatetext FROM lettertemplates WHERE template_id=$templateid";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$template= $row["templatetext"];
	$ltext = $mysqli->real_escape_string($template);
}
//refresh:
include "$rwarepath/data/probs_meds.php";
//next INSERT into LETTERS...
//fix template etc prn
$lettallergies=$mysqli->real_escape_string($allergies);
$problist=$mysqli->real_escape_string($problist);
$medlist=$mysqli->real_escape_string($medlist);
$pataddrhoriz=$mysqli->real_escape_string($pataddrhoriz);
$patref = $mysqli->real_escape_string($patref);
$patlastfirst = $mysqli->real_escape_string($patlastfirst);
//get adm data
$admid = $_POST["admid"];
$fields = "admdate, admward, consultant, admtype, dischdate, dischdest";
$table = "admissiondata";
$where = "WHERE admission_id=$admid";
$sql= "SELECT $fields FROM $table $where LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
	$admdate=$row["admdate"];
	$admward=$row["admward"];
	$admconsultant=$row["consultant"];
	$admtype=$row["admtype"];
	$dischdate=$row["dischdate"];
	$dischdest=$row["dischdest"];
$reason = $mysqli->real_escape_string($_POST["reason"]);
$deathcause = $mysqli->real_escape_string($_POST["deathcause"]);
//default is clinical NO now always discharge
switch($lettertype) {
	case "discharge":
	//----Tue 06 Mar 2012----for pat CC
	$cctext="";
	if ($ccflag=='Y') {
		$cctext = "\n\n\nPRIVATE AND CONFIDENTIAL\n\n" . $patblock . "\n\n\n\n\n";
	}
	$cctext = $mysqli->real_escape_string($cctext);
	$insertfields = "letterzid, letthospno, lettuid, lettuser, lettaddstamp, lettmodifstamp, modalstamp, authorid, typistid, typistinits, letterdate, lettertype, lettertype_id, status, lettdescr, patlastfirst, authorlastfirst, authorsig, position,  recipname, recipient, patref, pataddr, lettproblems, lettmeds, lettresults, lettallergies, admissionid, admdate, admward, dischdate, dischdest, admconsultant, reason,cctext";
	$values="$zid, '$hospno1', $uid, '$user', NOW(), NOW(), '$modalcode', '$authorid', '$typistid', '$typistinits', '$letterdate', '$lettertype', $lettertype_id, 'DRAFT', 'DISCHARGE SUMMARY', '$patlastfirst', '$authorlastfirst', '$authorsig', '$position',  '$recipname', '$recipient', '$patref', '$pataddrhoriz', '$problist', '$medlist', '$current_lettresults', '$lettallergies', $admid,  '$admdate', '$admward', '$dischdate', '$dischdest', '$admconsultant', '$reason','$cctext'";
	break;
	case "death":
	$insertfields = "letterzid, letthospno, lettuid, lettuser, lettaddstamp, lettmodifstamp, modalstamp, authorid, typistid, typistinits, letterdate, lettertype, lettertype_id, status, lettdescr, patlastfirst, authorlastfirst, authorsig, position,  recipname, recipient, patref, pataddr, lettproblems, lettresults, lettallergies, admissionid, admdate, admward, dischdate, admconsultant, reason, deathcause";
	$values="$zid, '$hospno1', $uid, '$user', NOW(), NOW(), '$modalcode', '$authorid', '$typistid', '$typistinits', '$letterdate', '$lettertype', $lettertype_id, 'DRAFT', 'DEATH NOTIFICATION', '$patlastfirst', '$authorlastfirst', '$authorsig', '$position',  '$recipname', '$recipient', '$patref', '$pataddrhoriz', '$problist', '$current_lettresults', '$lettallergies', $admid, '$admdate', '$admward', '$dischdate', '$admconsultant', '$reason', '$deathcause'";
	break;
	}
$sql= "INSERT INTO letterdata ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
$letter_id = $mysqli->insert_id;
//add to ltext
$sql= "INSERT INTO lettertextdata (lettertext_id, lettertextuid, lettertextzid, addstamp, modifstamp, ltext) VALUES ($letter_id, $uid, $zid, NOW(), NOW(), '$ltext')";
$result = $mysqli->query($sql);
//log the create w/ fulltext
$eventtype="CREATED $lettdescr [ID $letter_id] by $authorsig";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
header ("Location: $rwareroot/letters/editletter.php?zid=$zid&letter_id=$letter_id&stage=created");
