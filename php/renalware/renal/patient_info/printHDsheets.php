<?php
require '../../config_incl.php';
include '../../incl/check.php';
include '../../fxns/fxns.php';
$pagetitle="$siteshort HD Patient Information Sheets";
if (isset($_GET['hdsite']))
{
	$sitecode=$_GET['hdsite'];
	$schedule=$_GET['currsched'];
	$pagetitle.= " for site $sitecode on $schedule";
}

//get header
include "$rwarepath/parts/head_infosheet.php";
//set $where
$where=""; //default
if (isset($_GET['zid']))
{
	$zid=$_GET['zid'];
	$where="WHERE hdpatzid=$zid";
}
if (isset($_GET['hdsite']))
{
	$sitecode=$_GET['hdsite'];
	$schedule=$_GET['currsched'];
	$where="WHERE currsite='$sitecode' AND currsched='$schedule'";
}
$sql="SELECT hdpatzid FROM hdpatdata LEFT JOIN patientdata on hdpatzid=patzid $where ORDER BY lastname, firstnames";
$hdresult = $mysqli->query($sql);
$numrows=$result->num_rows;
while($row = $hdresult->fetch_assoc())
	{
		$zid=$row["hdpatzid"];
		include "$rwarepath/data/hddata.php";
		include "$rwarepath/data/patientdata.php";
		include "$rwarepath/data/probs_meds.php";
		include "$rwarepath/data/renaldata.php";
		include "$rwarepath/data/currentclindata.php";
		include "$rwarepath/pathology/get_currentpathdata.php";
		include('HDinfosheet_incl.php');
		echo '<div style="page-break-after:always"></div>';
	}
?>
</body>
</html>