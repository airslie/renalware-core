<?php
//----Mon 25 Feb 2013----cannulation
?>
<form action="renal/run/runupdateprofile.php?zid=<?php echo $zid; ?>" method="post">
<fieldset>
<legend>Update HD Profile for <?php echo $firstnames . ' ' . $lastname; ?></legend>
<ul>
<li><label>Curr site</label> <?php echo $currsite; ?> &nbsp; &nbsp;<a class="ui-state-default" style="color: green;" href="pat/patient.php?vw=modals&amp;zid=<?php echo $zid; ?>">Change HD Site (use Modal/Site Screen)</a></li>
<li>
<label>schedule/slot</label><select name="sched_slot">
<?php
if (!$currschedslot)
	{
	echo '<option value="">Select Sched/Slot</option>';
	}
else
	{
	echo '<option value="' . $currschedslot . '">' . $currschedslot . '</option>';
	}
if ($prefsched && $prefslot) {
	echo '<option value="' . $prefsched .'-'.$prefslot . '">' . $prefsched . '-'.$prefslot . ' --PREF</option>';
	}
echo '<option>MonWedFri-AM</option>
<option>MonWedFri-PM</option>
<option>MonWedFri-Eve</option>
<option>TueThuSat-AM</option>
<option>TueThuSat-PM</option>
<option>TueThuSat-Eve</option>
</select> &nbsp; &nbsp;
<label>Named Nurse</label><select name="namednurse">';
if (!$namednurse)
	{
	echo '<option value="">...</option>';
    } else { echo '<option value="' . $namednurse . '">' . $namednurse . '</option>';
	}
    //get nurses
$sql = "SELECT CONCAT(userlast, ' ', left(userfirst,1)) as nurse FROM userdata WHERE hdnurseflag=1 ORDER BY userlast";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
while($row = $result->fetch_assoc())
    {
        echo '<option>' . $row['nurse'] . "</option>";
    }
echo '</select> &nbsp; &nbsp;<label>hours</label><input type="text" name="hours" value="'.$hours.'" size="4" />
        &nbsp;&nbsp;<label>HD Type</label>
	<select name="hdtype">';
		$optionfield="hdtype";
        if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
        echo '<option>HD</option>
		<option>HDF-PRE</option>
		<option>HDF-POST</option>
		</select></li>';
        ?>
<fieldset><li><label>Needle</label>&nbsp;&nbsp;Size: <input type="text" name="needlesize" value="<?php echo $needlesize; ?>" size="6" />
&nbsp; &nbsp; <label>Single?</label> <input type="radio" name="singleneedle" <?php if($singleneedle=="Y") { echo "checked"; } ?> value="Y" />Y
&nbsp; &nbsp; <input type="radio" name="singleneedle" <?php if($singleneedle=="N") { echo "checked"; } ?> value="N" />N</label>&nbsp;&nbsp;&nbsp; <label>Sodium Profiling</label>
 <input type="radio" name="dialNaProfiling" <?php if($dialNaProfiling=="Y") { echo "checked"; } ?> value="Y" />Yes
&nbsp; &nbsp; <input type="radio" name="dialNaProfiling" <?php if($dialNaProfiling=="N") { echo "checked"; } ?> value="N" />No
&nbsp; &nbsp; <label>Na 1st half</label> <select name="dialNa1sthalf">
<?php
$optionfield="dialNa1sthalf";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
?>
<option value="136">136</option>
<option value="137">137</option>
<option value="138">138</option>
<option value="140">140</option>
<option value="145">145</option>
</select>
&nbsp; &nbsp; <label>Na 2nd half</label>
<select name="dialNa2ndhalf">
<?php
$optionfield="dialNa2ndhalf";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
?>
<option value="136">136</option>
<option value="137">137</option>
<option value="138">138</option>
<option value="140">140</option>
<option value="145">145</option>
</select></li>
<li><label>Additional Rx</label> 
<input type="checkbox" name="esdflag" <?php if($esdflag=="Y") echo "checked"; ?> value="Y" />ESA &nbsp; &nbsp;
<input type="checkbox" name="ironflag" <?php if($ironflag=="Y") echo "checked"; ?> value="Y" />Iron &nbsp; &nbsp;
<input type="checkbox" name="warfarinflag" <?php if($warfarinflag=="Y") echo "checked"; ?> value="Y" />Warfarin</li>
</fieldset>
<fieldset><li><label>Dialyser</label> 
<select name="dialyser">
<?php
$optionfield="dialyser";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
//----Sun 31 Jul 2011----using optionlists tbl now
//include '../optionlists/dialysers.html';
$optionlistname='dialysers';
include '../optionlists/getoptionlist_incl.php';
?>
</select>&nbsp;&nbsp;<label>Dialysate</label> 
<select name="dialysate">
<?php
$optionfield="dialysate";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
?>
<option value="A/7">A/7</option>
<option value="A/10">A/10</option>
<option value="A/17">A/17</option>
<option value="A/27">A/27</option>
</select>
&nbsp; &nbsp; <label>Flow rate</label> <select name="flowrate">
<?php
$optionfield="flowrate";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
?>
<option value="500">500</option>
<option value="700">700</option>
<option value="800">800</option>
</select>&nbsp;&nbsp;<label>Potass (K)</label><select name="dialK">
<?php
$optionfield="dialK";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }

