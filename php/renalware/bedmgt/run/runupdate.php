<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//Thu Mar  1 15:11:37 CET 2007
ob_start();
session_start();
$user=$_SESSION['user'];
$uid=$_SESSION['uid'];
require '/var/conns/bedmgtconn.php';
$mysqli->select_db("bedmgt");
include ('../incl/fxns.php');

foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
}
//fix dates
$tcidate = fixDate($tcidate);
$preopdate = fixDate($preopdate);
$suspenddate = fixDate($suspenddate);
$relisteddate = fixDate($relisteddate);

//get p'type
$sql="SELECT proced, category FROM procedtypes WHERE procedtype_id=$procedtype_id LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$proced=$row["proced"];
$category=$row["category"];

//get surg prn
if ($surg_id) {
	$sql="SELECT surgfirst, surglast FROM surgeons WHERE surg_id=$surg_id LIMIT 1";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$surgeon=$row["surgfirst"] . ' ' . strtoupper($row["surglast"]);
	}
//get prev slotdata to renew diarydates
//get existing slotdata BEFORE updating!
$fields="
surgdate,
surgslot
";
$sql="SELECT $fields FROM proceddata WHERE pid=$pid LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$exsurgdate=$row["surgdate"];
$exsurgslot=$row["surgslot"];
if ( $exsurgslot )
	{
	//"renew" the slot in diarydates
	//get availslot for date'
	$sql="SELECT availslots, dayno FROM diarydates WHERE diarydate='$exsurgdate' LIMIT 1";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$curravail=$row["availslots"];
	$dayno=$row["dayno"];
	//get replace position based dayno
	switch ($dayno) {
		case '2': //Mon
		$slotpos = array (
		'1' => '1',
		'2' => '2',
		'3' => '3',
		'E' => '4',
		);
			break;
		case '5': //Thu
		$slotpos = array (
		'1' => '1',
		'2' => '2',
		'3' => '3',
		'4' => '4',
		);
			break;
		case '6': //Fri
		$slotpos = array (
		'1' => '1',
		'2' => '2',
		'3' => '3',
		'4' => '4',
		'5' => '5',
		'6' => '6',
		'7' => '7',
		);
			break;
	}
	$replacepos=$slotpos[$exsurgslot];
	$newavail= substr_replace($curravail, $exsurgslot, $replacepos-1, 1);
	$updatefields = "availslots='$newavail', freeslots=freeslots+1, modifstamp=NOW()";
	$table = "diarydates";
	$sql="UPDATE $table SET $updatefields WHERE diarydate='$exsurgdate' LIMIT 1";
	$result = $mysqli->query($sql);
	}

//in case nothing else changes?
//flush desched surgdate/slot
if ( $debookdata )
	{
	$result = $mysqli->query($sql);
	$table = "proceddata";
	$sql="UPDATE $table SET surgdate=NULL, surgslot=NULL WHERE pid=$pid LIMIT 1";
	$result = $mysqli->query($sql);
	}
$updatefields = "
surg_id='$surg_id', 
sched_uid=$uid, 
procedtype_id=$procedtype_id, 
modifstamp=NOW(), 
tcidate='$tcidate', 
tcitime='$tcitime', 
preopdate='$preopdate', 
preoptime='$preoptime', 
consultant='$consultant', 
surgeon='$surgeon', 
priority='$priority', 
category='$category', 
proced='$proced', 
mgtintent='$mgtintent', 
surgdate='$surgdate', 
booker='$booker', 
surgslot='$surgslot', 
suspenddate='$suspenddate', 
relisteddate='$relisteddate', 
infxnstatus='$infxnstatus', 
schednotes='$schednotes', 
shortnotice='$shortnotice', 
no_shortnotice='$no_shortnotice', 
transportneed='$transportneed', 
transporttext='$transporttext', 
anaesth='$anaesth', 
opoutcome='$opoutcome', 
status='$status'";
$table = "proceddata";
$sql="UPDATE $table SET $updatefields WHERE pid=$pid LIMIT 1";
$result = $mysqli->query($sql);
//if surgslot remove from diarydates
if ( $surgslot )
{
	$sql="UPDATE diarydates SET availslots=REPLACE(availslots, '$surgslot', ' '), freeslots=freeslots-1, modifstamp=NOW() where diarydate='$surgdate' LIMIT 1";
	$result = $mysqli->query($sql);
}
//log
$type="Procedure UPDATED -- $proced for HospNo $hospno-- Priority $priority Status $status";
$eventtext=$mysqli->real_escape_string($values);
include( 'runlogevent.php' );
if ( !$_GET['debug'] )
{
	if ( $status=="Arch" )
	{
		//no letter
		header ("Location: ../index.php?vw=arch&scr=archlist");
	}
	else
	{
		header ("Location: ../index.php?vw=proced&scr=view&pid=$pid");	
	}	
}
