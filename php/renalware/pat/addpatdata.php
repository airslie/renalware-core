<?php
include '../req/confcheckfxns.php';
//get patientdata
$zid = $_GET['zid'];
include "$rwarepath/data/patientdata.php";
include "$rwarepath/data/probs_meds.php";
include "$rwarepath/data/currentclindata.php";
$form = $_GET['form'];
$pagetitle= 'Add ' . $form . ' data for ' . $firstnames . ' ' . strtoupper($lastname);
//get header
include '../parts/head.php';
if ($get_quick=="y") {
	include('forms/' . $form . 'form.html');
} else {
	if ($_GET['mode']=="entry")
		{
		include('forms/' . $form . 'form.html');
		}
	if ($_GET['mode']=="add")
		{
		include('incl/' . $form . 'add.php');
		}
	}
?>
</div>
</body>
</html>