<?php
	//make lower case
	$findno=strtolower($mysqli->real_escape_string($_GET['hospno']));
	$sql= "SELECT patzid, lastname, firstnames, hospno1, birthdate FROM patientdata WHERE lower(hospno1)= '$findno'";
$result = $mysqli->query($sql);
	if (!$result)
		{
		echo "Sorry no such patient was found. Please try again.<br>";
		include('locatedischpat.php');
		}
	else
		{
		echo '<form action="letters/createdischarge.php" method="get">
			<select name="zid">';
		while ($row = $result->fetch_assoc())
			{
			$zid=$row['patzid'];
			echo '<option value="' . $zid . '">' . $row['lastname'] . ', ' . $row['firstnames'] . ' (' . $row['hospno1'] . ', DOB:' . $row['dob'] . ')</option>';
			}
		echo '</select><input type="submit" style="color: green;" value="Create Discharge Summ/Death Notif" /></form>';
		}
?>