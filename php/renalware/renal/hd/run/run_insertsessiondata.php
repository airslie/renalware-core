<?php
//----Fri 14 Feb 2014----fix for null subs* field inserts
//----Wed 12 Feb 2014----post-HD avg syst/diast BPs (for R Reg)
//----Sun 08 Dec 2013----URR,KTV
//----Mon 25 Feb 2013----accesssitestatus
//updated Mon Jul 20 11:03:23 BST 2009 dressingchange
//----Fri 02 Jul 2010----parse out titles
//----Tue 15 Feb 2011----mrsaswabflag
$titlestuff=array('pre','post','time on','time off','sign on','sign off');
foreach ($_POST as $key => $val) {
	$vfix = $mysqli->real_escape_string($val);
	if (in_array($val, $titlestuff)) {
		$vfix="";
	}
	${$key} = (substr(strtolower($key),-4)=="date") ? fixDate($vfix) : $vfix ;
}
//add to hdsessions v2
$dressingchangeflag = ($dressingchangeflag) ? 1 : 0 ;
$mrsaswabflag = ($mrsaswabflag) ? 1 : 0 ;
$insertfields="hdsesszid, hdsessaddstamp, hdsessmodifstamp, hdsessuser, hdsessdate, sitecode, schedule, hdtype, timeon, timeoff, wt_pre, wt_post, weightchange, pulse_pre, pulse_post, syst_pre, syst_post, diast_pre, diast_post, temp_pre, temp_post, BM_pre, BM_post, AP, VP, fluidremoved, bloodflow, UFR,machineURR,machineKTV, machineNo, litresproc, evaluation, firstuseflag, signon, signoff, modalcode,access,dressingchangeflag,mrsaswabflag,accesssitestatus";
$insertvalues="$zid, NOW(), NOW(), '$user', '$hdsessdate', '$sitecode', '$schedule', '$hdtype','$timeon', '$timeoff', '$wt_pre', '$wt_post', '$weightchange', '$pulse_pre', '$pulse_post', '$syst_pre', '$syst_post', '$diast_pre', '$diast_post', '$temp_pre', '$temp_post', '$BM_pre', '$BM_post', '$AP', '$VP', '$fluidremoved', '$bloodflow', '$UFR','$machineURR','$machineKTV', '$machineNo', '$litresproc', '$evaluation','$firstuseflag', '$signon', '$signoff', '$modalcode','$access','$dressingchangeflag','$mrsaswabflag','$accesssitestatus'";
if ($hdtype!="HD") {
	$insertfields.=",subsfluidpct,subsgoal,subsrate,subsvol";
	$insertvalues.=",'$subsfluidpct','$subsgoal','$subsrate','$subsvol'";
}
$table = "hdsessiondata";
$sql= "INSERT INTO $table ($insertfields) VALUES ($insertvalues)";
$result = $mysqli->query($sql);
//log the event
$eventtype="NEW $hdtype SESSION (v2) for $firstnames $lastname";
$eventtext=$mysqli->real_escape_string($sql);
include "$rwarepath/run/logevent.php";
//----Sat 14 May 2011----store mean BPs ----Wed 12 Feb 2014----add post-HD
$sql= "SELECT ROUND(AVG(syst_pre),0) as avgsyst_pre, ROUND(AVG(diast_pre),0) as avgdiast_pre, ROUND(AVG(syst_post),0) as avgsyst_post, ROUND(AVG(diast_post),0) as avgdiast_post FROM hdsessiondata WHERE hdsesszid=$zid AND DATEDIFF(NOW(),hdsessdate)<$bp_avg_days";
include "$rwarepath/incl/runparsesinglerow.php";
$sql = "UPDATE hdpatdata SET lastavg_syst=$avgsyst_pre, lastavg_diast=$avgdiast_pre, lastavg_systpost=$avgsyst_post, lastavg_diastpost=$avgdiast_post WHERE hdpatzid=$zid LIMIT 1";
$result = $mysqli->query($sql);
$eventtype="Last mean HD session BPs updated SystPre=$avgsyst_pre, DiastPre=$avgdiast_pre, SystPost=$avgsyst_post, DiastPost=$avgdiast_post";
$eventtext="";
include "$rwarepath/run/logevent.php";
