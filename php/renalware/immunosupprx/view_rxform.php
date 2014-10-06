<?php
//----Tue 07 Jan 2014----
//--Wed Nov  6 12:00:34 CET 2013--
require_once '../req/confcheckfxns.php';
$form_id=$get_id;
$list='pharmacyrx'.$get_l; //may come from meds or forms lists
$debug=false;
$pagetitle= "Immunosuppressant Homecare Prescription #$form_id";
//require "../bs3/incl/head_bs3.php";
$sql = "SELECT * FROM renalware.immunosupprxforms WHERE rxform_id=$form_id";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
foreach ($row as $key => $value) {
    ${$key}=$value;
}
echo $rxformhtml;
