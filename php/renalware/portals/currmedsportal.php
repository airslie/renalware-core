<?php 
$sql= "SELECT medsdata_id, DATE_FORMAT(adddate, '%e/%m/%y') as startdate, drugname, dose, route, freq, esdflag, immunosuppflag FROM medsdata WHERE medzid=$zid AND termflag=0 ORDER BY drugname";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">Current Medications ($numrows). <a href=\"pat/patient.php?vw=meds&amp;zid=$zid\">View Meds History</a></p>";
if ($numrows)
	{
	echo '<ul class="portal">';
	while ($row = $result->fetch_assoc())
		{
		$class="";
		if ($row['esdflag']==1)
			{
			$class="esa";
			}
		if ($row['immunosuppflag']==1)
			{
			$class="immunosupp";
			}
		echo '<li class="'.$class.'"><em>' . $row['drugname']. "</em> " . $row['dose'] . " " . $row['route'] . " "  . $row['freq'] . " <i>(" . $row['startdate'] . ")</i></li>\n";
		}
	echo '</ul>';
	}
?>
