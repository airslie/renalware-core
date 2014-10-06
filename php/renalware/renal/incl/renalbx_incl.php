<?php
if ( $_GET['mode']=='addbx' )
	{
	//insert new bx
	$renalbxdate = $mysqli->real_escape_string($_POST["renalbxdate"]);
	$renalbxresult = $mysqli->real_escape_string($_POST["renalbxresult"]);
	$renalbxdate=fixDate($renalbxdate);
	$sql="INSERT INTO renalbxdata (renalbxdate, renalbxresult, renalbxzid, renalbxstamp, renalbxuser) VALUES ('$renalbxdate', '$renalbxresult', $zid, NOW(), '$user')";
    $result = $mysqli->query($sql);
	echo "<p class=\"alertsmall\">Your biopsy has been recorded!</p>";
	}
//display existing
//select...
$fields="renalbxdate, renalbxresult";
$displaytext='renal biopsies';
$where="WHERE renalbxzid=$zid";
$tables='renalbxdata';
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
		echo '<table class="list">
		    <tr>
			<th>date</th>
			<th>result</th>
			</tr>';
			while ($row = $result->fetch_assoc()) {
				echo '<tr>
				<td>' . dmy($row['renalbxdate']) . '</td>
				<td>' . $row['renalbxresult'] . '</td>
				</tr>';
			}
		echo "</table>";
	}
//add new bx entry form
?>
<form action="renal/renal.php?scr=renalsumm&amp;zid=<?php echo $zid; ?>&amp;mode=addbx" method="post">
<fieldset>
	<legend>Add Renal Biopsy</legend>
	<ul class="form">
    <li><label for="renalbxdate">Biopsy Date</label>&nbsp;&nbsp;<input type="text" id="renalbxdate" name="renalbxdate" size="12" /></li>
    <li><label for="renalbxresult">Biopsy Result</label>&nbsp;&nbsp;<input type="text" id="renalbxresult" name="renalbxresult" size="100" /></li>
    <li class="submit"><input type="submit" style="color: green;" value="add biopsy" /></li>
    </ul>
</fieldset>
</form>