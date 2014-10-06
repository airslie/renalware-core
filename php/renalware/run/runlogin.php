<?php
//Tue Nov 27 10:25:38 CET 2007 changed login error report to hide pw
ob_start();
require '../config_incl.php';
include '/var/conns/renalwareconn.php';
include '../fxns/fxns.php';
$screentype = ($_POST['narrowscreen']=="yes") ? "narrow" : "wide" ;
$message = NULL;
if (empty($_POST["user"]))
	{
		$u = FALSE;
	}
	else
	{
		$u = $_POST["user"];
	}
if (empty($_POST["pass"]))
	{
	$p = FALSE;
	}
	else
	{
	$p = $_POST["pass"];
	}
if ($u && $p)
	{
	$sql = "SELECT uid, user, adminflag, decryptflag, editflag, printflag, bedmanagerflag,wardclerkflag, authorflag,pathflag, sitecode, passmodifstamp, DATEDIFF(NOW(),passmodifstamp) as passwordage,newpwflag from userdata where user='$u' AND pass=PASSWORD('$p') LIMIT 1";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	if ($row)
		{
		session_start();
		$_SESSION['user'] = $row["user"];
		$_SESSION['uid'] = $row["uid"];
		$_SESSION['adminflag'] = $row["adminflag"];
		$_SESSION['decryptflag'] = $row["decryptflag"];
		$_SESSION['editflag'] = $row["editflag"];
		$_SESSION['starttime'] = time();
		$_SESSION['feedbackflag'] = $feedbackflag;
		$_SESSION['printflag'] = $row["printflag"];
		$_SESSION['authorflag'] = $row["authorflag"];
		$_SESSION['pathflag'] = $row["pathflag"];
		$_SESSION['bedmgrflag'] = $row["bedmanagerflag"];
		$_SESSION['wardclerkflag'] = $row["wardclerkflag"];
		$_SESSION['sitecode'] = $row["sitecode"];
		$_SESSION['screentype'] = $screentype;
		$starttime = $_SESSION['starttime'];
		$_SESSION['lasteventtime']=time();
		$uid = $row["uid"];
		$user=$row["user"];
		$passmodifstamp=$row["passmodifstamp"];
		$ip_addr=$_SERVER['REMOTE_ADDR'];
		$agent = $_SERVER['HTTP_USER_AGENT'];
		//terminate any sessions not logged-out
		$sql = "UPDATE renalware.renalsessions SET endtime=NOW(), activeflag=0 WHERE sessuid=$uid AND activeflag=1";
		$result = $mysqli->query($sql);
		//log the session & get session ID
		$sql = "INSERT INTO renalware.renalsessions (starttime, sessuser, sessuid, user_ipaddr,agent) VALUES (NOW(),'$user', $uid, '$ip_addr', '$agent')";
		$result = $mysqli->query($sql);
		$_SESSION['sessionid'] = $mysqli->insert_id;
		//log the event
		$sessionid=$_SESSION['sessionid'];
		$eventtype="login";
		include "$rwarepath/run/logevent.php";
		//end logging
		//update user status
		$sql = "UPDATE userdata SET modifstamp=NOW(), logged_inflag=1, lastloginstamp = NOW() WHERE uid = $uid";
		$result = $mysqli->query($sql);
		ob_end_clean();
//		echo "<br>TEST: $sql <br>";
		//if pass has not been changed-- NB $pwexpiredays set in config.php
		if ($p=='password' or !$passmodifstamp or $row["passwordage"]>$pwexpiredays or $row["newpwflag"]=='1')
			{
			header("Location: $rwareroot/user/changepw.php");
			}
			else
			{
			header("Location: $rwareroot/user/userhome.php");
			}
		exit();
		}
	else
		{
		session_start();
		$runmsgtxt="The user and password do not match those on file. Try again.";
		$_SESSION['loginerror']=$runmsgtxt;
		header ("Location: $rwareroot/relogin.php");
		}
	}
	else
	{
		session_start();
		$runmsgtxt="Something went awry. Please try again.";
		$_SESSION['loginerror']=$runmsgtxt;
		header ("Location: relogin.php");
	}
?>tt