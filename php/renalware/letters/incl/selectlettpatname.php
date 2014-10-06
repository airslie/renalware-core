<?php
	//make lower case
	$findname=strtolower($mysqli->real_escape_string($_GET['patname']));
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
	if (!$result)
		{
		echo "Sorry no such patient was found. Please try again.<br>";
		include('locatelettpat.php');
		}
	else
		{
		echo '<form action="letters/createletter.php" method="get">
			<select name="zid">';
		while ($row = $result->fetch_assoc())
			{
			$zid=$row['patzid'];
			echo '<option value="' . $zid . '">' . $row['lastname'] . ', ' . $row['firstnames'] . ' (' . $row['hospno1'] . ', DOB:' . $row['dob'] . ')</option>';
			}
		echo '</select><input type="submit" style="color: green;" value="Create Letter" /></form>';
		}
?>