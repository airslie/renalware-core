<?php
//----Sun 03 Aug 2014----pathol EGFR
echo '<table class="infolist"><tr>
<th>date</th>
<th>CRE</th>
<th>eGFR</th>
<th>Urea</th>
</tr>';
$fields = "resultsdate, CRE, URE, EGFR";
$sql= "SELECT $fields FROM hl7data.pathol_results WHERE resultspid='$hospno1' AND CRE is not NULL ORDER BY resultsdate DESC LIMIT 5";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc()) {
	echo '<tr><td class="f">' . dmyyyy($row["resultsdate"]) . '</td>
		<td>' . $row["CRE"] . '</td>
		<td>' . $row["EGFR"] . '</td>
		<td>' . $row["URE"] . '</td></tr>';
}
echo "</table>";
