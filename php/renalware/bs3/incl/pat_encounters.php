<?php
$portallimit=10;
$display = $portallimit; //default
$displaytext = "encounters recorded"; //default
$sql= "SELECT encounter_id FROM encounterdata WHERE enczid=$zid";
$result = $mysqli->query($sql);
$num_records = $result->num_rows;
$displaytime = date("D j M Y  G:i:s");
$fields = "encounter_id, encuser, enczid, encmodal, encdate, enctime, enctype, trim(LEFT(enctext, 100)) as abstr, encdescr, enctext";
$tables = "encounterdata";
$where = "WHERE enczid=$zid";
$orderby = "ORDER BY encdate DESC";
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $display";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if (!$numrows)
	{
	bs_Para("danger","No encounters recorded!");
	}
else
	{
	bs_Para("danger","$num_records $displaytext ($numrows displayed). (Toggle to view text.)");
    echo '<ul class="list-unstyled">';
	while ($row = $result->fetch_assoc()) {
		$encounter_id=$row["encounter_id"];
		$enctext=$row["enctext"];
		$encuser=$row["encuser"];
		$encdate=dmyyyy($row["encdate"]);
		$showdescr = ($row["encdescr"]) ? '<i>'.$row["encdescr"].'</i>' : '' ;
		$showhide = "<a onclick=\"$('#enc$encounter_id').toggle();\">toggle</a>";
		echo '<li>' . $showhide  . ' '.$encdate.' ' . $row["enctime"] . " <em>" . $row["enctype"] . "</em>:&nbsp;&nbsp;$showdescr &nbsp;[$encuser]</li>\n";
		echo "<li id=\"enc".$row["encounter_id"]."\" style=\"display:none;padding:2px;width:1000px;background-color:#ff9;font-size: 1em;\">$enctext</li>\n";
		}
	echo "</ul>";
	}
