<?php
$limit=""; //disabled
$enctype="Counsellor Meeting";
$displaytext = "$enctype encounters recorded"; //default
$fields = "encounter_id, encuser, enczid, encmodal, encdate, enctime, encdescr, enctext";
$table = "psychsoc_encounterdata";
$where = "WHERE enczid=$zid AND enctype='$enctype'";
$orderby = "ORDER BY encdate DESC";
$sql= "SELECT $fields FROM $table $where $orderby $limit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	}
else
	{
	echo "<p class=\"header\">$numrows $displaytext</p>
	<ul class=\"portal\">";
	while ($row = $result->fetch_assoc()) {
		$encounter_id=$row["encounter_id"];
		$enctext=$row["enctext"];
		$encuser=$row["encuser"];
		$encdate=dmyyyy($row["encdate"]);
		$showdescr = ($row["encdescr"]) ? '<i>'.$row["encdescr"].'</i>' : '' ;
		$showhide = "<a class=\"tg\" onclick=\"toggl('enc$encounter_id');\">$encdate</a>";
		echo '<li class="ls">' . $showhide  . ' ' . $row["enctime"] . " <b>" . $row["enctype"] . "</b>:&nbsp;&nbsp;$showdescr &nbsp;[$encuser]</li>\n";
		echo "<li id=\"enc$encounter_id\" style=\"display:none;padding:2px;background-color:#ff9;font-size: 1.1em;\">$enctext</li>\n";
		}
	echo "</ul>";
	}
?>