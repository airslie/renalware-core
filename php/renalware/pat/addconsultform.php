<?php
//----Wed 10 Jul 2013----textarea
//----Fri 28 Jun 2013----run/run_ nomenclature change
//for default date
$showtoday=date("d/m/Y");
?>
<form action="pat/run/run_addconsult.php" method="post">
	<input type="hidden" name="consultzid" value="<?php echo $zid ?>" id="consultzid" />
	<input type="hidden" name="consultmodal" value="<?php echo $modalcode ?>" id="consultmodal" />
<fieldset>
	<legend>Consult Information</legend>
	<ul class="form">
    <li><label for="consultsite">Consult Site</label>&nbsp;
	<select name="consultsite" id="consultsite">
		<option value="">Select Site...</option>
		<option>KCH</option>
		<option>QEH</option>
		<option>DVH</option>
		<option>BROM</option>
		<option value="Other">Other--Specify below</option>
	</select></li>
<li><label for="othersite">Other Site</label>&nbsp;<input type="text" id="othersite" name="othersite" size ="20" /></li>
<li><label for="selectward">KCH Ward</label>&nbsp;
<select name="selectward" id="selectward">
	<option value="">Select KCH Ward...</option>
    <?php
    include "$rwarepath/optionlists/consultwardoptionlist.html";
    ?>
	</select></li>
<li><label for="otherward">Other/Non-KCH Ward</label>&nbsp;<input type="text" id="otherward" name="otherward" size ="20" /></li>
<li><label for="sitehospno">Hosp No (Edit if not KCH)</label>&nbsp;<input type="text" id="sitehospno" value="<?php echo $hospno1 ?>" name="sitehospno" size ="20" /></li>
<li><label for="contactbleep">Contact/Bleep Info</label>&nbsp;<input type="text" id="contactbleep" name="contactbleep" size ="20" /></li>
<li><label for="consulttype">Type (e.g. Cardiol)</label>&nbsp;<input type="text" id="consulttype" name="consulttype" size ="20" /></li>
<li><label for="consultdate">consult date</label>&nbsp;<input type="text" id="consultdate" name="consultdate" class="datepicker" value="<?php echo $showtoday ?>" size ="12" /></li>
<li><label for="consultstaffname">Seen by</label>&nbsp;<input type="text" id="consultstaffname" name="consultstaffname" value="<?php echo $user ?>" size ="20" /></li>
<li><label for="consultdescr">consult description</label>&nbsp;<textarea name="consultdescr" id="consultdescr" rows="4" cols="100"></textarea></li>
<li><label for="akiriskflag">AKI Risk (non-ESRF)?</label>&nbsp;<select name="akiriskflag" id="akiriskflag">
	<option value="">Select Y/N/Unknown...</option>
	<option value="Y">Yes (an AKI Episode will be created)</option>
	<option value="N">No</option>
	<option value="U">Unknown</option>
</select></li>
<li><label for="transferdecision">transfer priority</label>&nbsp;<select name="transferdecision" id="transferdecision">
	<option value="">Unknown (Default)</option>
	<option value="Necessary">Necessary</option>
	<option value="Desirable">Desirable</option>
	<option value="Potential">Potential</option>
	<option value="Unnecessary">Unnecessary</option>
</select></li>
<li><label for="decisiondate">decision date</label>&nbsp;<input type="text" id="decisiondate" name="decisiondate" class="datepicker" size ="12" /></li>
<li><label for="transferdate">transfer date</label>&nbsp;<input type="text" id="transferdate" name="transferdate" class="datepicker" size ="12" /></li>
<li class="submit"><input type="submit" class="btn btn-mini btn-success" value="add new consult" /></li>
</ul>
</fieldset>
</form>