<?php
//----Mon 25 Feb 2013----tweaks
$zid = $_GET['zid'];
include '../req/confcheckfxns.php';
$vw = ($get_vw) ? $get_vw : 'clinsumm'; //default
include "$rwarepath/data/patientdata.php";
include "$rwarepath/data/probs_meds.php";
include "$rwarepath/data/currentclindata.php";
//for updating meds
if (isset($_POST['runtype'])) {
	include 'run/'.$post_runtype .'.php';
}
include "$rwarepath/data/renaldata.php";
if ($esdflag) {
    include "$rwarepath/data/esddata.php";
}
$pagetitle= $titlestring;
//get header
include '../parts/head.php';
include '../navs/toppatnav.php'; 
//end array nav
include $vw . '.php';
include '../parts/footer.php';
