<?php
//
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
//separate header w/ form css
include "$rwarepath/parts/head.php";
$zid = $get_zid;
include "$rwarepath/data/patientdata.php";
#*******************************************SET UP*******************************************
//set table
$table="homehdassessdata";
//set table name
$tablename="Home HD Assessment";
//table metadata
$formzid="homehdassesszid";
$mode='update';
// set OPTIONLISTS prn;
/*
    housing type:
    --patient-owned
    --council-owned/suitable
    --council/unsuitable

    letters written
    --permission to convert
    --to re-house

    date written

    letters rec'd
    --permission convert granted
    --not granted
    --re-housing request ackn
    --re-housing achieved
    --denied
*/
$housingtype_options=array(
    'patient-owned' => 'patient-owned',
    'council-suitable' => 'council-owned/suitable',
    'council-unsuitable' => 'council-owned/unsuitable',
    );
$letterwrittentype_options=array(
    'conversion request' => 'req permission to convert',
    're-house request' => 'req permission to re-house',
    );
$letterrecvtype_options=array(
    'conversion granted' => 'permission to convert granted',
    'conversion refused' => 'conversion request refused',
    're-housing req acknowl' => 're-housing request acknowledged',
    're-housing req achieved' => 're-housing achieved',
    're-housing req denied' => 're-housing denied',
    );
$selfcarelevel_options=array(
	'Fully supported'=>'Fully supported',
	'Lining and priming'=>'Lining and priming',
	'Advanced independence  - no needling'=>'Advanced independence  - no needling',
	'Fully independent including needling'=>'Fully independent including needling',
	);
$programmetype_options = array(
	"Carer supported"=>'Carer supported',
	"Fully independent"=>'Fully independent',
);
#*******************************************END SET UP*******************************************
//sigh... get existing data
$where="WHERE $formzid=$zid";
$limit="LIMIT 1";
$sql = "SELECT * FROM $table $where $limit";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	$row = $result->fetch_assoc();
	include "$rwarepath/fxns/parserows.php";
	}
?>
<h2><?php echo $patref_addr ?></h2>
<input type="button" class="ui-state-default" style="color: red;" value="Cancel--Return to Home HD Screen" onclick="self.location='renal/renal.php?scr=homehdnav&amp;zid=<?php echo $zid ?>'"/>&nbsp;
<form action="renal/run/run_updatehomehdassessdata.php" method="post" accept-charset="utf-8">	
	<input type="hidden" name="<?php echo $formzid ?>" value="<?php echo $get_zid ?>" id="<?php echo $formzid ?>" />
	<?php if ($numrows): ?>
		<input type="hidden" name="homehdassess_id" value="<?php echo $homehdassess_id ?>" id="homehdassess_id" />
	<?php endif ?>
<fieldset>
<legend><?php echo $mode . ' '.$tablename . ' Data'; ?></legend>
<ul class="form">
<?php
inputText("referraldate","referral date",10,$referraldate);
makeSelect("selfcarelevel","self care level",$selfcarelevel, $selfcarelevel_options);
inputTextarea("selfcarenotes","self care notes",3,100,$selfcarenotes);
inputText("fullindepconfirm","Confirm Full Independ",20,$fullindepconfirm);
makeSelect("letterwrittentype","letter written",$letterwrittentype, $letterwrittentype_options);
inputText("letterwrittendate","Letter written date",10,$letterwrittendate);
makeSelect("letterrecvtype","letter recept",$letterrecvtype, $letterrecvtype_options);
inputText("letterrecvdate","Letter recept date",10,$letterrecvdate);
inputText("fullindepconfirmdate","Confirmation date",10,$fullindepconfirmdate);
makeSelect("programmetype","programmetype",$programmetype, $programmetype_options);
inputText("carername","carer name",60,$carername);
inputTextarea("carernotes","carer notes",3,60,$carernotes);
inputText("acceptancedate","acceptance date",10,$acceptancedate);
inputText("equipinstalldate","equipment install&rsquo;n date",10,$equipinstalldate);
inputText("firstdeliverydate","first delivery date",10,$firstdeliverydate);
inputText("trainingstartdate","training start date",10,$trainingstartdate);
inputText("firstindepdialdate","first independent dial date",10,$firstindepdialdate);
inputTextarea("assessmentnotes","notes &amp; comments",5,60,$assessmentnotes);
inputText("assessor","assessor name",50,$assessor);
?>
<li class="submit"><input type="submit" style="color: green;" value="<?php echo "$mode $tablename data"  ?>" /></li>
</ul>
</fieldset>
</form>
<?php
if ($mode=="updateassess") {
    $assesstype="{$get_assesstype}assess";
    $assessdate="{$get_assesstype}date";
    $assessment=$post_assessment;
    $sql = "UPDATE homehdassessdata SET $assesstype='$assessment', $assessdate=NOW() WHERE homehdassess_id=$post_homehdassess_id";
    $result = $mysqli->query($sql);
    //log the event
	$eventtype="NEW HOME HD $assesstype update";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//end logging
	//refresh data
	$where="WHERE $formzid=$zid";
	$limit="LIMIT 1";
	$sql = "SELECT * FROM $table $where $limit";
	$result = $mysqli->query($sql);
		$row = $result->fetch_assoc();
		include "$rwarepath/fxns/parserows.php";	
}
?>
<form action="renal/homehd/upd_assessmentform.php?zid=<?php echo $zid ?>&amp;mode=updateassess&amp;assesstype=medical" method="post" accept-charset="utf-8">	
	<input type="hidden" name="<?php echo $formzid ?>" value="<?php echo $get_zid ?>" id="<?php echo $formzid ?>" />
		<input type="hidden" name="homehdassess_id" value="<?php echo $homehdassess_id ?>" id="homehdassess_id" />
