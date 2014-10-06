<?php
//--Sun Nov 24 13:32:30 EST 2013--
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
    echo '<th>Change Provider</th></tr></thead>
	<tbody>';
	while($row = $result->fetch_assoc())
		{
            $homeclass = ($row["provider"]=='home') ? 'default' : 'primary' ;
            $hospclass = ($row["provider"]=='hosp') ? 'default' : 'primary' ;
            $gpclass = ($row["provider"]=='GP') ? 'default' : 'primary' ;
        $mid=$row["medsdata_id"];
		echo "<tr>";
		foreach ($row as $key => $value) {
			$tdval = (strtolower(substr($key,-4)=="date")) ? dmyyyy($value) : $value ;
			echo '<td>'.$tdval.'</td>';
		}
        echo '<td><a class="btn btn-'.$homeclass.' btn-sm" href="immunosupprx/view_pat.php?zid='.$zid.'&amp;mid='.$mid.'&amp;provider=home">home</a>&nbsp;&nbsp;
        <a class="btn btn-'.$hospclass.' btn-sm" href="immunosupprx/view_pat.php?zid='.$zid.'&amp;mid='.$mid.'&amp;provider=hosp">hosp</a>&nbsp;&nbsp;
        <a class="btn btn-'.$gpclass.' btn-sm" href="immunosupprx/view_pat.php?zid='.$zid.'&amp;mid='.$mid.'&amp;provider=GP">GP</a>
        </td>
        </tr>';
		}
    echo '</tbody>
        </table>';
} else {
    //none found
	bs_Para("danger","No matching $listitems located!");
}
