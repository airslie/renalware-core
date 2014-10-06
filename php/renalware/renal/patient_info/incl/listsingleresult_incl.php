<?php
//----Sat 03 Jul 2010----
$fields = "resultsdate, $thisfield";
$sql= "SELECT $fields FROM hl7data.pathol_results WHERE resultspid='$hospno1' AND $thisfield is not NULL ORDER BY resultsdate DESC LIMIT $showcount";
$result = $mysqli->query($sql);
echo "<table class=\"infolist\"><tr><th>date</th><th>$thislabel</th></tr>";
while ($row = $result->fetch_assoc())
	{
	echo '<tr><td class="f">' . dmyyyy($row["resultsdate"]) . '</td><td>' . $row[$thisfield] . '</td></tr>';
	}
echo "</table>";
