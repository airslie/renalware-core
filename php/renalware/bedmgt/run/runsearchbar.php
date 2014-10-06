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
if ( $_GET['dmy'] )
	{
	$dmy=$_GET['dmy'];
	header ("Location: ../index.php?vw=glance&scr=dayview&dmy=$dmy");	
	}
if ($_GET['hospno'])
	{
	//get zid
	$hospno=strtoupper($_GET['hospno']);
	$sql="SELECT patzid FROM renalware.patientdata WHERE hospno1='$hospno' LIMIT 1";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$numfound=$result->num_rows;
	if ( !$numfound )
		{
		echo "Sorry $hospno could not be located. Please try again.<br>";
		}
	else
		{
		$zid=$row["patzid"];
		header ("Location: ../index.php?vw=pat&scr=patview&zid=$zid");	
		}
	}
if ($_GET['lastname'])
	{
	$lastname=htmlentities($_GET['lastname']);
	header ("Location: ../index.php?vw=pat&scr=patientlist&lastname=$lastname");	
	}
?>