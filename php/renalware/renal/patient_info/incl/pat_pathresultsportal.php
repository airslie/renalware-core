<?php
//----Mon 23 Sep 2013----HGB fix
//Hb, urea, URR, corr calcium, phosphate, PTH, potassium, cholesterol. 
$portallimit=5;
$limit = ($portallimit) ? $portallimit : 10 ;
$fields = "resultsdate,  
CCA,
CRE,
HB,
PHOS,
POT,
URE,
URR";
$sql= "SELECT $fields FROM hl7data.pathol_results WHERE resultspid='$hospno1' ORDER BY resultsdate DESC LIMIT $limit";
$result = $mysqli->query($sql);
echo '<table class="infolist" style="float: none;">
<tr>
<th>date</th>
<th>Ca</th>
<th>HGB</th>
<th>Phos</th>
<th>Potass</th>
<th>Urea</th>
</tr>';
while ($row = $result->fetch_assoc()) {
	if ($row["CCA"] or $row["HB"] or $row["PHOS"] or $row["POT"] or $row["URE"]) {
		echo '<tr><td class="f">' . dmyyyy($row["resultsdate"]) . '</td>
		<td>' . $row["CCA"] . '</td>
		<td>' . 10*$row["HB"] . '</td>
		<td>' . $row["PHOS"] . '</td>
		<td>' . $row["POT"] . '</td>
		<td>' . $row["URE"] . '</td></tr>';
	}
}
echo '</table>';