<?php
//NB Assumes map!
#---------SET UP---------
$table="apdrxdata";
$tablename="APD Treatment";
$fields="adddate, therapytype, totalvol, dextrose, calcium, therapytime, fillvolume, lastfill, extraneal, ph, no_cycles, optichoice, avgdwelltime, initdrainalarm, signature, addstamp, adduser";
$tablezid="apdrxzid";
#---------END SET UP---------
include 'maps/'.$table.'.php';
$fieldnames=explode(", ",$fields);
$where="WHERE $tablezid=$zid";
$orderby="ORDER BY adddate DESC";
$sql = "SELECT $fields FROM $table $where $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows > 0) {
	echo "<h3>$tablename History</h3>";
	echo "<p class=\"header\">$numrows $tablename records retrieved.</p>";
	echo '<table class="list"><tr>';
	foreach ($fieldnames as $key => $value) {
		echo "<th>".${$table}[$value]."</th>";
	}
	echo "</tr>";
	while($row = $result->fetch_assoc())
		{
			echo '<tr>';
			foreach($row AS $key => $value)
				{
				$data = $value;
				if (strtolower(substr($key,-4))=="date")
					{
					$data = dmyyyy($value);
					}
				echo "<td>$data</td>";
				}
			echo "</tr>";
		}
	echo "</table>";
} // end if found
