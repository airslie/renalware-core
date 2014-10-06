<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
ob_start();
session_start();
$user=$_SESSION['user'];;
$uid=$_SESSION['uid'];
require '/var/conns/bedmgtconn.php';
$mysqli->select_db("bedmgt");
include ('../incl/fxns.php');
//process SUBMIT -- NB first add
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
}
//extras
//fix dates
$tcidate = fixDate($tcidate);
$preopdate = fixDate($preopdate);
$suspenddate = fixDate($suspenddate);
$relisteddate = fixDate($relisteddate);
$listeddate = fixDate($listeddate);

//fix infxn info
$infxnstatus = "MRSA: $MRSA";
if ( $otherinfxnflag=='yes' )
{
	$infxnstatus .= "; " . $infxnother;
}
$status = ($tcidate or $surgdate) ? 'Sched' : 'Req';
//process
//get op
$sql="SELECT proced, category FROM procedtypes WHERE procedtype_id=$procedtype_id";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$proced=$row["proced"];
$category=$row["category"];

if ( $surg_id )
	{
	//get
	$sql="SELECT surgfirst, surglast FROM surgeons WHERE surg_id=$surg_id";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$surgeon=$row["surgfirst"] . ' ' . strtoupper($row["surglast"]);
	}
if ( $consultant_id )
	{
	//get
	$sql="SELECT authorsig FROM renalware.userdata WHERE uid=$consultant_id";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$consultant=$row["authorsig"];
	}
$insertfields="pzid, surg_id, consultant_id, sched_uid, procedtype_id, hospno, modal, addstamp, modifstamp, listeddate, tcidate, tcitime, preopdate, preoptime, consultant, surgeon, priority, category, proced, mgtintent, surgdate, booker, surgslot, infxnstatus, infxnother, schednotes, shortnotice, no_shortnotice, anaesth, status, transportneed, transporttext";
$values="$pzid, '$surg_id', '$consultant_id', $uid, '$procedtype_id', '$hospno', '$modal', NOW(), NOW(), '$listeddate', '$tcidate', '$tcitime', '$preopdate', '$preoptime', '$consultant', '$surgeon', '$priority', '$category', '$proced', '$mgtintent', '$surgdate', '$booker', '$surgslot', '$infxnstatus', '$infxnother', '$schednotes', '$shortnotice', '$no_shortnotice','$anaesth', '$status', '$transportneed', '$transporttext'";
$table = "proceddata";
$sql="INSERT INTO $table ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
//get new pid
$pid=$mysqli->insert_id;
//if surgslot remove from diarydates
if ( $surgslot )
{
	$sql="UPDATE diarydates SET availslots=REPLACE(availslots, '$surgslot', ' '), freeslots=freeslots-1, modifstamp=NOW() where diarydate='$surgdate'";
	$result = $mysqli->query($sql);
}
if ($tcilist_id) {
	//----Tue 07 Feb 2012----update TCI list
	$sql="UPDATE renalware.tcilistdata SET tciproced_id=$pid WHERE tcilist_id=$tcilist_id";
	$result = $mysqli->query($sql);
	
}

//log
$type="Procedure REQUESTED -- $proced for HospNo $hospno-- Priority $priority";
$eventtext=$mysqli->real_escape_string($values);
include( 'runlogevent.php' );
	header ("Location: ../index.php?vw=proced&scr=view&pid=$pid");	
?>