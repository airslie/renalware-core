<?php
include '../req/confcheckfxns.php';
if (isset($_GET['stage'])) {
	$stage = $_GET['stage'];
}
else {
	$stage = $_POST['stage'];
}
switch($stage) {
	case "findpat":
		$pagetitle="Locate Patient for Letter";
		include '../parts/head.php';
		include '../navs/mainnav.php';
		echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
		include('incl/locatelettpat.php');
		break;
	default:
		$pagetitle="Locate Patient for Letter";
		include '../parts/head.php';
		include '../navs/mainnav.php';
		echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
		include('incl/locatelettpat.php');
		break;
}
 include '../parts/footer.php';
?>