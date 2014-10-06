<?php
//--Mon Oct 15 09:32:38 SGT 2012--
//Sun Dec 21 11:26:09 SGT 2008
//--Fri Jun  8 13:34:30 CEST 2012--
$thistab="selectquarter.php";
require '../config_incl.php';
require '../incl/check.php';
$pagetitle="Renal Reg Export: Select Quarter";
if (isset($_GET['qtr'])) {
	include 'incl/rregmaps_incl.php';
	$qtr=$_GET['qtr'];
	$pagetitle="Renal Reg Export";
	$startdmy=$qtrstartdmys[$qtr];
	$enddmy=$qtrenddmys[$qtr];
	$startdate=$qtrstartdates[$qtr];
	$enddate=$qtrenddates[$qtr];
	$_SESSION['sessqtr']=$qtr;
	$_SESSION['sessstartdate']=$startdate;
	$_SESSION['sessenddate']=$enddate;
	$qtrsetflag=TRUE;
	$debug=$_GET['debug'];
	$debugstatus = ($debug == 'Y') ? "TRUE" : "FALSE" ;
}
include '../parts/head_bs.php';
include 'incl/navbar_incl.php';
echo '<div id="pagetitlediv"><h1><small>'.$pagetitle.'</small></h1></div>';
if ($_GET['qtr']) {
    echo '<div class="alert"><p>Thank you. You are running Quarter No '.$qtr.' ('.$startdate.'-'.$enddate.') with DEBUG='.$debugstatus.'.<br>
            Continue with the options above or change quarters below.</p></div>';
}
echo '<form class="form well" action="renalreg/selectquarter.php" method="get" accept-charset="utf-8">
	<fieldset>
		<legend>Select Renal Reg Quarter</legend>
	<p><select name="qtr" id="qtr">
    <option value="">Select quarter ending (d/m/Y)...</option>';
include 'incl/rregmaps_incl.php';
foreach($qtrenddmys as $qtr => $enddate) {
    echo '<option value="'.$qtr.'">'.$enddate.' (Qtr '.$qtr.')</option>';
    }
echo '</select></p>
<p><label>Debug (Show SQL)?</label><input type="radio" name="debug" value="N" checked />No &nbsp; &nbsp; <input type="radio" name="debug" value="Y" />Yes</p>
<p><input type="submit" class="btn btn-success" value="Continue &rarr;" /></p>
</fieldset>
</form>';

include 'incl/footer_incl.php';
