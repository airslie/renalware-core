<?php
//Thu Nov 19 16:36:33 CET 2009 probably never used??
include '../req/confcheckfxns.php';
$stage = $_GET['stage'];
switch($stage) {
	case "findpat":
		$pagetitle="Locate Patient for Discharge Summary/Death Notif";
		include '../parts/head.php';
		include '../navs/mainnav.php';
		echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
		include('incl/locatedischpat.php');
		break;
	default:
		$pagetitle="Locate Patient for Discharge Summary/Death Notif";
		include '../parts/head.php';
		include '../navs/mainnav.php';
		echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
		include('incl/locatedischpat.php');
		break;
}
 include '../parts/footer.php';
?>