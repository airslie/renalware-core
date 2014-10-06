<?php
//
require '../../config_incl.php';
include '../../incl/check.php';
include '../../fxns/fxns.php';
include '../../fxns/formfxns.php';
//separate header w/ form css
include "$rwarepath/parts/head.php";
$zid = $get_zid;
$exitsitedata_id = $get_data_id;
$prim_id="exitsitedata_id";
if ($zid) {
	include "$rwarepath/data/patientdata.php";
}
#*******************************************SET UP*******************************************
//set table
$table="exitsitedata";
$tablename="Exit Site Infection";
$mode="update";
// set OPTIONLISTS prn;
include "$rwarepath/optionlists/renaloptionlistarrays.php";

#*******************************************END SET UP*******************************************
//sigh... get existing data
$where="WHERE exitsitedata_id=$exitsitedata_id";
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
<form action="renal/run/run_<?php echo $mode . $table ?>.php?zid=<?php echo $zid ?>" method="post" accept-charset="utf-8">	
	<input type="hidden" name="<?php echo $prim_id ?>" value="<?php echo ${$prim_id} ?>" id="<?php echo $prim_id ?>" />
<fieldset>
<legend><?php echo $mode . ' '.$tablename . ' Data'; ?></legend>
<ul class="form">
<?php
inputText("infectiondate","infection date",12,$infectiondate);
makeSelect("organism1","organism 1",$organism1, $organism_options);
makeSelect("organism2","organism 2",$organism2, $organism_options);
inputText("treatment","treatment",100,$treatment);
inputText("outcome","outcome",100,$outcome);
inputText("exitsitenotes","exitsitenotes",100,$exitsitenotes);
?>
<li class="submit"><input type="submit" style="color: green;" value="<?php echo $mode . ' data' ?>" /></li>
</ul>
</fieldset>
</form>
</body>
</html>