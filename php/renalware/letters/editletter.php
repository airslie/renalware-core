<?php
//----Tue 04 Sep 2012----
require '../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
include '../parts/head.php';
if ($get_stage != "created") {
    echo '<p class="buttonsdiv"><button style="color: red;" onclick="history.go(-1)">Cancel</button></p>';
}
$letter_id = $_GET['letter_id'];
$zid = $_GET['zid'];
$recipienttype = $_GET['rtype'];
include "$rwarepath/data/probs_meds.php";
include "$rwarepath/letters/data/letterpatdata.php";
include "$rwarepath/letters/data/letterpatholdata.php";
include "$rwarepath/data/currentclindata.php";
include "$rwarepath/letters/data/letterdata.php";
switch($lettertype) {
	case "discharge":
	$admid=$admissionid;
	include 'forms/editdischargeform.php';
	break;
	case "death":
	$admid=$admissionid;
	include 'forms/editdeathform.php';
	break;
	default:
	include 'forms/editletterform.php';
	break;
}
include '../parts/footer.php';
