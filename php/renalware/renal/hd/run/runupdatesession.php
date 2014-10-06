<?php
//----Sat 15 Feb 2014----update avg BPs
//to update an HD session Wed Sep 10 17:38:05 BST 2008 HDF
$hdsessionid=$_GET['updatesess'];
$timeoff = $mysqli->real_escape_string($_POST["timeoff"]);
$wt_post = $mysqli->real_escape_string($_POST["wt_post"]);
$pulse_post = $mysqli->real_escape_string($_POST["pulse_post"]);
$BM_post = $mysqli->real_escape_string($_POST["BM_post"]);
$temp_post = $mysqli->real_escape_string($_POST["temp_post"]);
$BPpost = $mysqli->real_escape_string($_POST["BPpost"]);
$bppost = explode("/", $BPpost);
$systpost = $bppost[0];
$diastpost = $bppost[1];
$litresproc = $mysqli->real_escape_string($_POST["litresproc"]);
$signoff = $mysqli->real_escape_string($_POST["signoff"]);
$evaluation = $mysqli->real_escape_string($_POST["evaluation"]);
$updatefields = "timeoff='$timeoff', wt_post='$wt_post', pulse_post='$pulse_post', BM_post='$BM_post', temp_post='$temp_post', litresproc='$litresproc', signoff='$signoff', evaluation='$evaluation', submitflag=1, syst_post='$systpost', diast_post='$diastpost', weightchange=$wt_post-wt_pre";
if ($hdfflag) {
	$subsfluidpct = $mysqli->real_escape_string($_POST["subsfluidpct"]);
	$subsvol = $mysqli->real_escape_string($_POST["subsvol"]);
	$subsrate = $mysqli->real_escape_string($_POST["subsrate"]);
	$subsgoal = $mysqli->real_escape_string($_POST["subsgoal"]);
	$updatefields .=", subsfluidpct=$subsfluidpct, subsvol=$subsvol,subsrate=$subsrate,subsgoal=$subsgoal";
}
$sql= "UPDATE hdsessiondata SET $updatefields, hdsessmodifstamp=NOW() WHERE hdsession_id=$hdsessionid";
$result = $mysqli->query($sql);
//----Sat 15 Feb 2014----update prn with updated vals
$sql= "SELECT ROUND(AVG(syst_pre),0) as avgsyst_pre, ROUND(AVG(diast_pre),0) as avgdiast_pre, ROUND(AVG(syst_post),0) as avgsyst_post, ROUND(AVG(diast_post),0) as avgdiast_post FROM hdsessiondata WHERE hdsesszid=$zid AND DATEDIFF(NOW(),hdsessdate)<$bp_avg_days";
include "$rwarepath/incl/runparsesinglerow.php";
$sql = "UPDATE hdpatdata SET lastavg_syst=$avgsyst_pre, lastavg_diast=$avgdiast_pre, lastavg_systpost=$avgsyst_post, lastavg_diastpost=$avgdiast_post WHERE hdpatzid=$zid LIMIT 1";
$result = $mysqli->query($sql);

//log the event
$eventtype="Patient HD Session Data ID $hdsessionid updated";
$eventtext=$mysqli->real_escape_string($updatefields);
include "$rwarepath/run/logevent.php";
