<?php
//created on 2009-02-16.
//versionstamp 
//display existing
//select...
$fields="txbxdate, txbxresult1, txbxresult2, txbxnotes";
$displaytext='transplant biopsies';
$where="WHERE txbxzid=$zid";
$tables='txbxdata';
$sql="SELECT $fields FROM $tables $where";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext recorded for this patient</p>";
	}
	else
	{
	echo "<p class=\"header\">$numrows $displaytext</p>";
	echo '<table class="list">';
		echo '<tr>
			<th>date</th>
			<th>result1</th>
			<th>result2</th>
			<th colspan="2">notes</th>
			</tr>';
			while ($row = $result->fetch_assoc()) {
				echo '<tr>
				<td>' . dmyyyy($row['txbxdate']) . '</td>
				<td>' . $row['txbxresult1'] . '</td>
				<td>' . $row['txbxresult2'] . '</td>
				<td colspan="2">' . $row['txbxnotes'] . '</td>
				</tr>';
			}
	echo "</table>";
	}
?>