<?php
//--Sat Jun  9 17:28:17 CEST 2012--
$fields = "sampledate, testtype_id, testtype, qualifier, result";
$tables = "hl7data.midasdata";
$where = "WHERE hospno='$hospno1'"; // default
$orderby = "ORDER BY sampledate DESC"; //incl ORDER BY prn
//get all
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $portallimit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows)
	{
	echo "<p class=\"header\">$numtotal MIDAS results ($numrows displayed).</p>";
	echo "<table class=\"list\">
	<tr>
	<th>sampledate</th>
	<th>test type (ID)</th>
	<th>qual</th>
	<th>result</th>
	</tr>";
	while ($row = $result->fetch_assoc()) {
		$trclass = ($row["qualifier"]==">") ? 'hilite' : '' ;
		echo '<tr class="' . $trclass . '">
		<td>' . $row["sampledate"] . '</td>
		<td><b>' . $row["testtype"] . '</b> <i>(' . $row["testtype_id"] . ')</i></td>
		<td>' . $row["qualifier"] . '</td>
		<td>' . $row["result"] . '</td>
		</tr>';
		}
	echo "</table>";
	}
	 else 
	{
	echo "<p class=\"header\">There are no MIDAS results! </p>";
	}
?>