<?php
//--Mon Nov 25 10:45:38 EST 2013--
//takes special SQL queries
//parse headers
$tableheaders=explode(",",$headers);
//$sql set upstream
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($showsql) {
    bs_Alert("warning","$sql");
}
if ($numrows) {
	bs_Para("success","$numrows $listitems found. $listnotes");
    //make table
    echo '<table class="table table-bordered datatable">
	<thead><tr>
    <th>Options</th>';
    foreach ($tableheaders as $label) {
        echo "<th>$label</th>";
    }
    echo '</tr></thead>
	<tbody>';
	while($row = $result->fetch_assoc())
		{
		$zid=$row["patzid"];
		//view pat link only pro tem
		echo '<tr><td><a href="'.$modulebase.'/view_pat.php?zid='.$zid.'&amp;ls='.$thispage.'">view</a></td>';
		foreach ($row as $key => $value) {
			if (!in_array($key,$omitfields)) {
			$tdval = (strtolower(substr($key,-4)=="date")) ? dmyyyy($value) : $value ;
			echo '<td>'.$tdval.'</td>';
            }
		}
		echo '</tr>';
		}
    echo '</tbody>
        </table>';
} else {
    //none found
	bs_Para("danger","No matching $listitems located!");
}
