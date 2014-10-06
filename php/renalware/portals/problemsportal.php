<?php
//Sat May 16 16:36:08 IST 2009
$sql= "SELECT problem_id, probdate, probuser, problem FROM problemdata WHERE probzid=$zid ORDER BY problem_id";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows problems <i>(date=date recorded)</i></p>";
if ($numrows)
	{
	echo '<ul class="portal">';
	while ($row = $result->fetch_assoc())
		{
		$problem=$row["problem"];
		echo '<li>' ."$problem <i>(" . dmy($row['probdate']) . ")</i></li>\n";
		}
	echo '</ul>';
	}
?>