<?php
//----Sun 08 Dec 2013----machine URR, KTV
//----Mon 25 Feb 2013----accesssitestatus
//updated Mon Jul 20 11:01:57 BST 2009 dressingchangeflag
?>
<fieldset>
<legend>Add new HD Session for <?php echo $firstnames . ' ' . $lastname; ?></legend>
<ul class="form">
<li><label>session date</label>&nbsp;&nbsp;<input type="text" size="10" name="hdsessdate" value="<?php echo date("d/m/Y") ?>" class="datepicker" /></li>
<li><label>session site</label>&nbsp;&nbsp;<select name="sitecode">
<?php
if (!$modalsite)
	{
	echo '<option value="">Select site...</option>';
	}
else
	{
	echo '<option value="' . $modalsite. '">' . $modalsite. '</option>';
	}
?>
<?php
$popcode="sitecode";
$popname="sitename";
$popwhere="mainsitecode='$sitecode'";
$poptable="sitelist";
include('../incl/simpleoptions.php');
?>
</select></li>
<li><label>session access</label>&nbsp;&nbsp;<select name="access">
<?php
if (!$accessCurrent)
	{
	echo '<option value="">Select access...</option>';
	}
else
	{
	echo '<option value="' . $accessCurrent. '">' . $accessCurrent. '</option>';
	}
include '../optionlists/accesstypes.html';
?>
</select></li>
<li><label>Session time</label>&nbsp;&nbsp;<input type="text" name="timeon" title="time on" value="<?php echo $timeon; ?>" size="8" />&nbsp;&nbsp;<input type="text" name="timeoff" title="time off" value="<?php echo $timeoff; ?>" size="8" /></li>
<li><label>Weight</label>&nbsp;&nbsp;<input type="text" name="wt_pre" title="pre" value="<?php echo $wt_pre; ?>" size="6" />&nbsp;&nbsp;<input type="text" name="wt_post" title="post" value="<?php echo $wt_post; ?>" size="6" /></li>
<li><label>Pulse</label>&nbsp;&nbsp;<input type="text" name="pulse_pre" title="pre" value="<?php echo $pulse_pre; ?>" size="6" />&nbsp;&nbsp;<input type="text" name="pulse_post" title="post" value="<?php echo $pulse_post; ?>" size="6" /></li>
<li><label>Blood Pressure</label>&nbsp;&nbsp;<input type="text" name="syst_pre" title="pre" value="<?php echo $syst_pre; ?>" size="3" />/<input type="text" name="diast_pre" title="pre" value="<?php echo $diast_pre; ?>" size="3" />&nbsp;&nbsp;<input type="text" name="syst_post" title="post" value="<?php echo $syst_post; ?>" size="4" />/<input type="text" name="diast_post" title="post" value="<?php echo $diast_post; ?>" size="4" /></li>
<li><label>Temp (C)</label>&nbsp;&nbsp;<input type="text" name="temp_pre" title="pre" value="<?php echo $temp_pre; ?>" size="6" />&nbsp;&nbsp;<input type="text" name="temp_post" title="post" value="<?php echo $temp_post; ?>" size="6" /></li>
<li><label>BM</label>&nbsp;&nbsp;<input type="text" name="BM_pre" title="pre" value="<?php echo $BM_pre; ?>" size="6" />&nbsp;&nbsp;<input type="text" name="BM_post" title="post" value="<?php echo $BM_post; ?>" size="6" /></li>
<li><label>AP</label>&nbsp;&nbsp;<input type="text" name="AP" value="<?php echo $AP; ?>" size="6" /></li>
<li><label>VP</label>&nbsp;&nbsp;<input type="text" name="VP" value="<?php echo $VP; ?>" size="6" /></li>
<li><label>fluid removal</label>&nbsp;&nbsp;<input type="text" name="fluidremoved" value="<?php echo $fluidremoved; ?>" size="4" /></li>
<li><label>blood flow</label>&nbsp;&nbsp;<input type="text" name="bloodflow" value="<?php echo $bloodflow; ?>" size="6" /></li>
<li><label>UFR</label>&nbsp;&nbsp;<input type="text" name="UFR" value="<?php echo $UFR; ?>" size="6" /></li>
<li><label>machine URR</label>&nbsp;&nbsp;<input type="text" name="machineURR" value="<?php echo $machineURR; ?>" size="6" /></li>
<li><label>machine Kt/V</label>&nbsp;&nbsp;<input type="text" name="machineKTV" value="<?php echo $machineKTV; ?>" size="6" /></li>
<li><label>machine No</label>&nbsp;&nbsp;<input type="text" name="machineNo" value="<?php echo $machineNo; ?>" size="6" /></li>
<li><label>Litres processed</label>&nbsp;&nbsp;<input type="text" name="litresproc" value="<?php echo $litresproc; ?>" size="6" /></li>
<li><label>Access -- First Use?</label>&nbsp;&nbsp;<input type="checkbox" name="firstuseflag" value="1" />Yes</li>
<li><label>Dressing changed?</label>&nbsp;&nbsp;<input type="checkbox" name="dressingchangeflag" value="1" />Yes</li>
<li><label>MRSA swab?</label>&nbsp;&nbsp;<input type="checkbox" name="mrsaswabflag" value="1" />Yes</li>
<li><label>Access Site Inspection</label>&nbsp;&nbsp;<select name="accesssitestatus">
    <option value="">Select...</option>
<?php
include '../optionlists/accesssitestatus_options.html';
?>
</select></li>
<?php if ($hdtype!="HD"): ?>
	<li><label>HDF: Subs Fluid %</label>&nbsp;&nbsp;<input type="text" name="subsfluidpct" value="<?php echo $subsfluidpct; ?>" size="6" /></li>
	<li><label>HDF: Subs Vol</label>&nbsp;&nbsp;<input type="text" name="subsvol" value="<?php echo $subsvol; ?>" size="6" /></li>
	<li><label>HDF: Subs Rate</label>&nbsp;&nbsp;<input type="text" name="subsrate" value="<?php echo $subsrate; ?>" size="6" /></li>
	<li><label>HDF: Subs Goal</label>&nbsp;&nbsp;<input type="text" name="subsgoal" value="<?php echo $subsgoal; ?>" size="6" /></li>
<?php endif ?>
<li><label>eval/notes</label><br>
<textarea name="evaluation" rows="3" cols="60">
<?php echo $evaluation; ?></textarea>
<li><label>Sign On/Off</label>&nbsp;&nbsp;<input type="text" name="signon" title="sign on" value="<?php echo $signon; ?>" size="7" />&nbsp;&nbsp;<input type="text" name="signoff" title="sign off" value="<?php echo $signoff; ?>" size="7" /></li>
<li class="submit"><input type="submit" style="color: green;" value="add new session for <?php echo $firstnames . ' ' . $lastname; ?>"/> or <a class="ui-state-default" style="color: red;" onclick='$("#hdsessionform").toggle();' />cancel</a>
</li></ul>
</fieldset>