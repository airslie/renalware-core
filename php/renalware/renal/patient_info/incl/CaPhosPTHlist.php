<?php
$thisfield="CCA";
$thisfield2="PHOS";
$thisfield3="PTHI";
$showcount=3;
//------------DO NOT MODIFY BELOW THIS LINE-------------
$fields = "resultsdate, $thisfield, $thisfield2, $thisfield3";
$sql= "SELECT $fields FROM hl7data.pathol_results WHERE resultspid='$hospno1' AND $thisfield is not NULL ORDER BY resultsdate DESC LIMIT $showcount";
$result = $mysqli->query($sql);
	echo "<table class=\"infolist\">
	<tr>
	<th>date</th>
	<th>Ca</th>
	<th>Phos</th>
	<th>PTH</th>
	</tr>";
	while ($row = $result->fetch_assoc()) {
		echo '<tr><td class="f">' . dmyyyy($row["resultsdate"]) . '</td>
		<td>' . $row[$thisfield] . '</td>
		<td>' . $row[$thisfield2] . '</td>
		<td>' . $row[$thisfield3] . '</td></tr>';
		}
echo "</table>";
