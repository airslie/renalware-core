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
$table="capdrxdata";
//set table name
$tablename="CAPD Treatment";
//table metadata
$formzid="capdrxzid";
$mode="add";
// set OPTIONLISTS prn;
$no_exchange_options=range(3,7);
$system_options=array(
	'SOLO'=>'SOLO',
	'StaySafe'=>'StaySafe'
	);
$calcium_options=array(
	'PD4'=>'PD4',
	'PDI'=>'PDI'
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
<legend><?php echo $mode . ' '.$tablename . ' Data '; ?></legend>
<ul class="form">
<?php
inputText("adddate","adddate",12,$adddate);
makeRange("no_exchange","No exchanges",$no_exchange,range(3,7));
inputText("volume","volume",12,$volume);
inputText("dextrose","dextrose",50,$dextrose);
makeRadios("calcium","calcium",$calcium, $calcium_options);
makeRadios("system","system",$system, $system_options);
inputText("extraneal","extraneal",12,$extraneal);
inputText("ph","pH",12,$ph);
makeSelect("signature","signature",$signature, $signature_options);
?>
<li class="submit"><input type="submit" style="color: green;" value="<?php echo $mode . ' data' ?>" /></li>
</ul>
</fieldset>
</form>
</div>
</body>
</html>