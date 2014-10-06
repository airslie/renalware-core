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
$pid = $_POST["pid"];
$pzid = $_POST["pzid"];
//only works if ONE chosen!:
$canceldate = $_POST["canceldate"];
$canceldate = fixDate($canceldate);
$schednotes = $mysqli->real_escape_string($_POST["schednotes"]);
$cancelreason = $mysqli->real_escape_string($_POST["cancelreason"]);
$status = 'Canc';
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
//process
$updatefields = "tcidate=NULL, tcitime=NULL, preopdate=NULL, preoptime=NULL, surgdate=NULL, surgslot=NULL, canceldate='$canceldate', cancelreason='$cancelreason', schednotes='$schednotes', status='$status', modifstamp=NOW()";
$table = "proceddata";
$sql="UPDATE $table SET $updatefields WHERE pid=$pid";
$result = $mysqli->query($sql);
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
		case '6': //Thu
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

//log
$eventzid=$pzid;
$type="Procedure ID $pid CANCELLED";
$eventtext=$cancelreason;
include( 'runcxevent.php' );
header ("Location: ../index.php?vw=req&scr=reqlist");
?>