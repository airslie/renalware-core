<?php
//--Sun Nov 24 14:05:44 EST 2013--
//to highlight CURRENT meds based on termdate NULL
//parse headers
$tableheaders=explode(",",$headers);
$sql = "SELECT $fields FROM $table $where $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
	bs_Para("success","$numrows $listitems found");
    //make table
    echo '<table class="table table-bordered table-condensed">
	<thead><tr>';
    foreach ($tableheaders as $label) {
        echo "<th>$label</th>";
    }
    echo '</tr></thead>
	<tbody>';
	while($row = $result->fetch_assoc())
		{
            if ($row["termdate"]) {
        		echo "<tr>";
            } else {
        		echo '<tr class="warning">';
            }
		foreach ($row as $key => $value) {
			$tdval = (strtolower(substr($key,-4)=="date")) ? dmyyyy($value) : $value ;
			echo '<td>'.$tdval.'</td>';
		}
		echo '</tr>';
		}
    echo '</tbody>
        </table>';
} else {
    //none found
	bs_Para("danger","No matching $listitems located!");
}