if (!$dialK) { echo '<option value="">...</option>'; } else { echo '<option value="' . $dialK. '">' . $dialK. '</option>'; }
?>
<option value="1" />1</option>
<option value="2" />2</option>
<option value="3" />3</option>
<option value="4" />4</option>
</select>&nbsp; &nbsp; <label>Calcium</label> <select name="dialCa">
<?php
$optionfield="dialCa";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
?>
<option value="1.00">1.00</option>
<option value="1.35">1.35</option>
<option value="1.50">1.50</option>
</select>&nbsp; &nbsp; <label>Temp</label> <select name="dialTemp">
<?php
$optionfield="dialTemp";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
?>
<option value="35.0">35.0</option>
<option value="35.5">35.5</option>
<option value="36.0">36.0</option>
<option value="37.0">37.0</option>
</select>&nbsp;&nbsp;<label>Bicarb</label> <select name="dialBicarb">
<?php
$optionfield="dialBicarb";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
?>
<option value="30">30</option>
<option value="35">35</option>
<option value="40">40</option>
</select>
</li>
</fieldset><fieldset><li><label>Anticoagulant</label> Type:
<select name="anticoagtype">
<?php
$optionfield="anticoagtype";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
?>
<option value="heparin">heparin</option>
<option value="enoxyparin">enoxyparin</option>
<option value="WARFARIN">WARFARIN</option>
<option value="NONE">NONE</option>
</select>
&nbsp; &nbsp; <label>Loading Dose</label> <input type="text" name="anticoagloaddose" value="<?php echo $anticoagloaddose; ?>" size="10" />&nbsp;&nbsp;<label>Hourly Dose</label> <input type="text" name="anticoaghourlydose" value="<?php echo $anticoaghourlydose; ?>" size="10" />&nbsp; &nbsp; 
<label>Stop Time</label> <input type="text" name="anticoagstoptime" value="<?php echo $anticoagstoptime; ?>" size="10" /><br>&nbsp; &nbsp;
<label>Prescriber</label>
<select name="prescriber">
<?php
$optionfield="prescriber";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
	$popcode="userlast";
	$popname="userlast";
	$popwhere="consultantflag=1";
	$poptable="userdata";
	include('../incl/limitedoptions.php');
?>
</select>&nbsp;&nbsp;<label>Prescr Date</label> <input type="text" name="prescriptdate" value="<?php echo $prescriptdate; ?>" size="12" class="datepicker" /></li>
</fieldset><fieldset><li><label>Preferred Site</label> 
	<select name="prefsite">
	<?php
	if ($prefsite)
		{
		echo '<option value="' . $prefsite . '">' . $prefsite . '</option>';
		}
	else
	{
		echo '<option value="">Select preferred site</option>';
	}
	echo $siteoptions;
	?>
</select>
&nbsp;&nbsp;<label>Pref Sched</label>
	<select name="prefsched">
	<?php
	if ($prefsched)
		{
		echo '<option value="' . $prefsched . '">' . $prefsched . '</option>';
		}
	else
	{
		echo '<option value="">Select sched...</option>';
	}
	?>
	<option>MonWedFri</option>
	<option>TueThuSat</option>
</select>
&nbsp;&nbsp;<label>Pref Slot</label>
	<select name="prefslot">
	<?php
	if ($prefslot)
		{
		echo '<option value="' . $prefslot . '">' . $prefslot . '</option>';
		}
	else
	{
		echo '<option value="">Select slot...</option>';
	}
	?>
	<option>AM</option>
	<option>PM</option>
	<option>Eve</option>
</select></li>
<li><label>Date Prefs Entered</label> <input type="text" name="prefdate" value="<?php echo $prefdate; ?>" size="12" class="datepicker"/>&nbsp; &nbsp;
<label>Pref Notes</label> <input type="text" name="prefnotes" value="<?php echo $prefnotes; ?>" size="70" id="prefnotes" /></li>
</fieldset>
<li><label>Cannulation Technique</label>
	<select name="cannulationtype">
	<?php
	if ($cannulationtype)
		{
		echo '<option>' . $cannulationtype . '</option>';
		}
	else
	{
		echo '<option value="">Select type...</option>';
	}
	?>
	<option>Rope Ladder</option>
	<option>Buttonhole</option>
</select>
    
<li><label>Transport</label> <b>NOTE: transport needs are now entered in admin screen and displayed in "renal navbar" above</b></li>
<li class="submit"><input type="submit" style="color: green;" value="Update HD Profile" /></li>
</ul>
</fieldset>
</form>
<form action="renal/run/rundrywtupdate.php" method="post">
<input type="hidden" name="drywtzid" value="<?php echo $zid ?>" id="drywtzid" />
<input type="hidden" name="adduid" value="<?php echo $uid ?>" id="adduid" />
<fieldset>
<legend>Update Dry Weight data for <?php echo $firstnames . ' ' . $lastname; ?></legend>
<ul>
<li><label>Dry Weight</label> <input type="text" name="dryweight" value="" size="5" /> <i>kg</i> &nbsp; &nbsp;
<label>Date Updated</label> <input type="text" name="drywtassessdate" value="<?php echo date('d/m/Y'); ?>" size="12" class="datepicker" /> &nbsp; &nbsp;
<label>Assessor</label> <select name="drywtassessor">
<option value="">Select Assessor...</option>
<?php
	$popwhere="consultantflag=1 OR hdnurseflag=1";
	$poptable="userdata";
	$sql="SELECT CONCAT(userlast, ' ', left(userfirst,1)) as assessor FROM $poptable WHERE $popwhere ORDER BY userlast";
$result = $mysqli->query($sql);
	while($row = $result->fetch_row()) {
	echo '<option value="' . $row['0'] . '">' . $row['0'] . "</option>";
	}
?>
</select></li>
<li class="submit"><input type="submit" style="color: green;" value="Update Dry Weight" /></li>
</ul>
</fieldset>
</form>