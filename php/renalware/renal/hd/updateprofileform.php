<?php
//----Mon 23 Sep 2013----fixes & fieldset simplification
//----Fri 05 Jul 2013----uses optionlist/ config now for most popups
//----Mon 25 Feb 2013----cannulation
require '../optionlists/hdprofile_options.php';
echo '<form action="renal/run/runupdateprofile.php?zid=' . $zid. '" method="post">
<fieldset style="width: auto;">
<legend>Update HD Profile for ' . $firstnames . ' ' . $lastname .'</legend>
<ul>
<li><label>Curr site</label> ' . $currsite . ' &nbsp; &nbsp;<a class="btn btn-mini" href="pat/patient.php?vw=modals&amp;zid=' . $zid. '">Change HD Site (use Modal/Site Screen)</a></li>
<li>
<label>schedule/slot</label><select name="sched_slot">';
if (!$currschedslot) {
	echo '<option value="">Select Sched/Slot</option>';
} else {
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
echo '</select> &nbsp; &nbsp;<label>hours (HH:MM)</label>';
//----Wed 26 Feb 2014----new HH:MM popup
$mm=array('00','15','30','45');
$hours_options='';
for ($h=1; $h < 6; $h++) { 
    foreach ($mm as $mins) {
        $hours_options.="<option>$h:$mins</option>";
    }
}
echo '<select name="hours">';
$optionfield="hours";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option>' . ${$optionfield}. '</option>'; }
echo ${$optionfield.'_options'};
echo '</select>
&nbsp;&nbsp;<label>HD Type</label>
<select name="hdtype">';
$optionfield="hdtype";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
echo ${$optionfield.'_options'};
echo '</select></li>
<li><label>Needle</label>&nbsp;&nbsp;Size: <input type="text" name="needlesize" value="' . $needlesize. '" size="6" />';
?>
&nbsp; &nbsp; 
<label>Single?</label> <input type="radio" name="singleneedle" <?php if($singleneedle=="Y") { echo "checked"; } ?> value="Y" />Y
&nbsp; &nbsp; <input type="radio" name="singleneedle" <?php if($singleneedle=="N") { echo "checked"; } ?> value="N" />N</label>&nbsp;&nbsp;&nbsp; 
<label>Sodium Profiling</label> <input type="radio" name="dialNaProfiling" <?php if($dialNaProfiling=="Y") { echo "checked"; } ?> value="Y" />Yes
&nbsp; &nbsp; <input type="radio" name="dialNaProfiling" <?php if($dialNaProfiling=="N") { echo "checked"; } ?> value="N" />No
&nbsp; &nbsp; 
<?php
echo '<label>Na 1st half</label> <select name="dialNa1sthalf">';
$optionfield="dialNa1sthalf";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
echo ${$optionfield.'_options'};
echo '</select>
&nbsp; &nbsp; <label>Na 2nd half</label>
<select name="dialNa2ndhalf">';
$optionfield="dialNa2ndhalf";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
echo ${$optionfield.'_options'};
echo '</select>
</li>';
?>
<li><label>Additional Rx</label> 
<input type="checkbox" name="esdflag" <?php if($esdflag =="Y") { echo "checked"; } ?> value="Y" />ESA &nbsp; &nbsp;
<input type="checkbox" name="ironflag" <?php if($ironflag=="Y") { echo "checked"; } ?> value="Y" />Iron &nbsp; &nbsp;
<input type="checkbox" name="warfarinflag" <?php if($warfarinflag=="Y") { echo "checked"; } ?> value="Y" />Warfarin</li>
    <li><label>Dialyser</label> 
<select name="dialyser">
<?php
$optionfield="dialyser";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
//----Sun 31 Jul 2011----using optionlists tbl now
$optionlistname='dialysers';
include '../optionlists/getoptionlist_incl.php';
echo '</select>&nbsp;&nbsp;<label>Dialysate</label> 
<select name="dialysate">';
$optionfield="dialysate";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
echo ${$optionfield.'_options'};
echo '</select>
&nbsp; &nbsp; <label>Flow rate</label> <select name="flowrate">';
$optionfield="flowrate";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
echo ${$optionfield.'_options'};
echo '</select>
&nbsp;&nbsp;<label>Potass (K)</label><select name="dialK">';
$optionfield="dialK";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
echo ${$optionfield.'_options'};
echo '</select>
&nbsp; &nbsp; <label>Calcium</label> <select name="dialCa">';
$optionfield="dialCa";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
echo ${$optionfield.'_options'};
echo '</select>
&nbsp; &nbsp; <label>Temp</label> <select name="dialTemp">';
$optionfield="dialTemp";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
echo ${$optionfield.'_options'};
echo '</select>
&nbsp;&nbsp;<label>Bicarb</label> <select name="dialBicarb">';
$optionfield="dialBicarb";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
echo ${$optionfield.'_options'};
echo '</select>
</li>
<li>
<label>Anticoagulant</label> Type:
<select name="anticoagtype">';
$optionfield="anticoagtype";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
echo ${$optionfield.'_options'};
echo '</select>
&nbsp; &nbsp; <label>Loading Dose</label> <input type="text" name="anticoagloaddose" value="' . $anticoagloaddose. '" size="10" />&nbsp;&nbsp;
<label>Hourly Dose</label> <input type="text" name="anticoaghourlydose" value="' . $anticoaghourlydose. '" size="10" />&nbsp; &nbsp; 
<label>Stop Time</label> <input type="text" name="anticoagstoptime" value="' . $anticoagstoptime. '" size="10" /></li>
<li><label>Anticoagulant Prescriber</label>
<select name="prescriber">';
$optionfield="prescriber";
if (!${$optionfield}) { echo '<option value="">...</option>'; } else { echo '<option value="' . ${$optionfield}. '">' . ${$optionfield}. '</option>'; }
	$popcode="userlast";
	$popname="userlast";
	$popwhere="consultantflag=1";
	$poptable="userdata";
	include('../incl/limitedoptions.php');
echo '</select>&nbsp;&nbsp;<label>Prescr Date</label> <input type="text" name="prescriptdate" value="' . $prescriptdate. '" size="12" class="datepicker" /></li>
<li><label>Preferred Site</label> 
<select name="prefsite">';
if ($prefsite) {
	echo '<option value="' . $prefsite . '">' . $prefsite . '</option>';
} else {
	echo '<option value="">Select preferred site</option>';
}
echo $siteoptions;
echo '</select>
&nbsp;&nbsp;<label>Pref Sched</label>
	<select name="prefsched">';
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
    echo '<option>AM</option>
	<option>PM</option>
	<option>Eve</option>
</select></li>
<li><label>Date Prefs Entered</label> <input type="text" name="prefdate" value="' . $prefdate. '" size="12" class="datepicker"/>&nbsp; &nbsp;
<label>Pref Notes</label> <input type="text" name="prefnotes" value="' . $prefnotes. '" size="70" id="prefnotes" /></li>
<li><label>Cannulation Technique</label>
<select name="cannulationtype">';
if ($cannulationtype){
	echo '<option>' . $cannulationtype . '</option>';
} else {
	echo '<option value="">Select type...</option>';
}
echo $cannulationtype_options;
echo '</select></li>
<li><label>Transport</label> <b>NOTE: transport needs are now entered in admin screen and displayed in "renal navbar" above</b></li>
<li class="submit"><input type="submit" style="color: green" value="Update HD Profile" /></li>
</ul>
</fieldset>
</form>
<form action="renal/run/rundrywtupdate.php" method="post">
<input type="hidden" name="drywtzid" value="' . $zid .'" id="drywtzid" />
<input type="hidden" name="adduid" value="' . $uid .'" id="adduid" />
<fieldset style="width: auto;">
<legend>Update Dry Weight data for ' . $firstnames . ' ' . $lastname . '</legend>
<ul>
<li><label>Dry Weight</label> <input type="text" name="dryweight" value="" size="5" /> <i>kg</i> &nbsp; &nbsp;
<label>Date Updated</label> <input type="text" name="drywtassessdate" value="' . date('d/m/Y'). '" size="12" class="datepicker" /> &nbsp; &nbsp;
<label>Assessor</label> <select name="drywtassessor">
<option value="">Select Assessor...</option>';
$popwhere="consultantflag=1 OR hdnurseflag=1";
$poptable="userdata";
$sql="SELECT CONCAT(userlast, ' ', left(userfirst,1)) as assessor FROM $poptable WHERE $popwhere ORDER BY userlast";
$result = $mysqli->query($sql);
while($row = $result->fetch_row()) 
    {
	echo '<option value="' . $row['0'] . '">' . $row['0'] . "</option>";
	}
echo '</select></li>
<li class="submit"><input type="submit" style="color: green" value="Update Dry Weight" /></li>
</ul>
</fieldset>
</form>';