<fieldset>
<legend>Update Medical Assessment</legend>

<ul class="form">
<?php
inputTextarea("assessment","medical assessment",4,100,$medicalassess);
?>
<li class="submit"><input type="submit" style="color: green;" value="Update" /> <input type="button" class="ui-state-default" style="color: red;" value="Cancel--Return to Home HD Screen" onclick="self.location='renal/renal.php?scr=homehdnav&amp;zid=<?php echo $zid ?>'"/>&nbsp;
</li>
</ul>
</fieldset>
</form>
<form action="renal/homehd/upd_assessmentform.php?zid=<?php echo $zid ?>&amp;mode=updateassess&amp;assesstype=technical" method="post" accept-charset="utf-8">	
	<input type="hidden" name="<?php echo $formzid ?>" value="<?php echo $get_zid ?>" id="<?php echo $formzid ?>" />
		<input type="hidden" name="homehdassess_id" value="<?php echo $homehdassess_id ?>" id="homehdassess_id" />
<fieldset>
<legend>Update Technical Assessment</legend>
<ul class="form">
<?php
inputTextarea("assessment","technical assessment",4,100,$technicalassess);
?>
<li class="submit"><input type="submit" style="color: green;" value="Update" /></li>
</ul>
</fieldset>
</form>
<form action="renal/homehd/upd_assessmentform.php?zid=<?php echo $zid ?>&amp;mode=updateassess&amp;assesstype=socialwork" method="post" accept-charset="utf-8">	
	<input type="hidden" name="<?php echo $formzid ?>" value="<?php echo $get_zid ?>" id="<?php echo $formzid ?>" />
		<input type="hidden" name="homehdassess_id" value="<?php echo $homehdassess_id ?>" id="homehdassess_id" />
<fieldset>
<legend>Update Social Worker Assessment</legend>
<ul class="form">
<?php
inputTextarea("assessment","socialwork assessment",4,100,$socialworkassess);
?>
<li class="submit"><input type="submit" style="color: green;" value="Update" /> <input type="button" class="ui-state-default" style="color: red;" value="Cancel--Return to Home HD Screen" onclick="self.location='renal/renal.php?scr=homehdnav&amp;zid=<?php echo $zid ?>'"/>&nbsp;
</li>
</ul>
</fieldset>
</form>
<form action="renal/homehd/upd_assessmentform.php?zid=<?php echo $zid ?>&amp;mode=updateassess&amp;assesstype=counsellor" method="post" accept-charset="utf-8">	
	<input type="hidden" name="<?php echo $formzid ?>" value="<?php echo $get_zid ?>" id="<?php echo $formzid ?>" />
		<input type="hidden" name="homehdassess_id" value="<?php echo $homehdassess_id ?>" id="homehdassess_id" />
<fieldset>
<legend>Update Counsellor Assessment</legend>
<ul class="form">
<?php
inputTextarea("assessment","counsellor assessment",4,100,$counsellorassess);
?>
<li class="submit"><input type="submit" style="color: green;" value="Update" /> <input type="button" class="ui-state-default" style="color: red;" value="Cancel--Return to Home HD Screen" onclick="self.location='renal/renal.php?scr=homehdnav&amp;zid=<?php echo $zid ?>'"/>&nbsp;
</li>
</ul>
</fieldset>
</form>

</div>
</body>
</html>