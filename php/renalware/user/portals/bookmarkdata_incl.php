<?php
if ( $get_deletemark )
{
	$sql= "DELETE FROM bookmarkdata WHERE mark_id=$get_deletemark";
	$result = $mysqli->query($sql);
	showAlert("The bookmark has vanished into the ether...");
}
if ( $get_urgentmark )
{
	$sql= "UPDATE bookmarkdata SET markpriority='URGENT' WHERE mark_id=$get_urgentmark";
	$result = $mysqli->query($sql);
	showAlert("The bookmark has been flagged URGENT!");
}
$displaytext = "Patient &rsquo;Bookmarks&lsquo; for $user"; //default
$where = "WHERE markuid=$uid"; // default
$showall="";
$fields = "mark_id, markstamp, markzid, markuid, marknotes, markpriority, marklist, lastname, firstnames, modalcode, hospno1";
$tables = "bookmarkdata JOIN patientdata ON markzid=patzid";
$orderby = "ORDER BY markpriority DESC, marklist, lastname, firstnames DESC";
$sql= "SELECT $fields FROM $tables $where $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	}
else
	{
	echo "<p class=\"header\">$numtotal $displaytext</p>";
	echo '<table class="display"><thead><tr>
<th>date/time</th>
<th>priority</th>
<th>mark list</th>
<th>patient</th>
<th>Hosp No</th>
<th>modality</th>
<th>notes</th>
<th>options (CANNOT BE UNDONE)</th>
	</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["markzid"] . '">' . $row["lastname"] .', '.$row["firstnames"]. '</a>';
		$bg = ($row["markpriority"]=='URGENT') ? '#ffff00' : '#fff' ;
		$markurgent = ($row["markpriority"]!='URGENT') ? '&nbsp;&nbsp;<a href="user/userhome.php?urgentmark=' . $row["mark_id"] . '">flag URGENT</a>' : "";
		echo '<tr bgcolor="' . $bg . '">
		<td>' . $row["markstamp"] . '</td>
		<td>' . $row["markpriority"] . '</td>
		<td>' . $row["marklist"] . '</td>
		<td><b>' . $patlink . '</b></td>
		<td>' . $row["hospno1"] . '</td>
		<td>' . $row["modalcode"] . '</td>
		<td>' . $row["marknotes"] . '</td>
		<td><a href="user/userhome.php?deletemark=' . $row["mark_id"] . '">delete!</a>'.$markurgent.'</td>
		</tr>';
		}
	echo '</tbody></table>';
	}
