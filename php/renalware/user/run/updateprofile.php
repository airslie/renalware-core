<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
	$uid = $_POST['uid'];
	$newdept = $mysqli->real_escape_string($_POST['dept']);
	$newlocation = $mysqli->real_escape_string($_POST['location']);
	$newemail = $mysqli->real_escape_string($_POST['email']);
	$newmaintel = $mysqli->real_escape_string($_POST['maintel']);
	$newdirecttel = $mysqli->real_escape_string($_POST['directtel']);
	$newmobile = $mysqli->real_escape_string($_POST['mobile']);
	$newfax = $mysqli->real_escape_string($_POST['fax']);
	$newinits = $mysqli->real_escape_string($_POST['inits']);
	$newauthorsig = $mysqli->real_escape_string($_POST['authorsig']);
	$newposition = $mysqli->real_escape_string($_POST['position']);
	//update the table
	$tables = "userdata";
	$setfields = "dept = '$newdept', location = '$newlocation', email = '$newemail', maintel = '$newmaintel', directtel = '$newdirecttel', mobile = '$newmobile', fax = '$newfax', authorsig = '$newauthorsig', position = '$newposition', inits = '$newinits'";
	$where = "WHERE uid=$uid";
	$sql= "UPDATE $tables SET $setfields, modifstamp=NOW() $where";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="Account Details updated";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	$runmsgtxt="Thank you. The profile has been updated.";
	$_SESSION['runmsg']=$runmsgtxt;
	header ("Location: $rwareroot/user/userhome.php");
?>