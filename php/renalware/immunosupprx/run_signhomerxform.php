<?php
//----Tue 15 Jul 2014----now only for home rx
//----Tue 21 Jan 2014----signed by $prescriber
//----Tue 21 Jan 2014----change EPR path
//----Tue 07 Jan 2014----mark repeatrxdata
//----Mon 06 Jan 2014----incl $html header etc
//--Sun Jan  5 17:24:03 GMT 2014--
require 'req_fxnsconfig.php';
$zid=(int)$get_zid;
$src = $mysqli->real_escape_string($_GET["src"]);
//TESTING
$debug=false;
include '../data/patientdata.php';
include '../data/renaldata.php';
$uid=$sess_uid;
include '../data/userdata.php';
$prescriber=strtoupper($authorsig);
$pagetitle= 'Renalware: Immunosuppressant Homecare Prescription';
$pageheader= 'Immunosuppressant<br>Homecare Prescription';
$html='<!DOCTYPE html>
<html lang="en">
<head>
	<title>'.$pagetitle.' (KCH No '.$hospno1.')</title>
	<meta charset="utf-8" />
<style type="text/css" media="screen, print">
body {
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 12px;
  line-height: 1.428571429;
  color: #333333;
  background-color: #ffffff;
}';
$html .= file_get_contents("$rwarepath/bs3/css/renalware_bs.css");
$html.='</style>
	</head>
	<body>
    <table>
        <tr>
            <td style="width: 75%">
                <h1>'.$pageheader.'</h1>
                <br><br>
            </td>
            <td>
                <div class="text-right">
                    <span id="trustname">King&rsquo;s College Hospital</span><span id="nhslogo">NHS</span><br>
        		      <span id="trustcaption">NHS Foundation Trust</span><br><br>
                      <address>
                          <strong>Pharmacy Department</strong><br>
                          Denmark Hill, London SE5 9RS
                      </address>
                </div> 
            </td>
        </tr>
    </table>
    <h3>'.$patref_addr.'</h3>
        <div class="alert alert-warning"><p>ALLERGIES: <span class="text-danger">'.$clinAllergies.'</span></p></div>
        <h4>Current Immunosuppressant Medication</h4>
        <table class="table table-bordered table-condensed">
          <thead>
              <tr>
              <th>Renal ID</th>
              <th>Date</th>
              <th>Drug</th>
              <th>Dose</th>
              <th>Route</th>
              <th>Instructions</th>
              <th>Pharmacy Screen<br><i>(print &amp; sign)</i></th>
              </tr>
          </thead>
          <tbody>'; //$html
$where="WHERE medzid=$zid AND immunosuppflag=1 AND termflag=0 AND provider='home'";
$sql = "SELECT * FROM medsdata $where";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
    //collate med IDs for log table
$med_ids=" "; //need space at start for indexing
$medsdata="";
$med_idsarray = array();
while($row = $result->fetch_assoc())
  {
      $med_ids.=$row["medsdata_id"].' ';
      $med_idsarray[]=$row["medsdata_id"];
      $medsdata.='; '.$row["drugname"].' '.$row["dose"]. ' '. $row["route"].' '.$row["freq"];
      $html.= '<tr>
          <td>'.$row["medsdata_id"].'</td>
          <td>'.dmYYYY($row["adddate"]).'</td>
          <td>'.$row["drugname"].'</td>
          <td>'.$row["dose"].'</td>
          <td>'.$row["route"].'</td>
          <td>'.$row["freq"].'</td>
          <td>&nbsp;</td>
          </tr>';
  }
  $html.='</tbody>
        </table>
  <h4>For prescribing physician to complete:</h4>
