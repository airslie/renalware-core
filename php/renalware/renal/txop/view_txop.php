<?php
//--Fri Mar  8 10:49:43 EST 2013--
require '../../config_incl.php';
require '../../incl/check.php';
require '../../fxns/fxns.php';
//set mod
$thismod="txop";
require 'config_'.$thismod.'.php';
//handle GET
$zid=(int)$get_zid;
$thisid=(int)$get_id;
${$thismod."_id"}=$thisid;
//get patientdata
$zid=(int)$get_zid;
include "$rwarepath/data/patientdata.php";
include "$rwarepath/data/probs_meds.php";
include "$rwarepath/data/renaldata.php";
if ($esdflag) {
    include "$rwarepath/data/esddata.php";
	}
include "$rwarepath/data/currentclindata.php";
// ---------RUN SPECIAL PRN HERE -----------
$successmsgs = array();
$errormsgs = array();
$infomsgs = array();
if ($post_run=='addtxbx')
	{
	foreach ($_POST as $key => $value) {
	$escvalue=$mysqli->real_escape_string($value);
	${$key} = (substr($key,-4)=="date") ? fixDate($escvalue) : $escvalue ;
	}
	$sql="INSERT INTO txbxdata (txbxdate, txbxresult1, txbxresult2, txbxnotes, txbxzid, txbxaddstamp, txbxmodifstamp, txbxuser, txopid) VALUES ('$txbxdate', '$txbxresult1','$txbxresult2','$txbxnotes', $zid, NOW(), NOW(), '$user', $post_txop_id)";
	$result = $mysqli->query($sql);
    $successmsgs[]="Your biopsy result has been recorded!";
}
//start table
//display existing
//select...
// -----------END RUN SPECIAL --------------
//get data here as may be refreshed above
include 'get_txop.php';
$pagetitle="View $thismodlbl $thisid";
//get header with wrap, container divs incl
include "$rwarepath/parts/head_bsnonav.php";
//start p content
echo '<div class="row">
  <div class="span12">
  <h1><small>'.$pagetitle.'</small></h1>
  <p class="text-error patref">'.$patref_addr.'</p>';
  echo '<div class="alert">NOTE: this is a PROTOTYPE only and will need feedback and updating of links before going live.</div>';
  //display notifs prn
  foreach ($successmsgs as $msg) {
      echo '<div class="alert alert-success alert-fade"><button type="button" class="close" data-dismiss="alert">&times;</button>'.$msg.'</div>';
  }
// --------------config links and nav options
$listlink='<a href="renal/'.$thismod.'/list_'.$thismod.'.php">Transplant Ops List</a>';
$viewlink='<a href="renal/'.$thismod.'/view_'.$thismod.'.php?zid='.$zid.'&amp;id='.$thisid.'">View Op</a>';
$updlink='<a href="renal/'.$thismod.'/upd_'.$thismod.'.php?zid='.$zid.'&amp;id='.$thisid.'">Update Op</a>';
$clinsummlink='<a href="pat/patient.php?zid='.$zid.'&amp;vw=clinsumm">Patient Clin Summ</a>';
$renallink='<a href="renal/renal.php?zid='.$zid.'&amp;scr=txscreenview">Transplant Screen</a>';
//start view navbar
echo '<ul class="nav nav-pills noprint">
<li>'.$listlink.'</li>
  <li class="disabled">'.$viewlink.'</li>
  <li>'.$updlink.'</li>
  <li>'.$clinsummlink.'</li>
  <li>'.$renallink.'</li>
</ul>';
//close top div
  echo '</div>
</div>';
// -------------- START CONTENT ---------------------
// --------------START 3 COLUMNS ------------------
echo '<div class="row">'; // ---------start row
echo '<div class="span4">'; // ---------start 1st col
//data list header
//echo "<h4>$thismodlbl Data</h4>";
//show data
$fldmap=$txop_map; // from config
//may be broken into segments so define here
$showfields=array(
    'txop_id',
    'txopdate',
    'txopno',
    'txoptype',
    'patage',
    'lastdialdate',
    '#DONOR INFO',
    'donortype',
    'donorsex',
    'donorbirthdate',
    'donorage',
    'donorweight',
    'donor_deathcause',
    'donorHLA',
    'HLAmismatch',
    'donorCMVstatus',
    'recipCMVstatus',
    'donor_bloodtype',
    'recip_bloodtype',
);
// ---------start data list
echo '<table class="table table-striped table-condensed dlist">';
include "$rwarepath/make/make_listfields.php";
echo '</table>';
// ---------end data list
echo '</div>
<div class="span4">'; // ---------start 2nd col
$showfields=array(
    '#OPERATION NOTES',
    'kidneyside',
    'kidney_asyst',
    'txsite',
    'kidney_age',
    'kidney_weight',
    'coldinfustime',
    'failureflag',
    'failuredate',
    'failurecause',
    'failuredescr',
    'stentremovaldate',
    'graftfxn',
    'immunosuppneed',
    '#DSA AND BKV',
    'dsa_date',
    'dsa_result',
    'dsa_notes',
    'bkv_date',
    'bkv_result',
    'bkv_notes'
);
// ---------start data list
echo '<table class="table table-striped table-condensed dlist">';
include "$rwarepath/make/make_listfields.php";
echo '</table>';
// ---------end data list
echo '</div>
<div class="span4">'; // ---------start 3nd col
//empty here
echo '</div>'; // ------- end 3 cols
echo '</div>'; // ------- end this row
// --------------END 2 COLUMNS ------------------

// --------------START 1 COLUMN ------------------
echo '<div class="row">'; // ---------start row
echo '<div class="span12">'; // ---------start 1st col
//data list header
echo "<h4>Transplant Biopsies</h4>";
include 'portal_txbxdata.php';

echo '</div>'; // ------- end 1 col
echo '</div>'; // ------- end this row
// --------------END 1 COLUMN ------------------


// -------------- END CONTENT ---------------------
include "$rwarepath/parts/footer_bs.php";
