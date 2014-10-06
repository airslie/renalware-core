<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
//separate header w/ form css
$zid=$get_zid;
include('../../data/patientdata.php');
$pagetitle= "Update Advanced Directive/LPA Info: $firstnames " . strtoupper($lastname);
include "$rwarepath/parts/head.php";
//get data
$fields = "advancedirflag, advancedirdate, advancedirtype, advancedirstaff, lastingpowerflag, lastingpowerdate, lastingpowerdata, lastingpowertype, lastingpowerstaff";
$tables = "renalware.patientdata";
$where = "WHERE patzid=$zid";
$sql= "SELECT $fields FROM $tables $where LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
//--------Page Content Here----------
?>
<form action="pat/run/run_updadvdirlpadata.php" method="post">
	<input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid" />
<fieldset>
	<legend><?php echo $pagetitle; ?></legend>
	<input type="button" class="ui-state-default" style="color: white; background: red; border: red;" value="Cancel--Return to previous page" onclick="javascript:history.go(-1)"/>
	<ul class="form">	
<?php
$lastingpowertype_options = array(
	"Full"=>'Full',
	"Temporary"=>'Temporary',
	"Other"=>'Other',
	);
$flag_options=array(
	'Y'=>'Yes',
	'N'=>'No'
	);
makeSelect("advancedirflag","Adv Directive?",$advancedirflag,$flag_options);
inputText("advancedirdate","Adv Dir date",10,$advancedirdate);
inputText("advancedirtype","Adv Dir type",30,$advancedirtype);
inputText("advancedirstaff","Adv Dir staff",30,$advancedirstaff);
makeSelect("lastingpowerflag","Lasting Power of Att?",$lastingpowerflag,$flag_options);
inputText("lastingpowerdate","LPA date",10,$lastingpowerdate);
makeSelect("lastingpowertype","LPA type",$lastingpowertype,$lastingpowertype_options);
inputText("lastingpowerstaff","LPA staff",30,$lastingpowerstaff);
inputTextarea("lastingpowerdata", "LPA Attorney info", 5, 30, $lastingpowerdata);
?>
<li class="submit"><input type="submit" style="color: green;" value="Update Data" /></li>
</ul>
</fieldset>
</form>
<?php
include '../../parts/footer.php';
?>