<table class="table table-bordered table-condensed">
    <tbody>
        <tr>
        <td style="width: 15%"><b>Clinic Name:</b><br>TRANSPLANT</td>
        <td style="width: 15%"><b>Consultant:</b><br>MacDougal/Shah</td>
            <td><b>New patient:</b><br>YES [&nbsp;&nbsp;] &nbsp;&nbsp; NO [&nbsp;&nbsp;]</td>
            <td><b>Dose Change:</b><br>YES [&nbsp;&nbsp;] &nbsp;&nbsp; NO [&nbsp;&nbsp;]</td>
            <td><b>Repeat prescription for:</b><br>3 months [&nbsp;&nbsp;] &nbsp;&nbsp; 6 months [&nbsp;&nbsp;]</td>
            <td><b>Frequency of deliveries:</b><br>3 months [&nbsp;&nbsp;] &nbsp;&nbsp; 6 months [&nbsp;&nbsp;]</td>
            <td><b>Delivery due by:</b><br>&nbsp;&nbsp;</td>
        </tr>
        <tr><td colspan="7"><b>Additional Information:</b></td></tr>
    </tbody>
</table>
<h3>SIGNED BY '.$prescriber.' ON '.$get_formdt.'</h3>
<div class="panel panel-default">
  <div class="panel-body">
    <b>FOR PHARMACY USE</b> Order Number:
  </div>
</div>';
$footertext='For further information please contact: Pharmacy Medicines Finance Team, kch-tr.MedicinesFinancePharmacy@nhs.net, 020 3299 4597.<br>
Evolution Urgent Fax No: 01234357082@fax.nhs.net Non-urgent prescriptions e-mail: evolution.homecare@nhs.net';
$html.='<p class="text-muted credit">'.$footertext.'</p>
    </body>
</html>';
//IMPORTANT -- html display requires header/footer parts
//INSERT
$htmlfix= $mysqli->real_escape_string($html);
$medsdatafix=substr($medsdata,2); //strip init '; '
$insertfields="rxformdate, rxformzid, rxformhospno, rxformuid, rxformuser, rxformmeds, rxformhtml, med_ids";
$insertvals="CURDATE(), $zid, '$hospno1', $uid, '$user','$medsdatafix', '$htmlfix', '$med_ids'";
$sql = "INSERT INTO renalware.immunosupprxforms ($insertfields) VALUES ($insertvals)";
$result = $mysqli->query($sql);
//get new ID
$newform_id=$mysqli->insert_id;
//log each med_id
$insertfields="logdate, logzid, loghospno, rxform_id, med_id, loguid, loguser";
$insertvalgroups="";
$update_med_ids="";
//use array
foreach ($med_idsarray as $med_id) {
    $update_med_ids.=",$med_id";
    $insertvalgroups.=",(CURDATE(), $zid, '$hospno1', $newform_id, $med_id, $uid, '$user')";
}
//strip ,
$insertvalgroups=substr($insertvalgroups,1);
$update_med_ids=substr($update_med_ids,1);
$sql = "INSERT INTO immunosupprxmedlogs ($insertfields) VALUES $insertvalgroups";
$result = $mysqli->query($sql);
//mark all patient's rx as printed
$sql = "UPDATE medsdata SET printdate=CURDATE(), printdt=NOW(),printflag=1,printuid=$uid WHERE medsdata_id IN ($update_med_ids)";
$result = $mysqli->query($sql);
//mark repeatrxdata
$sql = "UPDATE immunosupprepeatrxdata SET rundt=NOW(),runflag=1,runuid=$uid,runuser='$user' WHERE runflag=0 AND hospno='$hospno1'";
$result = $mysqli->query($sql);
//send to EPR
$formdt=$get_formdt;
$basefilename=$hospno1.'_'.strtoupper($lastname).'_'.$formdt;
$htmlfilename=$basefilename.'.html';
$_SESSION['runsuccess']="The patient&rsquo;s form was marked printed and logged";
//----Tue 21 Jan 2014----now send to Renal General folder ----Tue 15 Jul 2014----now uses config
if ($sendrxform2eprflag) {
    $handle = fopen("$EPRpath/General/$htmlfilename", "w"); //for archives
    fwrite($handle, $html);
    fclose($handle);
    $_SESSION['runsuccess']="The patient&rsquo;s form was marked printed, sent to EPR, and logged";
}
//return to list
header("Location: list_unprintedrepeatrx.php");
