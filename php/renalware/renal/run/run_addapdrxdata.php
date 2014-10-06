<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$debug = ($get_debug) ? TRUE : FALSE ;
$mysqli = new mysqli($host, $dbuser, $pass, $db);
$insertfields="addstamp, adduser, adduid";
$insertvalues="NOW(), '$user', '$uid'";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
			$insertfields .= $value ? ", $key" : "";
			$insertvalues .= $value ? ", '".${$key}."'" : "";
	}
	//upd  the table
	$table = 'renalware.apdrxdata'; //****UPDATE
	$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	runsql($sql, $debug);
	//log the event
	$zid=$apdrxzid; //*****UPDATE
	$eventtype="Patient APD Treatment Data added";
	$eventtext=$mysqli->real_escape_string($sql); //store change!
	include "$rwarepath/run/logevent.php";
	if (!$debug) {
		header ("Location: $rwareroot/renal/renal.php?scr=pd&zid=$zid"); //****UPDATE
	}
?>