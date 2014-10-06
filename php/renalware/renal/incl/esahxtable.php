<?php
//Sun May 10 22:51:21 CEST 2009
$sql= "SELECT drugname, dose, route, freq, DATE_FORMAT(adddate, '%e-%b-%Y') as startdate, DATE_FORMAT(termdate, '%e-%b-%Y') as enddate FROM medsdata WHERE medzid=$zid AND esdflag=1 ORDER BY medsdata_id DESC LIMIT 5";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">ESA History (5 most recent max) </p>";
?>
<table class="list">
<?php
while ($row = $result->fetch_assoc())
	{
	$trclass = (!$row['enddate']) ? "hilite" : "" ;
	echo '<tr class="' . $trclass . '">
	<td align="left" class="ls">' . $row['drugname'] . ' ' . $row['dose'] . ' ' . $row['route'] . ' ' . $row['freq'] . '</td>
	<td><font color="#33CC00">' . $row['startdate'] . '</font></td>
	<td><font color="#ff0000">' . $row['enddate'] . '</font></td>
	</tr>';
	}
?>
</table>