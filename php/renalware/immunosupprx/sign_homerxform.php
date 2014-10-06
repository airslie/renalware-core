<?php
//----Tue 15 Jul 2014----improve Cancel buttons
//----Wed 09 Jul 2014----
//--Sun Jan  5 17:13:41 GMT 2014--
//start page config
$thispage="sign_rxform";
$debug=false;
$showsql=false;
//use datatables prn
$datatablesflag=false;
//include fxns and config
require 'req_fxnsconfig.php';
//get pat data
$zid=(int)$get_zid;
include '../data/patientdata.php';
include '../data/renaldata.php';
$uid=$sess_uid;
include '../data/userdata.php';
$prescriber=strtoupper($authorsig);
$showprescriber = (in_array($user, $prescribers)) ? $prescriber : '_________________________________' ;
$pagetitle= 'Renalware: Immunosuppressant Homecare Prescription';
$pageheader= 'Immunosuppressant<br>Homecare Prescription';
//page content starts here
require "../bs3/incl/head_bs3print.php";
//handle src ONLY VIEWPAT NOW ----Wed 09 Jul 2014----
$returnlink="view_pat.php?zid=$zid";
$returnlabel="Patient";
//to capture same DT in EPR as in printed version
$displaydt = date("D d M Y  G:i:s");
$formdt=date("YmdGis"); //for HTML
?>
<div class="hidden-print">
    <div class="alert alert-info">
          <strong>Instructions for printing</strong>: Click on the &ldquo;Print Form&rdquo; button to print or &ldquo;Cancel&rdquo; to go back. After you have successfully printed the form, click on &ldquo;Mark Printed/Send to EPR&rdquo; to update the status in the database and return to the list or patient view. 
          (These instructions and buttons do not appear on the printed version.) IMPORTANT: Set your printer to Landscape Mode.
    </div>
          <a class="btn btn-danger" href="immunosupprx/view_pat.php?zid=<?php echo $zid ?>">Cancel (return to Patient)</a>
          <a class="btn btn-danger" href="immunosupprx/list_unprintedrepeatrx">Cancel (return to List)</a>
          <button type="button" class="btn btn-primary" onclick="window.print();">Print Form</button>
          <a class="btn btn-success" href="immunosupprx/run_signhomerxform.php?zid=<?php echo $zid ?>&amp;formdt=<?php echo $formdt ?>">Mark Printed/Send to EPR (and return to List)</a>
</div>
    <table>
        <tr>
            <td style="width: 75%">
                <h1><?php echo $pageheader ?></h1>
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
    <h3><?php echo $patref_addr ?></h3>

        <div class="alert alert-warning"><p>ALLERGIES: <span class="text-danger"><?php echo $clinAllergies ?></span></p></div>
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
          <tbody>
<?php
$where="WHERE medzid=$zid AND immunosuppflag=1 AND termflag=0 AND provider='home'";
$sql = "SELECT * FROM medsdata $where";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
while($row = $result->fetch_assoc())
  {
      echo '<tr>
          <td>'.$row["medsdata_id"].'</td>
          <td>'.dmYYYY($row["adddate"]).'</td>
          <td>'.$row["drugname"].'</td>
          <td>'.$row["dose"].'</td>
          <td>'.$row["route"].'</td>
          <td>'.$row["freq"].'</td>
          <td>&nbsp;</td>
          </tr>';
  }
?>
          </tbody>
        </table>
<?php
if ($debug) {
    echo '<p><code>'.$sql.'</code></p>';
}
?>
<h4>For prescribing physician to complete:</h4>
<table class="table table-bordered table-condensed">
    <tbody>
        <tr>
            <td style="width: 15%"><b>Clinic Name:</b><br>TRANSPLANT</td>
            <td style="width: 15%"><b>Consultant:</b><br>MacDougall/Shah</td>
            <td><b>New patient:</b><br>YES [&nbsp;&nbsp;] &nbsp;&nbsp; NO [&nbsp;&nbsp;]</td>
            <td><b>Dose Change:</b><br>YES [&nbsp;&nbsp;] &nbsp;&nbsp; NO [&nbsp;&nbsp;]</td>
            <td><b>Repeat prescription for:</b><br>3 months [&nbsp;&nbsp;] &nbsp;&nbsp; 6 months [&nbsp;&nbsp;]</td>
            <td><b>Frequency of deliveries:</b><br>3 months [&nbsp;&nbsp;] &nbsp;&nbsp; 6 months [&nbsp;&nbsp;]</td>
            <td><b>Delivery due by:</b><br>&nbsp;&nbsp;</td>
        </tr>
        <tr><td colspan="7"><b>Additional Information:</b></td></tr>
    </tbody>
</table>    
        <h3>Signed by <?php echo "$showprescriber on $displaydt" ?> Signature: _____________________________</h3>
<div class="panel panel-default">
  <div class="panel-body">
    <b>FOR PHARMACY USE</b> Order Number:
  </div>
</div>

<?php
//needs footer text here
$footertext='For further information please contact: Pharmacy Medicines Finance Team,  kch-tr.MedicinesFinancePharmacy@nhs.net, 020 3299 4597.<br>
Evolution Urgent Fax No: 01234357082@fax.nhs.net Non-urgent prescriptions e-mail: evolution.homecare@nhs.net';
?>
<p class="text-muted credit"><?php echo $footertext ?></p>
    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="bs3/js/jquery.js"></script>
    <script src="bs3/js/bootstrap.min.js"></script>
  </body>
</html>
