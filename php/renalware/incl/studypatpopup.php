<?php
//Mon May 11 15:29:44 CEST 2009
?>
<form action="lists/clinstudieslist.php" method="post">
<input type="hidden" name="mode" value="addstudypat" />
<fieldset>
	<legend>Select desired study patient</legend>
<ul class="form">
<li><label>study</label> <select name="clinstudyzid">
<?php
if ($_POST["patname"])
	{
	//make lower case
	$findname=strtolower($mysqli->real_escape_string($_POST['patname']));
	//find out if firstname entered
	if(strstr($findname,","))
		{
		$lastfirst = explode(",",$findname);
		$ln = $lastfirst[0];
		$fn = $lastfirst[1];
		$sql= "SELECT patzid, lastname, firstnames, hospno1, birthdate FROM patientdata WHERE lower(lastname) LIKE '$ln' AND lower(firstnames) LIKE '$fn%'";
		}
	else //no comma
		{
		$sql= "SELECT patzid, lastname, firstnames, hospno1, birthdate FROM patientdata WHERE lower(lastname) LIKE '$findname%'";
		}
$result = $mysqli->query($sql);
	echo "$sql<br>";
	while($row = $result->fetch_assoc()) {
		$zid=$row['patzid'];
		echo '<option value="' . $zid . '">' . $row['lastname'] . ', ' . $row['firstnames'] . ' (' . $row['hospno1'] . ', DOB:' . $row['dob'] . ')</option>';
		}
	}
?></select></li>
<li><label>clinical study</label> <select name="studyid">
<?php
echo '<option value="">Select study...</option>';
$popcode="study_id";
$popname="studyname";
$poptable="clinstudylist";
include('../incl/simpleoptions.php');
?>
</select></li>
<li><label>enrollment date</label><input type="text" size="10" name="patadddate" value="<?php echo date("d/m/Y") ?>" /></li>
</ul>
</fieldset>
<input type="submit" style="color: green;" value="Add patient to study" />
</form>
