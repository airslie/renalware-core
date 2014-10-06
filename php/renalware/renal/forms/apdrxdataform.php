<?php
//
require '../../config_incl.php';
include '../../incl/check.php';
include '../../fxns/fxns.php';
include '../../fxns/formfxns.php';
//separate header w/ form css
include "$rwarepath/parts/head.php";
include "$rwarepath/optionlists/renaloptionlistarrays.php";
$zid = $get_zid;
if ($zid) {
	include "$rwarepath/data/patientdata.php";
}
#*******************************************SET UP*******************************************
//set table
$table="apdrxdata";
//set table name
$tablename="APD Treatment";
//table metadata
$formzid="apdrxzid";
$mode="add";
// set OPTIONLISTS prn;
$calcium_options=array(
	'PD4'=>'PD4',
	'PDI'=>'PDI',
	);
#*******************************************END SET UP*******************************************
//sigh... get existing data
$where="WHERE $formzid=$zid";
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
<legend><?php echo $mode . ' '.$tablename . ' Data'; ?></legend>
<ul class="form">
<?php
pickDate("adddate","updated");
inputText("therapytype","therapy type",50,$therapytype);
inputText("totalvol","total vol",8,$totalvol);
inputText("dextrose","dextrose",50,$dextrose);
makeRadios("calcium","calcium",$calcium, $calcium_options);
inputText("therapytime","therapy time",8,$therapytime);
inputText("fillvolume","fill volume",8,$fillvolume);
inputText("lastfill","last fill",8,$lastfill);
makeRadios("extraneal","extraneal",$extraneal, $yesno);
inputText("ph","pH",4,$ph);
makeRange("no_cycles","No of cycles",$no_cycles, range(4,12));
inputText("optichoice","optichoice",12,$optichoice);
inputText("avgdwelltime","Avg Dwell Time",6,$avgdwelltime);
inputText("initdrainalarm","init drain alarm",8,$initdrainalarm);
makeSelect("signature","signature",$signature, $signature_options);
?>
<li class="submit"><input type="submit" style="color: green;" value="<?php echo $mode . ' data' ?>" /></li>
</ul>
</fieldset>
</form>
</div>
</body>
</html>