<?php
//----Mon 23 Sep 2013----fix for HB to HGB
$fields="resultsdate,HB";
$symbls=array('*','^');
foreach($pathfieldslist as $key => $value) {
	$fields.=",$value";
}
//remove * and ^
$fields=str_replace($symbls,"",$fields);
$limit = ($limitno) ? "LIMIT $limitno" : "" ;
$sql = "SELECT $fields FROM hl7data.pathol_results WHERE resultspid='$pid' ORDER BY resultsdate DESC $limit";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"headergray\">There are no recorded results in the system for this patient!</p>";
	}
else
	{
	echo "<p class=\"header\">$numrows $resultsheader results displayed (Max $limitno). Click on headers to sort; hover over column header abbreviation for investigation name</p>";
	echo "<table class=\"tablesorter\"><thead>
	<tr><th>date</th>
    <th>HGB</th>"; //HGB fix
	foreach($pathfieldslist as $key => $value) {
        $pathfld = str_replace($symbls,"",$value);
		echo '<th><a title="'.$obxcodelist[$pathfld].'">'.$pathfld.'</a></th>';
	}
	echo "</tr></thead><tbody>";
while($row = $result->fetch_assoc())
	{
		echo '<tr class="" onMouseOver="this.className=\'hi\'" onMouseOut="this.className=\'n\'">
		<td class="b">' . dmyyyy($row["resultsdate"]) . '</td>
		<td class="hb">' . 10*$row["HB"] . '</td>'; //HGB fix
		foreach ($pathfieldslist as $key => $value) {
			$pathfld=str_replace($symbls,"",$value);
			$tdclass = (strpos($value,"*")) ? ' class="hb"' : '' ;
			echo '<td'.$tdclass.'>'.$row["$pathfld"] .'</td>';
		    }
		echo '</tr>';
		}
		echo "</tbody></table>";
	}
