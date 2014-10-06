<?php
//----Wed 06 Mar 2013----
/*
    TODO is this still in use?
*/
//----Tue 22 Jun 2010----
$sql= "SELECT * FROM renalware.eprlogs ORDER BY log_id DESC LIMIT 12";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">Hourly Letters-to-EPR Logs ($numrows displayed).</p>";
echo "<table class=\"display\"><thead>
<tr>
<th>logstamp</th>
<th>Clinic</th>
<th>Discharge</th>
<th>General</th>
</tr></thead><tbody>";
while ($row = $result->fetch_assoc()) {
	echo '<tr>
	<td>' . $row["logstamp"] . '</td>
	<td>' . $row["clinic"] . '</td>
	<td>' . $row["discharge"] . '</td>
	<td>' . $row["general"] . '</td>
	</tr>';
	}
echo "</tbody></table>";
