<?php
//--Sun Dec 29 16:56:23 EST 2013--
require 'req_fxnsconfig.php';
$newzid=(int)$get_newzid;
$sql = "INSERT INTO akidata (akiuid,akiuser,akizid,akiadddate,episodestatus) VALUES ($sess_uid, '$sess_user',$newzid,CURDATE(),'Suspected')";
$result = $mysqli->query($sql);
$newaki_id = $mysqli->insert_id;
$sql = "UPDATE renaldata SET akiflag='Y',renalmodifstamp=NOW() WHERE renalzid=$newzid LIMIT 1";
$result = $mysqli->query($sql);
$sql = "UPDATE patientdata SET lasteventstamp=NOW(),lasteventdate=CURDATE(),lasteventuser='$sess_user' WHERE patzid=$newzid LIMIT 1";
$result = $mysqli->query($sql);
//log the event
$eventtype="AKI episode $newaki_id added";
$eventtext=$newzid;
include "$rwarepath/run/logevent.php";
$_SESSION['successmsg']=$eventtype;
header ("Location: upd_episode.php?zid=$newzid&id=$newaki_id");
