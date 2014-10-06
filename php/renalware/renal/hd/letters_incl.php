<?php
$displaytime = date("D j M Y  G:i:s");
$fields = "letter_id, typistinits, letterdate, lettertype, status, lettdescr, wordcount, authorlastfirst, recipname, recipient, printstage";
$tables = "letterdata";
$orderby = "ORDER BY letterdate DESC";
$sql= "SELECT $fields FROM $tables WHERE letterzid=$zid $orderby LIMIT $portallimit";
$result = $mysqli->query($sql);
//echo "<hr>$sql<hr>";
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	}
else
	{
	echo "<p class=\"header\">$numrows Recent letters displayed.</p>";
	echo "<table class=\"list\">
	<th>date</th>
	<th>description <i>words</i></th>
	<th>edit/view</th>
	<th>author</th>
	<th>typist</th>
	<th>recipient</th>
	</tr>";
	
	while ($row = $result->fetch_assoc()) {
		$status = $row['status'];
		$descr = $row["lettdescr"] . ' <i>' . $row["wordcount"] . '</i>';
		$viewURL='letters/viewletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["letter_id"];
		$viewedit = '<a href="' . $viewURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">view ' .  $status . '</a>';
		$recip = $row['recipient']; //speeds up?
		echo '<tr class="' . $status . '">
		<td>' . dmy($row["letterdate"]) . '</td>
		<td>' . $descr . '</td>
		<td>' . $viewedit . '</td>
		<td>' . $row["authorlastfirst"] . '</td>
		<td>' . $row["typistinits"] . '</td>
		<td>' . $recip . '</td>
		</tr>';
		}
		echo '</table>';
	}
?>