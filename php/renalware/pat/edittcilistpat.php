<?php
//for default date
//Sun Dec 20 13:10:33 JST 2009
$showtoday=date("d/m/Y");
$tcilist_id=$get_tcilist_id;
$sql = "SELECT * FROM tcilistdata WHERE tcilist_id=$tcilist_id LIMIT 1";
include "$rwarepath/incl/runparsesinglerow.php";
?>
<form action="pat/run/run_edittcilistpat.php" method="post">
	<input type="hidden" name="tcilistzid" value="<?php echo $zid ?>" id="tcilistzid" />
	<input type="hidden" name="tcilist_id" value="<?php echo $get_tcilist_id ?>" id="tcilist_id" />
<fieldset>
	<legend>Update TCI List Patient</legend>
	<p class="buttonsdiv"><button style="color: red;" onclick="javascript:history.go(-1)">Cancel (go back)</button></p>

<ul class="form">
    <li><label for="tcireason">TCI Reason</label>&nbsp;
	<select name="tcireason" id="tcireason">
		<option><?php echo $tcireason ?></option>
		<option>AKI</option>
		<option>For Biopsy</option>
		<option>Access</option>
		<option>Transplant Dysfunction</option>
		<option>Crash Lander</option>
		<option value="Other Medical">Other Medical--Specify below</option>
		<option value="Other Social">Other Social--Specify below</option>
	</select></li>
	<li><label for="tcilistrank">TCI Rank</label>&nbsp;
		<input type="number" id="tcilistrank" name="tcilistrank" size ="2" /><?php echo $tcilistrank ?></li>
	<li><label for="tcipriority">TCI Priority</label>&nbsp;
	<select name="tcipriority" id="tcipriority">
		<option><?php echo $tcipriority ?></option>
	<option>URGENT</option>
	<option>High</option>
	<option>Medium</option>
	<option>Low</option>
		</select></li>
	<li><label for="patlocation">Current Location</label>&nbsp;
	<select name="patlocation" id="patlocation">
		<option><?php echo $patlocation ?></option>
	<option>KCH Ward</option>
	<option>QEH Ward</option>
	<option>DVH Ward</option>
	<option>BROM Ward</option>
	<option>Home</option>
	<option>A and E</option>
	<option>Other</option>
	</select></li>
<li><label for="tcinotes">Other/Notes</label>&nbsp;
	<input type="text" id="tcinotes" value="<?php echo $tcinotes ?>" name="tcinotes" size ="100" /></li>
<li class="submit"><input type="submit" style="color: green;" value="Update TCI Patient" /></li>
</ul>
</fieldset>
</form>