<?php
//----Tue 15 Jun 2010----
require '../../config_incl.php';
include '../../incl/check.php';
include '../../fxns/fxns.php';
include '../../fxns/formfxns.php';
//separate header w/ form css
include "$rwarepath/parts/head.php";
$zid = $get_zid;
if ($zid) {
	include "$rwarepath/data/patientdata.php";
}
#*******************************************SET UP*******************************************
//set table
$table="petadeqdata";
//set table name
$tablename="PET/Adequacy";
//table metadata
$formzid="petadeqzid";
$mode="add";
// set OPTIONLISTS;
$transporterstatus_options=array(
'LOW'=>'LOW',
'LOW AVERAGE'=>'LOW AVERAGE',
'HIGH AVERAGE'=>'HIGH AVERAGE',
'HIGH'=>'HIGH',
);
#*******************************************END SET UP*******************************************
//sigh... get existing data
$table="petadeqdata";
$where="WHERE petadeqzid=$zid";
$orderby="ORDER BY addstamp DESC";
$limit="LIMIT 1";
$sql = "SELECT * FROM $table $where $orderby $limit";
$result = $mysqli->query($sql);
if ($result) {
	$row = $result->fetch_assoc();
	include "$rwarepath/fxns/parserows.php";
	}
?>
<div id="pagetitlediv"><h3><?php echo $patref_addr ?></h3></div>
<p class="buttonsdiv"><button style="color: red;" onclick="javascript:history.go(-1)">Cancel (go back)</button></p>
<form action="renal/run/run_<?php echo $mode . $table ?>.php" method="post" accept-charset="utf-8">	
	<input type="hidden" name="<?php echo $formzid ?>" value="<?php echo $get_zid ?>" id="<?php echo $formzid ?>">
<fieldset>
<legend><?php echo $mode . ' '.$tablename . ' Data '; ?></legend>
<ul class="form">
<?php
pickDate("adddate","Updated");
pickDate("petdate","PET Date");
pickDate("adeqdate","Adequacy Date");
makeSelect("transporterstatus","transporter status",$transporterstatus, $transporterstatus_options);
inputText("ktv","KTV",6,$ktv);
inputText("cre_clear","CRE Clearance",6,$cre_clear);
inputText("fluidremoval_24hrs","24 hr fluid removal",12,$fluidremoval_24hrs);
inputText("urinevolume_24hrs","24 hr urine volume",12,$urinevolume_24hrs);
makeRadios("regimechange","regime change?",$regimechange, $yesno);
?>
<li class="submit"><input type="submit" style="color: green;" value="<?php echo $mode . ' data' ?>" /></li>
</ul>
</fieldset>
</form>
</div>
</body>
</html>