<?php
//---------------Sun Apr 11 16:41:02 CEST 2010---------------
include '../req/confcheckfxns.php';
$zid = $_GET['zid'];
$f = $_GET['f'];
$forms=array(
	'update_transport'=>'Update Transport Info',
	'update_patient'=>'Update Patient Info',
	);
$thisformname=$forms[$f];
//get patientdata
include "$rwarepath/data/patientdata.php";
$pagetitle= "$thisformname: $firstnames " . strtoupper($lastname);
$legend = $thisformname;
include "$rwarepath/parts/head.php";
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
?>
<p><input type="button" class="ui-state-default" style="color: red;"  value="&larr; Cancel/Go Back" onclick="self.location='javascript:history.go(-1)'"/>
</p>
<?php
include "$rwarepath/pat/forms/$f.php";
include "$rwarepath/parts/footer.php";
?>