<?php
//----Wed 06 Mar 2013----
$sql= "SELECT * FROM hl7data.pathlogs ORDER BY log_id DESC LIMIT 12";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
	echo "<p class=\"header\">Hourly Path Feed Logs ($numrows displayed).</p>";
	echo "<table class=\"display\"><thead>
	<tr>
	<th>logstamp</th>
	<th>MSH run</th>
	<th>old PIDs</th>
	<th>new PIDs</th>
	<th>Ix run</th>
	<th>OBX run</th>
	</tr></thead><tbody>";
	while ($row = $result->fetch_assoc()) {
		echo '<tr>
		<td>' . $row["logstamp"] . '</td>
		<td>' . $row["msh"] . '</td>
		<td>' . $row["oldpid"] . '</td>
		<td>' . $row["newpid"] . '</td>
		<td>' . $row["ix"] . '</td>
		<td>' . $row["obx"] . '</td>
		</tr>';
		}
echo "</tbody></table>";
