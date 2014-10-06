<table class="infolist">
<tr>
	<th>date</th>
	<th>BP</th>
	<th>Wt (kg)</th>
	<th>BMI</th>
</tr>
<?php
$sql= "SELECT bpwtdate, bpsyst, bpdiast, weight, BMI FROM bpwtdata WHERE bpwtzid=$zid ORDER BY bpwtdate DESC LIMIT 3";
$result = $mysqli->query($sql);
	while ($row = $result->fetch_assoc()) {
		$bp = ($row["bpsyst"]>0 && $row["bpdiast"]>0) ? $row["bpsyst"] . '/' . $row["bpdiast"] : '&nbsp;' ;
		$wt = ($row["weight"]>0) ? $row["weight"] : '&nbsp;' ;
		echo '<tr><td class="f">' . dmyyyy($row["bpwtdate"]) . "</td>
			<td>$bp</td>
			<td>$wt</td>
			<td>" . $row["BMI"] . '</td></tr>';
		}
?>
</table>