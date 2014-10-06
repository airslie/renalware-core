<?php
//for default date
$showtoday=date("d/m/Y");
?>
<form action="pat/run/add_tcilistpatient.php" method="post">
	<input type="hidden" name="tcilistzid" value="<?php echo $zid ?>" id="tcilistzid" />
	<input type="hidden" name="tcilistmodal" value="<?php echo $modalcode ?>" id="tcilistmodal" />
	<?php if ($get_consult_id): ?>
		<input type="hidden" name="tciconsult_id" value="<?php echo $get_consult_id ?>" id="tciconsult_id" />
	<?php endif ?>
<fieldset>
	<legend>TCI List Information</legend>
	<ul class="form">
    <li><label for="tcireason">TCI Reason</label>&nbsp;
	<select name="tcireason" id="tcireason">
		<option value="">Select Reason...</option>
		<option>AKI</option>
		<option>For Biopsy</option>
		<option>Access</option>
		<option>Transplant Dysfunction</option>
		<option>Crash Lander</option>
		<option value="Other Medical">Other Medical--Specify below</option>
		<option value="Other Social">Other Social--Specify below</option>
	</select></li>
	<li><label for="tcipriority">TCI Priority</label>&nbsp;
	<select name="tcipriority" id="tcipriority">
		<option value="">Select priority...</option>
	<option>URGENT</option>
	<option>High</option>
	<option>Medium</option>
	<option>Low</option>
		</select></li>
	<li><label for="patlocation">Current Location</label>&nbsp;
	<select name="patlocation" id="patlocation">
		<option value="">Select patient location...</option>
	<option>KCH Ward</option>
	<option>QEH Ward</option>
	<option>DVH Ward</option>
	<option>BROM Ward</option>
	<option>Home</option>
	<option>A and E</option>
	<option>Other</option>
	</select></li>
<li><label for="tcinotes">Other/Notes</label><br>
	<input type="text" id="tcinotes" name="tcinotes" size ="100" /></li>
<li class="submit"><input type="submit" style="color: green;" value="add to TCI List" /></li>
</ul>
</fieldset>
</form>