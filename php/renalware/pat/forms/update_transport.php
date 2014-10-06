<form action="pat/run/run_updatetransport.php" method="post">
<fieldset>
<legend><?php echo $legend ?></legend>
<input type="hidden" name="patzid" value="<?php echo $zid; ?>" id="patzid" />
<ul>
<li><label>Transport Needs:</label>&nbsp;&nbsp;<input type="radio" name="transportflag" <?php if($transportflag=="Y") { echo 'checked="checked"'; } ?> value="Y" />Y
&nbsp; &nbsp; <input type="radio" name="transportflag" <?php if($transportflag=="N") {echo 'checked="checked"';} ?> value="N" />N</li>
<li><label>Type:</label>&nbsp;&nbsp;<select name="transporttype">
	
	<?php
$optionfield="transporttype";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
	include( '../optionlists/transporttypes.html' );
	?>
	</select></li>
<li><label>Decider</label>&nbsp;&nbsp;	<select name="transportdecider">
	<?php
	$optionfield="transportdecider";
	if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
			$popcode="userlast";
			$popname="userlast";
			$popwhere="transportdeciderflag=1";
			$poptable="userdata";
			include('../incl/limitedoptions.php');
	?>
	</select></li>
<li><label>Updated</label>&nbsp;&nbsp;<input type="text" name="transportdate" value="<?php echo $transportdate; ?>" size="12" /></li>
<li class="submit"><input type="submit" style="color: green;" value="UPDATE INFO" /></li>
</ul>
</fieldset>
</form>