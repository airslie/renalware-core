<?php
$displaytext = "Recent patients updated (20 max listed)"; //default
$sql= "select distinct eventzid, CONCAT(lastname, ', ', firstnames) as patient, hospno1, age, sex, modalcode from renalware.eventlogs JOIN renalware.patientdata ON eventzid=patzid where uid=$uid order by lasteventdate desc limit 20";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	}
else
	{
	echo "<p class=\"header\">$numtotal $displaytext</p>";
	echo "<table class=\"list\">
	<tr><th>KRU No</th>
	<th>patient</th>
	<th>sex age</th>
	<th>modality</th>
	</tr>";
	
	while ($row = $result->fetch_assoc()) {
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["eventzid"] . '">' . $row["patient"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["eventzid"] . '">' . $row["hospno1"] . '</a>';
		echo '<tr>
		<td>' . $adminlink . '</td>
		<td><b>' . $patlink . '</b></td>
		<td>' . $row["sex"] . '&nbsp;'.$row["age"] . '</td>
		<td>' . $row["modalcode"] . '</td>
		</tr>';
		}
	echo '</table>';
	}
?>