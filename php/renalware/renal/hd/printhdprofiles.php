<?php
//streamlined Sat Nov 21 12:34:00 CET 2009 ----Mon 05 Nov 2012----
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$pagetitle="$siteshort HD Profiles";
if (isset($_GET['sss']))
{
	$siteschedslot = explode("-",$_GET["sss"]);
	$site = $siteschedslot[0];
	$sched = $siteschedslot[1];
	$slot = $siteschedslot[2];
	$pagetitle.= " for site $site on $sched (slot $slot)";
}
//get header
include "$rwarepath/parts/head.php";
//to print for one site/sched
$where = "WHERE modalcode LIKE 'HD%' AND currsite='$site' AND currsched='$sched' AND currslot='$slot'";
//if only one patient
if ($get_zid) {
	$where = "WHERE hdpatzid=$get_zid";
}
$sql="SELECT hdpatzid FROM hdpatdata LEFT JOIN patientdata on hdpatzid=patzid $where ORDER BY lastname, firstnames";
$hdresult = $mysqli->query($sql);
while ($row = $hdresult->fetch_assoc()) {
	$zid = $row["hdpatzid"];
	include "$rwarepath/data/hddata.php";
	include "$rwarepath/data/patientdata.php";
	include "$rwarepath/data/renaldata.php";
	include "$rwarepath/pathology/get_currentpathdata.php";
	include 'profileprint_incl.php';
	echo "--------------------------------------------------------------------------------------------------------------";
	include('hdsesslistprint.php');
	echo '<div style="page-break-after:always"></div>';
	}
echo '</body>
</html>';
