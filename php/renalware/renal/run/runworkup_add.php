<?php
$debug = ($get_debug) ? TRUE : FALSE ;
//$debug=TRUE;
$insertfields="workupaddstamp, workupuser, workupzid";
$insertvalues="NOW(), '$user', '$zid'";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
		if (substr($key,-4)=="date")
			{
			${$key} = fixDate($value);
			}
		$insertfields .= $value ? ", $key" : "";
		$insertvalues .= $value ? ", '".${$key}."'" : "";
	}
	//INSERT  the table
	$table = 'renalware.capdworkups'; //****UPDATE
	$sql = "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
	runsql($sql, $debug);
	//log the event
//	$zid=$get_zid; //*****UPDATE
	$eventtype="Patient PD Workup created";
	$eventtext=$mysqli->real_escape_string($sql); //store change!
	include "$rwarepath/run/logevent.php";
	if (!$debug) {
		header ("Location: $rwareroot/renal/renal.php?scr=renalsumm&zid=$zid"); //****UPDATE
	}
?>