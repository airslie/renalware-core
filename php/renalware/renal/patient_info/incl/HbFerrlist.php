<?php
//----Fri 27 Sep 2013----HGB fix applied
$thisfield="HB";
$thisfield2="FER";
$showcount=3;
//------------DO NOT MODIFY BELOW THIS LINE-------------
$fields = "resultsdate, $thisfield, $thisfield2";
$sql= "SELECT $fields FROM hl7data.pathol_results WHERE resultspid='$hospno1' AND $thisfield is not NULL ORDER BY resultsdate DESC LIMIT $showcount";
$result = $mysqli->query($sql);
echo "<table class=\"infolist\">
<tr>
<th>date</th>
<th>HGB</th>
<th>Ferr</th>
</tr>";
while ($row = $result->fetch_assoc()) {
	echo '<tr><td class="f">' . dmyyyy($row["resultsdate"]) . '</td>
	<td>' . $row[$thisfield] . '</td>
	<td>' . 10*$row[HB] . '</td></tr>';
	}
echo "</table>";
