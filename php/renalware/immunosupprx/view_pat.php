<?php
//--Sun Nov 24 12:06:05 EST 2013--
//start page config
$thispage="view_pat";
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
$pagetitle= $pat_ref;
//page content starts here
require "../bs3/incl/head_bs3.php";
require 'incl/immunosupprx_nav.php';
echo '<div class="container">';
echo "<h1>$pagetitle</h1>";
//show addr info
bs_Para("info",$pat_addr);
//navs and info
require "../bs3/incl/pat_navbars.php";
?>
<!-- Nav tabs -->
<ul class="nav nav-tabs">
  <li><a href="#home" data-toggle="tab">Immunosuppression</a></li>
  <li><a href="#clinsumm" data-toggle="tab">Clinical Summary</a></li>
  <li><a href="#txscreen" data-toggle="tab">Transplant Screen</a></li>
</ul>
<!-- Tab panes -->
<div class="tab-content">
<div class="tab-pane active" id="home">
<h3>Current Immunosuppressant Rx</h3>
<?php
//----Thu 10 Jul 2014----enable changing provider
if ($get_provider && $get_mid) {
    $provider = $mysqli->real_escape_string($_GET["provider"]);
    $med_id = $mysqli->real_escape_string($_GET["mid"]);
    
    $sql = "UPDATE medsdata SET provider='$provider' WHERE medsdata_id=$med_id";
    $result = $mysqli->query($sql);
}
bs_Para("danger","IMPORTANT: Only drugs marked Provider=&ldquo;home&rdquo; will appear on the Evolution forms.");
$listitems="immunosuppressant drug(s)";
$table="medsdata";
$fields="medsdata_id,adddate,adduser,drugname,dose,route,freq,provider";
$headers="ID,date added,added by,drug name,dose,route,freq,provider";
$where="WHERE medzid=$zid AND termflag=0 AND immunosuppflag=1";
$orderby="ORDER BY adddate";
include 'make_immunorxdrugstable.php';
?>
<a class="btn btn-danger btn-sm" href="immunosupprx/list_unprintedrepeatrx.php">Return to List</a>&nbsp;&nbsp;
<a class="btn btn-success btn-sm" href="immunosupprx/sign_homerxform.php?zid=<?php echo $zid ?>">Print Home Rx Form</a>&nbsp;&nbsp;
<h3>Immunosuppressant Rx History</h3>
<?php
bs_Para("info","Currently prescribed drugs are in yellow. Most recent on the top.");
$listitems="immunosuppressant drug(s)";
$table="medsdata";
$fields="adddate,adduser,drugname,dose,route,freq,provider,medmodal,termdate,termuser";
$headers="date added,added by,drug name,dose,route,freq,provider,modal at Rx,stopped,stopped by";
$where="WHERE medzid=$zid AND immunosuppflag=1";
$orderby="ORDER BY adddate DESC";
include '../bs3/incl/make_medshxtable.php';
?>
</div>
<div class="tab-pane" id="clinsumm">
    <?php
    include '../bs3/incl/pat_clinsumm.php';
    echo '<hr>';
    include '../bs3/incl/pat_letters.php';
    echo '<hr>';
    include '../bs3/incl/pat_encounters.php';
    ?>
</div>
<div class="tab-pane" id="txscreen">
<?php
bs_Alert("warning","This will be a new summary patient Transplant Screen if desired. We would need to think about optimizing the content and layout.");
?>
</div>
</div>
<?php
//end page content
echo '</div>'; //container
require '../bs3/incl/footer_bs3.php';
