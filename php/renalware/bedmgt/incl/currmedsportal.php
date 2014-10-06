<?php 
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
echo '<table class="list">';
$sql="SELECT medsdata_id, DATE_FORMAT(adddate, '%e-%b-%Y') as startdate, drugname, dose, route, freq, esdflag, immunosuppflag FROM renalware.medsdata WHERE medzid=$zid AND termflag=0 ORDER BY drugname";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"results\">No Current Medications retrieved from system!</p>";
	}
else
	{
	echo "<p class=\"results\">Current Medications ($numrows)</p>";
	while($row = $result->fetch_assoc())
		{
		$bg = '#ffffff';
		if ($row['esdflag']==1)
			{
			$bg = '#FFCC00'; //flag ESAs
			}
		if ($row['immunosuppflag']==1)
			{
			$bg = '#99ffff'; //flag immunosupps
			}
		echo "<tr><td align=\"left\" class=\"portal\" bgcolor=\"$bg\"><b>" . $row['drugname']. "</b> " . $row['dose'] . " " . $row['route'] . " "  . $row['freq'] . " <i><font color=\"#33CC00\">(" . $row['startdate'] . ")</font></i></td></tr>\n";
		}
	}
echo '</table>';
