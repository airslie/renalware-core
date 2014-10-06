<?php
//----Wed 06 Mar 2013----DSA, BKV
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
//separate header w/ form css
include "$rwarepath/parts/head.php";
//process GETS
// zid, mode (add, update, view)
foreach ($_GET as $key => $value) {
	${$key}=$value;
}
if ($zid) {
	include "$rwarepath/data/patientdata.php";
	$txopzid=$zid;
}
//*******************************************SET UP*******************************************
//set table
$table="txops";
//set table name
$tablename="Transplant Operation";
//set GOTO
$goto="../renal/txoplist.php";
//get data if exists
//table metadata
//config special and omit from form_data
$prim_id="txop_id";
$formzid="txopzid";
$formaddstamp="txopaddstamp";
$formmodifstamp="txopmodifstamp";
//get data if avail
if (${$prim_id}) {
	include '../../data/'.$table .'_data.php';
}
//form fields
$form_data=array(
'txopdate.d'=>'Op Date',
'txopno.t3'=>'Tx Op No',
'txoptype.s'=>'Op type',
'patage.t3'=>'patient age',
'lastdialdate.d'=>'last dial date',
'donortype.s'=>'donor type',
'donorsex.s'=>'donor sex',
'donorbirthdate.d'=>'donor birthdate',
'donorage.t3'=>'donor age',
'donorweight.t5'=>'donor weight',
'donor_deathcause.t80'=>'donor cause of death',
'donorHLA.a2x80'=>'donor HLA',
'HLAmismatch.a2x80'=>'HLA mismatch',
'donorCMVstatus.s'=>'donor CMV status',
'recipCMVstatus.s'=>'recip CMV status',
'donor_bloodtype.s'=>'donor blood type',
'recip_bloodtype.s'=>'recip blood type',
'kidneyside.s'=>'kidney side',
'kidney_asyst.s'=>'kidney asyst',
'txsite.t20'=>'transplant site',
'kidney_age.t8'=>'kidney age',
'kidney_weight.t5'=>'kidney weight',
'coldinfustime.t10'=>'cold infusion time',
'failureflag.1'=>'Tx Failed?',
'failuredate.d'=>'failure date',
'failurecause.t80'=>'failure cause',
'failuredescr.t80'=>'failure descr',
'stentremovaldate.d'=>'stent removal date',
'graftfxn.s'=>'graftfxn',
'dsa_date.d'=>'DSA test date',
'dsa_result.s'=>'DSA results',
'dsa_notes.a2x80'=>'DSA notes',
'bkv_date.d'=>'BKV test date',
'bkv_result.s'=>'BKV results',
'bkv_notes.a2x80'=>'BKV notes',
);
//omit special fields
//'failureflag.t'=>'failureflag',
// set OPTIONLISTS;
$txoptype_options=array(
'kidney',
'kidney/pancreas',
'kidney/liver',
'liver',
'pancreas',
);
$donortype_options=array(
'cadaver',
'live related',
'NHB',
'live unrelated donor'
);
$donorCMVstatus_options=array(
'Unknown',
'Positive',
'Negative',
);
$recipCMVstatus_options=array(
'Unknown',
'Positive',
'Negative',
);
$dsa_result_options=array(
'Unknown',
'Positive',
'Negative',
);
$bkv_result_options=array(
'Unknown',
'Positive',
'Negative',
);

$donor_bloodtype_options=array('A', 'B', 'O', 'AB', 'A+','A-','B+','B-','O+','O-');
$recip_bloodtype_options=array('A', 'B', 'O', 'AB', 'A+','A-','B+','B-','O+','O-');
$donorsex_options=array('M','F');
$kidneyside_options=array('L','R');
$kidney_asyst_options=array('Y','N');
$graftfxn_options=array(
'immediate',
'delayed',
'primary non-function',
);
//*******************************************END SET UP*******************************************
?>
<div id="pagetitlediv"><h2><?php echo $patref_addr ?></h2></div>
<?php
if ($mode=="view" && !$print) {
	include 'viewmenu_incl.php';
}
?>
<?php if ($mode != "view"): ?>
	<p class="buttonsdiv"><button style="color: red;" onclick="javascript:history.go(-1)">Cancel (go back)</button></p>
	<form  action="renal/run/run_<?php echo $mode . $table ?>.php" method="post" accept-charset="utf-8">	
	<input type="hidden" name="txop_id" value="<?php echo $txop_id ?>" id="txop_id">
	<input type="hidden" name="txopzid" value="<?php echo $txopzid ?>" id="txopzid">
<?php endif ?>
<fieldset>
<legend><?php echo $mode . ' '.$tablename . ' Data ' . ${$prim_id}; ?></legend>
<ul class="form">
<?php
//generates TR/TD/TD/TR rows
switch ($mode) {
	case 'add':
		include 'makeformtable_incl.php';
		break;
	case 'update':
		include 'makeformtable_incl.php';
		break;
	default:
		include 'makeviewtable_incl.php';
		break;
}
?>
</ul>
</fieldset>
<?php if ($mode !=="view"): ?>
	<input type="submit" name="" value="<?php echo $mode . ' ' . $tablename ?>" id="" />
</form>
<?php endif ?>

<?php
//get bx table
include('../incl/txbx_incl.php');
?>
</div>
</body>
</html>