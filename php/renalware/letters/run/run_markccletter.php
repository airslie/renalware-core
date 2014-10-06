<?php
//Fri Jul 25 16:17:37 BRT 2008 . Mon Aug  4 13:45:15 CEST 2008
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
foreach ($_POST as $key => $value) {
	$$key = (is_string($value)) ? $mysqli->real_escape_string($value) : $value ;
}
$eventzid=$letterzid;
	if ($readstatus=="read" && $confirmread=="y")
		{
		$sql= "UPDATE letterccdata SET ccstatus='read', readstamp=NOW() WHERE lettercc_id=$lettercc_id";
		$result = $mysqli->query($sql);
			$eventtype="Letter CC # $letter_id read by $readeruser";
			include "$rwarepath/run/logevent.php";
		$runmsgtxt="Thank you. The letter has been marked READ.";
		if ($responseflag=='y') {
			//send msg
			$messagesubj = $mysqli->real_escape_string($_POST["responsesubj"]);
			$messagetext = $mysqli->real_escape_string($_POST["responsetext"]);
				$insertfields="message_uid, messageuser, recip_uid,messagezid,messagesubj,messagetext,urgentflag";
				$insertvalues="$reader_id, '$readeruser',$author_id,$letterzid,'$messagesubj','$messagetext','$urgentflag'";
				$sql = "INSERT INTO messagedata ($insertfields) VALUES ($insertvalues)";
				$mysqli->query($sql);
			$runmsgtxt.=" Your message re: $messagesubj has been sent.";
			//log the event
			$eventtype="Letter CC # $letter_id responded to by $readeruser";
			include "$rwarepath/run/logevent.php";	
		}
		$_SESSION['runmsg']=$runmsgtxt;
		header("Location: $rwareroot/user/userhome.php");
		}
	else
		{ // left UNREAD.
		header("Location: $rwareroot/user/userhome.php");
		}
?>