<?php
//----Wed 11 May 2011----2012-03-12
$orderby = "ORDER BY eq5ddate DESC";
$fields="eq5d_id,
eq5dstamp,
eq5duid,
eq5duser,
eq5dzid,
eq5dadddate,
eq5ddate,
eq5ddate,
mobility,
selfcare,
activities,
pain_discomfort,
anxiety_depress,
healthstate
";
$limit = ($latestflag) ? "LIMIT 1" : "" ;
$sql= "SELECT $fields FROM arc_eq5ddata WHERE eq5dzid=$zid $orderby $limit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ( $numrows)
{
	echo "<table class=\"list\">
	<tr>
	<th>Date</th>
	<th>Mobility</th>
	<th>Self-Care</th>
	<th>Usual Activities</th>
	<th>Pain/Discomfort</th>
	<th>Anxiety/Depressn</th>
	<th>Health State</th>
	<th>Entered</th>
	<th>User</th>
	</tr>";
	while ($row = $result->fetch_assoc()) {
		//$viewprint = '<a class="ui-state-default" style="color: green;" onclick="getEQ5D('.$row["eq5d_id"].')">view</a>';
		echo '<tr>
		<td>' . dmyyyy($row["eq5ddate"]) . '</td>
		<td>' . $row["mobility"] . '</td>
		<td>' . $row["selfcare"] . '</td>
		<td>' . $row["activities"] . '</td>
		<td>' . $row["pain_discomfort"] . '</td>
		<td>' . $row["anxiety_depress"] . '</td>
		<td>' . $row["healthstate"] . '</td>
		<td>' . $row["eq5dstamp"] . '</td>
		<td>' . $row["eq5duser"] . '</td>
		</tr>';
	}
	echo '</table>';
} else {
	echo '<p><i>No records found.</i></p>';
}
