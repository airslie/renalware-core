<?php
$displaytext = "UNREAD Electronic CCs for $user"; //default
$fields = "lettercc_id, ccletter_id, sentstamp, letthospno, letterdate,letterzid, lettdescr,wordcount, authorlastfirst, concat(lastname, ', ', firstnames) as patlastfirst, DATEDIFF(NOW(), letterdate) as daysunread";
$tables = "letterccdata JOIN letterdata ON ccletter_id=letter_id JOIN patientdata on cczid=patzid";
$where = "WHERE recip_uid=$uid AND ccstatus='sent'";
$orderby = "ORDER BY letterdate ASC";
$sql= "SELECT $fields FROM $tables $where $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"headergray\">There are no UNREAD Electronic CCs for $user</p>";
	}
else
	{
	echo "<p class=\"header\">$numrows $displaytext. (Highlighted CCs are more than $ccdayswarning days old)";
$alertboxflag=FALSE;
	echo "<table class=\"display\">
		<thead><tr>
		    <th>options</th>
		    <th>CC sent</th>
		    <th>HospNo</th>
		    <th>patient</th>
		    <th>letter date</th>
		    <th>description [wordcount]</th>
		    <th>author</th>
		    <th>days unread</th>
		    </tr></thead><tbody>";
	while ($row = $result->fetch_assoc()) {
		$descr = $row["lettdescr"] . ' [' . $row["wordcount"] . ']';
		$viewURL='letters/viewlettercc.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["ccletter_id"] . '&amp;lettercc_id='.$row["lettercc_id"];
		$viewcc = '<a href="'.$viewURL.'">read letter</a>';
		$bg="#fff";
		if ($row["daysunread"]>$ccdayswarning) {
			$alertboxflag=TRUE;
			$bg = "#ffcc00";
		}
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["letterzid"] . '">' . $row["letthospno"] . '</a>';
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["letterzid"] . '">' . $row["patlastfirst"] . '</a>';
		
		echo '<tr bgcolor="' . $bg . '">
		<td class="links">' . $viewcc . '</td>
		<td>' . $row["sentstamp"] . '</td>
		<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td>' . dmy($row["letterdate"]) . '</td>
		<td>' . $descr . '</td>
		<td>' . $row["authorlastfirst"] . '</td>
		<td>' . $row["daysunread"] . '</td>
		</tr>';
		}
	echo '</tbody></table><br>';
	}
if ($alertboxflag) {
	echo '<p class="alertsmall">WARNING: You have letters older than ' . $ccdayswarning . ' days left unread!</p>';
}
