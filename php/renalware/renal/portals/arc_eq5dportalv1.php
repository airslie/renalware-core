<?php
//----Wed 11 May 2011----
$orderby = "ORDER BY eq5ddate";
$fields="eq5d_id,
eq5dstamp,
eq5duid,
eq5duser,
eq5dzid,
eq5dadddate,
eq5ddate
";
$sql= "SELECT $fields FROM arc_eq5ddata WHERE eq5dzid=$zid $orderby";
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
		$viewprint = '<a class="ui-state-default" style="color: green;" onclick="getEQ5D('.$row["eq5d_id"].')">view</a>';
		echo '<tr>
		<td>' . $row["eq5d_id"] . '</td>
		<td>' . $row["eq5dstamp"] . '</td>
		<td>' . $row["eq5duser"] . '</td>
		<td>' . dmyyyy($row["eq5ddate"]) . '</td>
		<td>' .$viewprint . '</td>
		</tr>';
	}
	echo '</table>';
}
?>