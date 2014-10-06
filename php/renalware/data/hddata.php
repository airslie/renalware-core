<?php
//Sun Dec 20 13:06:45 JST 2009
$sql= "SELECT * FROM hdpatdata WHERE hdpatzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
$currschedslot=FALSE;
if ($currsched) {
	$currschedslot="$currsched-$currslot";
}
$hdfflag = ($hdtype!="HD") ? TRUE : FALSE ;
//get avg BPs from sessions
//$bp_avg_days set in CONFIG.PHP
$sql= "SELECT 
MAX(syst_pre) as maxsyst_pre, MIN(syst_pre) as minsyst_pre, ROUND(AVG(syst_pre),0) as avgsyst_pre,
MAX(syst_post) as maxsyst_post, MIN(syst_post) as minsyst_post, ROUND(AVG(syst_post),0) as avgsyst_post,
MAX(diast_pre) as maxdiast_pre, MIN(diast_pre) as mindiast_pre, ROUND(AVG(diast_pre),0) as avgdiast_pre,
MAX(diast_post) as maxdiast_post, MIN(diast_post) as mindiast_post, ROUND(AVG(diast_post),0) as avgdiast_post
FROM hdsessiondata WHERE hdsesszid=$zid AND DATEDIFF(NOW(),hdsessdate)<$bp_avg_days";
include "$rwarepath/incl/runparsesinglerow.php";
//---------------Sun Apr 11 16:01:15 CEST 2010---------------
//for new transport data; will override any above pro tem NB
$sql = "SELECT transportflag,transporttype,transportdate,transportdecider FROM patientdata WHERE patzid=$zid LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
?>