<?php
//set logout time in mins
$autologoutmins=30;
ob_start();
session_start();
//now look for login
if (!isset($_SESSION['user']))
	{
	header ("Location: ../");
	ob_end_clean();
	exit();
	}
//now look for "expired" session
$autologoutsecs=$autologoutmins*60;
$lastevent=$_SESSION['lasteventtime'];
$time_elapsed=time()-$lastevent;
//reset lasteventtime
$_SESSION['lasteventtime']=time();
//otherwise OK
$user=$_SESSION['user'];
$uid=$_SESSION['uid'];
$adminflag=$_SESSION['adminflag'];
$printflag=$_SESSION['printflag'];
$decryptflag=$_SESSION['decryptflag'];
$wardclerkflag=$_SESSION['wardclerkflag'];
$editflag=$_SESSION['editflag'];
$starttime=$_SESSION['starttime'];
$screentype=$_SESSION['screentype'];
$sessionid = $_SESSION['sessionid'];
//may override global?
$feedbackflag=$_SESSION['feedbackflag'];
$duration= time() - $starttime;
$mins = floor($duration/60);
$sql= "UPDATE renalware.userdata SET lasteventstamp=NOW() WHERE uid=$uid LIMIT 1";
$result = $mysqli->query($sql);
//flush aged logins and sessions
$sql= "UPDATE userdata SET logged_inflag=0 WHERE (NOW()-lasteventstamp)/60>100";
$result = $mysqli->query($sql);
?>