<?php
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
?>
<h2><?php echo $patref_addr ?></h2>
<p class="buttonsdiv"><button style="color: red;" onclick="javascript:history.go(-1)">Cancel (go back)</button></p>
<form action="renal/run/run_addhomehdassess.php" method="post" accept-charset="utf-8">	
	<input type="hidden" name="<?php echo $formzid ?>" value="<?php echo $get_zid ?>" id="<?php echo $formzid ?>" />
<fieldset>
<legend>Add <?php echo $tablename; ?>Data</legend>
<ul class="form">
<?php
inputText("referraldate","referral date",10,$referraldate);
makeSelect("selfcarelevel","self care level",$selfcarelevel, $selfcarelevel_options);
inputTextarea("selfcarenotes","self care notes",3,60,$selfcarenotes);
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
<li class="submit"><input type="submit" style="color: green;" value="Submit" /></li>
</ul>
</fieldset>
</form>
</body>
</html>