<?php
//----Wed 10 Jul 2013----textarea for descr
//----Fri 28 Jun 2013----akirisk
//for default date
//Sun Dec 20 13:10:33 JST 2009
$showtoday=date("d/m/Y");
$consult_id=$get_consult_id;
$sql = "SELECT * FROM consultdata WHERE consult_id=$consult_id LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
?>
<form action="pat/run/run_editconsult.php" method="post">
	<input type="hidden" name="consultzid" value="<?php echo $zid ?>" id="consultzid" />
	<input type="hidden" name="consult_id" value="<?php echo $get_consult_id ?>" id="consult_id" />
<fieldset>
	<legend>Update Consult</legend>
	<p class="buttonsdiv"><button class="btn btn-mini btn-danger" onclick="history.go(-1)">Cancel</button></p>
<ul class="form">
	<li><label for="consultsite">Consult Site REQUIRED</label>&nbsp;
	<select name="consultsite" id="consultsite">
		<option><?php echo $consultsite ?></option>
		<option>KCH</option>
		<option>QEH</option>
		<option>DVH</option>
		<option>BROM</option>
		<option>GUYS</option>
	</select></li>
<li><label for="consultward">Consult Ward</label>&nbsp;<input type="text" id="consultward" value="<?php echo $consultward ?>" name="consultward" size ="30" /></li>
<?php if ($consultsite != 'KCH'): ?>
    <li><label for="sitehospno">Non-KCH Hosp No</label>&nbsp;<input type="text" id="sitehospno" value="<?php echo $sitehospno ?>" name="sitehospno" size ="20" /></li>
<?php else: ?>
    <li><label for="sitehospno">KCH Hosp No</label>&nbsp;<?php echo $hospno1 ?> &nbsp;&nbsp;<i>(Cannot be edited here; use Admin screen)</i></li>
    <input type="hidden" name="sitehospno" value="<?php echo $hospno1 ?>" id="sitehospno">
<?php endif ?>

<li><label for="contactbleep">Contact/Bleep Info</label>&nbsp;<input type="text" id="contactbleep" name="contactbleep" value="<?php echo $contactbleep ?>" size ="20" /></li>
<li><label for="consulttype">Type (e.g. Cardiol)</label>&nbsp;<input type="text" id="consulttype" name="consulttype" value="<?php echo $consulttype ?>" size ="20" /></li>
<li><label for="consultdescr">consult description</label>&nbsp;<textarea name="consultdescr" id="consultdescr" rows="3" cols="100"><?php echo $consultdescr ?></textarea></li>
<li><label for="akiriskflag">AKI Risk (non-ESRF)?</label>&nbsp;<select name="akiriskflag" id="akiriskflag">
	<?php if ($akiriskflag): ?>
		<option><?php echo $akiriskflag ?></option>
	<?php else: ?>
    	<option value="">Select Y/N/Unknown...</option>
	<?php endif ?>
	<option value="Y">Yes</option>
	<option value="N">No</option>
	<option value="U">Unknown</option>
</select></li>
<li><label for="transferpriority">transfer priority</label>&nbsp;<select name="transferpriority" id="transferpriority">
	<?php if ($transferpriority): ?>
		<option><?php echo $transferpriority ?></option>
	<?php else: ?>
		<option value="">Unknown</option>
	<?php endif ?>
	<option value="Necessary">Necessary</option>
	<option value="Desirable">Desirable</option>
	<option value="Potential">Potential</option>
	<option value="Unnecessary">Unnecessary</option>
</select></li>
<li><label for="decisiondate">decision date</label>&nbsp;<input type="text" id="decisiondate" name="decisiondate" class="datepicker" value="<?php echo $decisiondate ?>" size ="12" /></li>
<li><label for="transferdate">transfer date</label>&nbsp;<input type="text" id="transferdate" name="transferdate" class="datepicker" value="<?php echo $transferdate ?>" size ="12" /></li>
<li class="submit"><input type="submit" class="btn btn-mini btn-success" value="Update Data" /></li>
</ul>
</fieldset>
</form>