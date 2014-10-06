<?php
//Tue Aug  4 14:47:53 JST 2009
?>
<form action="renal/run/update_advdirective.php" method="post">
    <input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid1" />
<fieldset>
	<legend>Advanced Directive</legend>
	<br>
	<span class="alertsmall">IMPORTANT: Please keep the Advanced Directive summary information concise as it appears in the top renal navigation bar. (Max 250 chars)</span>
	<ul class="form">
<?php
$lastingpowertype_options = array(
	"Personal Welfare"=>'Personal Welfare',
	"Financial"=>'Financial',
	"Both"=>'Both',
	);
$flag_options=array(
	'Y'=>'Yes',
	'N'=>'No'
	);
inputText("advancedirdate","Adv Dir date",10,$advancedirdate);
inputText("advancedirsumm","AD Summary",70,$advancedirsumm);
inputTextarea("advancedirtext", "Adv Dir Info", 5, 70, $advancedirtext);
inputText("advancedirlocation","Location of Docs",70,$advancedirlocation);
inputText("advancedirstaff","Updated by",30,$advancedirstaff);
?>
<li class="submit"><input type="submit" style="color: green;" value="Update Adv Directive Info" /></li>
</ul>
</fieldset>
</form>
<form action="renal/run/update_lastingpower.php" method="post">
    <input type="hidden" name="zid" value="<?php echo $zid ?>" id="zid2" />
<fieldset>
	<legend>Lasting Power of Attorney Info</legend>
	<ul class="form">
<?php
$lastingpowertype_options = array(
	"Personal Welfare"=>'Personal Welfare',
	"Financial"=>'Financial',
	"Both"=>'Both',
	);
$flag_options=array(
	'Y'=>'Yes',
	'N'=>'No'
	);
inputText("lastingpowerdate","LPA date",10,$lastingpowerdate);
makeSelect("lastingpowertype1","LPA (1) type",$lastingpowertype1,$lastingpowertype_options);
inputTextarea("lastingpowertext1", "LPA (1) info", 5, 70, $lastingpowertext1);
makeSelect("lastingpowertype2","LPA (2) type",$lastingpowertype2,$lastingpowertype_options);
inputTextarea("lastingpowertext2", "LPA (2) info", 5, 70, $lastingpowertext2);
inputText("lastingpowerstaff","Updated by",30,$lastingpowerstaff);
?>
<li class="submit"><input type="submit" style="color: green;" value="Update Lasting Power Info" /></li>
</ul>
</fieldset>
</form>