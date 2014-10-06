<?php
//----Wed 11 May 2011----
$orderby = "ORDER BY swabdate DESC";
$fields="mrsa_id,
swabstamp,
resultstamp,
mrsazid,
swabuid,
swabuser,
swabadddate,
swabdate,
swabsite,
resultuser,
resultdate,
swabresult
";
$sql= "SELECT $fields FROM mrsadata WHERE mrsazid=$zid $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ( $numrows >0 )
{
	showInfo("$numrows",'MRSA Swab record(s) found');
	echo "<table class=\"list\">
	<tr>
	<th>swab entered</th>
	<th>swab recorder</th>
	<th>swab date</th>
	<th>swab site</th>
	<th>result recorder</th>
	<th>result date</th>
	<th>result</th>
	<th>options</th>
	</tr>";
	while ($row = $result->fetch_assoc()) {
		$showlink = ($row["swabresult"]) ? "view" : "enter result" ;
		$ajaxlink = '<a class="ui-state-default" style="color: green;" onclick="getMRSA('.$row["mrsa_id"].')">'.$showlink.'</a>';
		echo '<tr>
			<td>' . $row["swabstamp"] . '</td>
			<td>' . $row["swabuser"] . '</td>
			<td>' . dmy($row["swabdate"]) . '</td>
			<td>' . $row["swabsite"] . '</td>
			<td>' . $row["resultuser"] . '</td>
			<td>' . dmy($row["resultdate"]) . '</td>
			<td>' . $row["swabresult"] . '</td>
		<td>' .$ajaxlink . '</td>
		</tr>';
	}
	echo '</table>';
} else {
	makeAlert("&nbsp;&nbsp;","No MRSA swab records were found.");
}
?>