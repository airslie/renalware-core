<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$recipuidsarray=$_POST['recipuids'];
$messagesubj = $mysqli->real_escape_string($_POST["messagesubj"]);
$messagetext = $mysqli->real_escape_string($_POST["messagetext"]);
$uidlist="";
foreach ($recipuidsarray as $key => $recip_uid) {
	$insertfields="message_uid, messageuser, recip_uid,messagezid,messagesubj,messagetext,urgentflag";
	$insertvalues="$post_message_uid, '$post_messageuser',$recip_uid,$post_messagezid,'$messagesubj','$messagetext','$post_urgentflag'";
	$sql = "INSERT INTO renalware.messagedata ($insertfields) VALUES ($insertvalues)";
	$mysqli->query($sql);
	$uidlist.="$recip_uid ";
}
$runmsgtxt="Your message re: $messagesubj has been sent.";
$_SESSION['runmsg']=$runmsgtxt;
//log the event
	$eventtype="$messagesubj sent by UID $uid to UIDs $uidlist";
	$eventtext=$messagetext;
	include "$rwarepath/run/logevent.php";
?>