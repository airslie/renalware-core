<td valign="top">
	<p class="header">APD Treatment data <a class="btn" href="renal/forms/apdrxdataform.php?zid=<?php echo $zid ?>">add/update</a></p>
	<ul class="portal">
	<?php
	$table="apdrxdata";
	include 'maps/'.$table.'.php';
	$fields="adddate, therapytype, totalvol, dextrose, calcium, therapytime, fillvolume, lastfill, extraneal, ph, no_cycles, optichoice, avgdwelltime, initdrainalarm, signature";
	$where="WHERE apdrxzid=$zid";
	$orderby="ORDER BY addstamp DESC";
	$limit="LIMIT 1";
	$sql = "SELECT $fields FROM $table $where $orderby $limit";
	$result = $mysqli->query($sql);
	$numrows=$result->num_rows;
	if ($numrows) {
		$row = $result->fetch_assoc();
		foreach($row AS $key => $value)
			{
			$label=${$table}[$key];
			$data = $value;
			if (substr($key,-4)=="date")
				{
				$data = dmyyyy($value);
				}
			echo "<li><label class=\"displ\">$label</label>&nbsp;&nbsp;$data</li>";
			}
	}
	?>
	</ul>
</td>