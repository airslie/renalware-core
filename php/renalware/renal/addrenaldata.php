<?php
include '../req/confcheckfxns.php';
//get patientdata
$zid = $_GET['zid'];
include "$rwarepath/data/patientdata.php";
include "$rwarepath/data/probs_meds.php";
//incl these 2 prn

include "$rwarepath/data/renaldata.php";
$form = $_GET['form'];
$pagetitle= 'Add ' . $form . ' data for ' . $firstnames . ' ' . strtoupper($lastname);
//get header
include '../parts/head.php';
if ($_GET['mode']=="entry")
	{
	include('forms/' . $form . 'form.html');
	}
if ($_GET['mode']=="add")
	{
	include('forms/' . $form . 'add.php');
	}
?>
</body></html>