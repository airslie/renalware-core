<?php
//Mon May 11 16:48:53 BST 2009
require 'config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
//log the event
	$eventtype="logout";
	$user=$_SESSION['user'];
	$uid=$_SESSION['uid'];
	$sessionid = $_SESSION['sessionid'];
include 'run/logevent.php';
//reset session
session_start();
//update user status
$sql= "UPDATE users SET modifstamp=NOW(), logged_inflag=0 WHERE uid =$uid LIMIT 1";
$result = $mysqli->query($sql);
//update session record
$sql= "UPDATE renalware.renalsessions SET endtime=NOW(), activeflag=0 WHERE session_id =$sessionid LIMIT 1";
$result = $mysqli->query($sql);
$_SESSION = array();
session_start();
session_unset(); 
setcookie (session_name(), '', (time() - 300), '/', '', 0); 
session_destroy();
header ("Location: login.php");
?>