<?php
//refined Wed Aug  6 18:04:45 CEST 2008
//assumes $eventtype is set
//archives and also InnoDB logs for easy searching/display
$ip_addr=$_SERVER['REMOTE_ADDR'];
$user=$_SESSION['user'];
$sessionid = $_SESSION['sessionid'];
//$type = ($eventtype) ? $eventtype : "UNSPECIFIED EVENT" ;

$archivefields="eventstamp, user, uid, session_id, type, notes, eventtext";
$archivevalues="NOW(),'$user', $uid, $sessionid, '$eventtype','$notes', '$eventtext'";
$logfields="session_id,session_ipn,event_uid,eventuser,type";
$logvalues="$sessionid,INET_ATON('$ip_addr'),$uid,'$user','$eventtype'";
//if patient
if($zid)
	{
	$archivefields .= ", eventzid";
	$archivevalues .= ", $zid";
	$logfields .= ", eventzid";
	$logvalues .= ", $zid";
	$sql= "UPDATE renalware.patientdata SET lasteventstamp=NOW(),lasteventuser='$user', lasteventdate=NOW() WHERE patzid=$zid LIMIT 1";
	$result = $mysqli->query($sql);
 	}
//update archives
//$sql = "INSERT INTO renalware.eventarchives ($archivefields) VALUES ($archivevalues)";
//$result = $mysqli->query($sql);
 //update logs
$sql = "INSERT INTO renalware.eventlogs ($logfields) VALUES ($logvalues)";
$result = $mysqli->query($sql);
//update users
$sql = "UPDATE renalware.users SET lasteventstamp=NOW() WHERE uid=$uid LIMIT 1";
$result = $mysqli->query($sql);
 //update sessions
$sql = "UPDATE renalware.renalsessions SET lasteventtime = NOW() WHERE session_id=$sessionid LIMIT 1";
$result = $mysqli->query($sql);
?>