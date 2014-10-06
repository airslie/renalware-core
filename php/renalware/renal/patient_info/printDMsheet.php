<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$pagetitle="$siteshort Diabetic Nephrology Patient Information Sheets";
//get header
include "$rwarepath/parts/head_infosheet.php";
$zid=$_GET['zid'];
	include "$rwarepath/data/patientdata.php";
	include "$rwarepath/data/probs_meds.php";
//set no to display
$setdisplaycount=3;
	include('DMinfosheet_incl.php');
	echo '<div style="page-break-after:always"></div>';
?>
</body>
</html>