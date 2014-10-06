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
$startday = $mysqli->real_escape_string($_POST["startday"]);
$endday = $mysqli->real_escape_string($_POST["endday"]);
$daynotes = $mysqli->real_escape_string($_POST["daynotes"]);
$daynotes=$daynotes . "\n";
$startdate= fixDate($startday);
$enddate= fixDate($endday);
if (!$endday )
{
	$enddate=$startdate;
}
$sql="UPDATE diarydates set modifstamp=NOW(), daynotes=CONCAT(IFNULL(daynotes,''),'$daynotes') WHERE diarydate BETWEEN '$startdate' AND '$enddate'";
$result = $mysqli->query($sql);
$pid='NULL';
$pzid='NULL';
$slot_id='NULL';
$type="Diary day notes ADDED -- $startday to $endday by $user";
$eventtext = $mysqli->real_escape_string($daynotes);
include( 'runlogevent.php' );
//header ("Location: ../index.php?vw=user&scr=systemguide");
header ("Location: ../index.php?vw=glance&scr=dayview&ymd=$startdate");
