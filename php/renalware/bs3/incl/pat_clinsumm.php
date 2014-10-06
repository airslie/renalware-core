<?php
//--Sun Nov 24 14:15:47 EST 2013--bs3 version
echo '<div class="row">
  <div class="col-md-6">';
//Sat May 16 16:36:08 IST 2009
$sql= "SELECT * FROM problemdata WHERE probzid=$zid ORDER BY problem_id";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows)
	{
    echo "<h4>$numrows problems</h4>";
	echo '<ul>';
	while ($row = $result->fetch_assoc())
		{
		$problem=$row["problem"];
		echo '<li>' ."$problem <i>(" . dmy($row['probdate']) . ")</i></li>\n";
		}
	echo '</ul>';
	}
    else {
        bs_Para("danger","No problems recorded!");
    }
echo '</div>
  <div class="col-md-6">';
$sql= "SELECT *,DATE_FORMAT(adddate, '%e/%m/%y') as startdate FROM medsdata WHERE medzid=$zid AND termflag=0 ORDER BY drugname";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows)
	{
        echo "<h4>$numrows Current Medications</h4>";
	echo '<ul>';
	while ($row = $result->fetch_assoc())
		{
		$class="";
		if ($row['esdflag'])
			{
			$class="text-danger";
			}
		if ($row['immunosuppflag'])
			{
			$class="text-primary";
			}
		echo '<li class="'.$class.'">' . $row['drugname']. " " . $row['dose'] . " " . $row['route'] . " "  . $row['freq'] . " <i>(" . $row['startdate'] . ")</i></li>";
		}
	}
    else {
        bs_Para("danger","No current medications recorded!");
    }
echo '</div>
</div>';
