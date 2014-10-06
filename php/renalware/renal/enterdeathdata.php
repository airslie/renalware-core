<?php
//Wed Jun 11 13:45:39 CEST 2008
//if updated
if ($_GET['mode']=="update")
	{
	$deathDate = $mysqli->real_escape_string($_POST["deathDate"]);
	$deathnotes = $mysqli->real_escape_string($_POST["deathnotes"]);
	$deathDate = fixDate($deathDate);	
	$deathCauseEDTA1 = $_POST["deathCauseEDTA1"];
	$deathCauseEDTA2 = $_POST["deathCauseEDTA2"];
	//get death cause text
	if ( $deathCauseEDTA1 )
	{
	$sql= "SELECT edtacause FROM edtadeathcodes WHERE edtacode='$deathCauseEDTA1'";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$deathcausetext1=$row["edtacause"];
	}
	if ( $deathCauseEDTA2 )
	{
	$sql= "SELECT edtacause FROM edtadeathcodes WHERE edtacode='$deathCauseEDTA2'";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$deathcausetext2=$row["edtacause"];
	}
	//update the table
	//nb deathdate no longer in renaldata Tue Mar 21 09:09:44 JST 2006
	$tables = 'renaldata';
	$where = "WHERE renalzid=$zid";
	$updatefields = "deathCauseEDTA1='$deathCauseEDTA1', deathCauseEDTA2='$deathCauseEDTA2', deathCauseText1='$deathcausetext1',  deathCauseText2='$deathcausetext2', deathnotes='$deathnotes'";
	$sql= "UPDATE $tables SET $updatefields $where";
	$result = $mysqli->query($sql);
//log the event
	$eventtype="Patient Renal Death Data entered";
	$eventtext=$mysqli->real_escape_string($updatefields);
	include "$rwarepath/run/logevent.php";
//update patientdata
$tables = 'renalware.patientdata';
$where = "WHERE patzid=$zid";
$updatefields = "deathdate='$deathDate'";
$sql= "UPDATE $tables SET $updatefields $where";
$result = $mysqli->query($sql);
//move to modals page
header("Location: ../renal/renal.php?scr=renalsumm&zid=$zid");
} // end update IF

//refresh data
include('../data/letterpatdata.php');
include "$rwarepath/data/renaldata.php";
//Wed Jun 11 13:30:02 CEST 2008	
//make single edtadeathcodes options
$deathcauseoptions="";
$sql= "SELECT edtacode, edtacause FROM edtadeathcodes";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
while($row = $result->fetch_assoc())
	{
	$deathcauseoptions.='<option value="'.$row["edtacode"].'">'.$row["edtacause"].'</option>'."\r";
	}
$result->close();
//end make options
?>
<form action="renal/renal.php?zid=<?php echo $zid; ?>&amp;scr=enterdeathdata&amp;mode=update" method="post">
<fieldset>
	<legend>Edit Date &amp; Cause of Death</legend>
<b>Note: After submitting these data you can update the modalities page if needed.</b><br>
<ul class="form">
<li><label for="deathdate">deathDate</label><input type="text" name="deathDate" size="12" value="<?php echo $deathdate; ?>" /> <br>
<li><label for="deathCauseEDTA1">EDTA Cause of Death (1)</label><select name="deathCauseEDTA1">
	<?php
	if ( $deathCauseEDTA1 )
	{
	echo "<option value=\"$deathCauseEDTA1\">$deathCauseText1</option>";
	}
	else
	{
	echo "<option value=\"\">Select 1st EDTA Cause of Death</option>";	
	}
	echo "$deathcauseoptions";
	?>
</select></li>
<li><label for="deathCauseEDTA2">EDTA Cause of Death (2)</label><select name="deathCauseEDTA2">
	<?php
	if ( $deathCauseEDTA2 )
	{
	echo "<option value=\"$deathCauseEDTA2\">$deathCauseText2</option>";
	}
	else
	{
	echo "<option value=\"\">Select 2nd EDTA Cause of Death</option>";	
	}
	echo "$deathcauseoptions";
	?>
</select></li>
<li><label for="deathnotes">death notes</label><input type="text" name="deathnotes" size="100" /></li>
<li class="submit"><input type="submit" style="color: green;" value="Update death info" /></li>
</ul>
</fieldset>
</form>