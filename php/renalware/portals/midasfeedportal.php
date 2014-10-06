<?php
//----Wed 11 Dec 2013----tweaks
//--Tue Dec  3 12:50:33 GMT 2013--
$tables = "hl7data.midasfeeddata";
$where = "WHERE kchno='$hospno1' AND obx_resultvalue !=''"; // default
$orderby = "ORDER BY midas_id DESC"; //incl ORDER BY prn
//get all
$sql= "SELECT * FROM $tables $where $orderby LIMIT $portallimit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows)
	{
	echo "<p class=\"header\">$numtotal MIDAS results (max $numrows displayed).</p>";
	echo "<table class=\"list\">
	<tr>
	<th>Test Date Time</th>
	<th>test type</th>
	<th>result</th>
	<th>Date Sample Taken, notes</th>
	</tr>";
	while ($row = $result->fetch_assoc()) {
        $notes=str_replace("Date Sample Taken:",'',$row["nte_notes"]);
        $units=htmlentities($row["obx_resultunits"]);
		echo '<tr>
		<td>' . $row["obr_obsdatetime"] . '</td>
		<td><b>' . $row["obr_testtype"] . '</b></td>
		<td>' . $row["obx_resultvalue"] . ' '.$units .'</td>
		<td>' . $notes . '</td>
		</tr>';
		}
	echo "</table>";
	} else {
	echo "<p class=\"header\">There are no MIDAS results! </p>";
	}
