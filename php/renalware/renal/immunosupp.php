<h3>Immunosuppression History</h3>
<b>Note:</b> Update Immunosuppressant drugs in the main <a href="pat/patient.php?vw=editmeds&amp;zid=<?php echo $zid; ?>">Edit Medications screen</a><br>
<table>
<tr>
<th>Immunosuppressant</th>
<th>dose route freq</th>
<th>adddate</th>
<th>termdate</th>
<th>med modal</th>
<th>drugnotes</th>
</tr>
<?php 
$sql= "SELECT medsdata_id, drugname, dose, route, freq, drugnotes, adddate, termdate, medmodal, esdflag, modifstamp FROM medsdata WHERE medzid=$zid AND immunosuppflag=1 ORDER BY medsdata_id DESC";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">Recorded Immunosuppressant History ($numrows prescriptions) </p>";
while ($row = $result->fetch_assoc())
	{
	$class = 'immunosupp'; //flag immunosupps
	if ($row['termdate']!="")
		{
		$class='discont';
		}
	echo '<tr class="' . $class . '">
	<td>' . $row['drugname'] . '</td>
	<td>' . $row['dose'] . ' ' . $row['route'] . ' ' . $row['freq'] . '</td>
	<td class="start">' . dmy($row['adddate']) . ' ' . $row['adduser'] . '</td>
	<td class="term">' . dmy($row['termdate']) . ' '  . $row['termuser'] . '</td>
	<td>' . $row['medmodal'] . '</td>
	<td>' . $row['drugnotes'] . '</td>
	</tr>';
	}
?>
</table>

