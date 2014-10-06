<?php
//----Wed 11 May 2011----
$orderby = "ORDER BY possdate";
$fields="poss_id,
possstamp,
possuid,
possuser,
posszid,
possadddate,
possdate
";
$sql= "SELECT $fields FROM arc_possdata2 WHERE posszid=$zid $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ( $numrows >0 )
{
	echo "<table class=\"list\">
	<tr>
	<th>ID</th>
	<th>Entered</th>
	<th>User</th>
	<th>Survey Date</th>
	<th>Options</th>
	</tr>";
	while ($row = $result->fetch_assoc()) {
		$viewprint = '<a href="renal/arc/view_possurvey?zid='.$zid.'&amp;poss_id='.$row["poss_id"].'">view/print</a>';
		$viewprint = '<a class="ui-state-default" style="color: green;" onclick="getPOSS('.$row["poss_id"].')">view</a>';
		echo '<tr>
		<td>' . $row["poss_id"] . '</td>
		<td>' . $row["possstamp"] . '</td>
		<td>' . $row["possuser"] . '</td>
		<td>' . dmyyyy($row["possdate"]) . '</td>
		<td>' .$viewprint . '</td>
		</tr>';
	}
	echo '</table>';
}
?>