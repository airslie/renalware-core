<?php
//Wed Nov 21 13:02:43 CET 2007
if($pagelogging==1) {
$uri = $_SERVER['REQUEST_URI'];
$page_title = $page;
//$page_title = $mysqli->real_escape_string($page);
$sql= "INSERT INTO renalware.pageviews (pagestamp, user, page_uid, session_id, page_uri, page_title) VALUES (NOW(), '$user', $uid, $sessionid, '$uri','$page_title')";
if (isset($_GET['zid'])) {
	//only if zid from GET
	$pagezid=$_GET['zid'];
	$sql= "INSERT INTO renalware.pageviews (pagestamp, user, page_uid, session_id, page_uri, pagezid, page_title) VALUES (NOW(), '$user', $uid, $sessionid, '$uri', $pagezid, '$page_title')";
}
$result = $mysqli->query($sql);
//update users
$sql= "UPDATE renalware.users SET lasteventstamp=NOW() WHERE uid=$uid LIMIT 1";
$result = $mysqli->query($sql);
//update sessions
$sql= "UPDATE renalware.renalsessions SET lasteventtime = NOW() WHERE session_id='$sessionid' LIMIT 1";
$result = $mysqli->query($sql);
}
?>