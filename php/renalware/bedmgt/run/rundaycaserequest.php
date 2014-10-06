<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//Tue Apr  3 14:49:19 CEST 2007 fixed for daycase only
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
//fix dates
$preopdate = fixDate($preopdate);
$suspenddate = fixDate($suspenddate);
$relisteddate = fixDate($relisteddate);
//fix infxn info
$infxnstatus = "MRSA: $MRSA";
if ( $otherinfxnflag=='yes' )
{
	$infxnstatus .= "; " . $infxnother;
}
$status = 'Req';
if ( $tcidate or $surgdate )
{
	$status='Sched';
}
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
$insertfields="pzid, surg_id, consultant_id, sched_uid, procedtype_id, hospno, modal, addstamp, modifstamp, listeddate, preopdate, preoptime, consultant, surgeon, priority, category, proced, mgtintent, surgdate, booker, surgslot, infxnstatus, infxnother, schednotes,  shortnotice, no_shortnotice, anaesth, status";
$values="$pzid, '$surg_id', '$consultant_id', $uid, '$procedtype_id', '$hospno', '$modal', NOW(), NOW(), '$listeddate', '$preopdate', '$preoptime', '$consultant', '$surgeon', '$priority', '$category', '$proced', '23h Ward Stay', '$surgdate', '$booker', '$surgslot', '$infxnstatus', '$infxnother', '$schednotes', '$shortnotice', '$no_shortnotice', '$anaesth', '$status'";
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
//log
$type="23h Ward Stay REQUESTED -- $proced for HospNo $hospno-- Priority $priority";
$eventtext=$mysqli->real_escape_string($values);
include( 'runlogevent.php' );
header ("Location: ../index.php?vw=proced&scr=view&pid=$pid");	
