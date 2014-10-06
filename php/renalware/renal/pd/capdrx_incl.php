<td valign="top">
	<p class="header">CAPD Treatment data (<a href="renal/forms/capdrxdataform.php?zid=<?php echo $zid ?>">add/update</a>)</p>
	<ul class="portal">
	<?php
	$table="capdrxdata";
	include 'maps/'.$table.'.php';
	$fields="adddate, no_exchange, volume, dextrose, calcium, system, extraneal, ph, signature";
	$where="WHERE capdrxzid=$zid";
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
