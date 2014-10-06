<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
foreach ($_POST as $key => $value) {
		${$key}=$mysqli->real_escape_string($value);
}
//get new data
//insert into the table
	$insertfields="user, pass, userlast, userfirst, consultantflag, editflag, authorflag, clinicflag, hdnurseflag, decryptflag, adddate, usertype, email, sitecode, dept, location, maintel, directtel, mobile, fax, inits, authorsig, position, userstamp, modifstamp, printflag, bedmanagerflag";
	$values="'$user', PASSWORD('$pass'), '$userlast', '$userfirst', '$consultantflag', '$editflag', '$authorflag', '$clinicflag', '$hdnurseflag', '$decryptflag', NOW(), '$usertype', '$email', '$sitecode', '$dept', '$location', '$maintel', '$directtel', '$mobile', '$fax', '$inits', '$authorsig', '$position', NOW(), NOW(), '$printflag', '$bedmanagerflag'";
	$sql= "INSERT INTO userdata ($insertfields) VALUES ($values)";
$result = $mysqli->query($sql);
//echo "<br>TEST: $sql <br>";
//log the event
	$eventtype="User $user ($userfirst $userlast) ADDED to system";
	$eventtext=$mysqli->real_escape_string($sql); //store sql!
	include "$rwarepath/run/logevent.php";
	header ("Location: $rwareroot/user/userlist.php");
	exit();
?>