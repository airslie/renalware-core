<?php
include '../req/confcheckfxns.php';
$pagetitle= "$user&rsquo;s DRAFTS";
include "$rwarepath/navs/topusernav.php";
?>
	<p>
	<a class="ui-state-default" style="color: green;" href="letters/newletter.php?stage=findpat" title="create a new letter">New Letter</a>&nbsp;&nbsp;
	<a class="ui-state-default" style="color: green;" href="admissions/dischargedlist.php" title="create a disch summ">New Discharge Summary</a>
	</p>    
<?php
$displaytext = "DRAFTS authored or typed by $user"; //default
$fields = "letter_id, letterzid, letthospno, lettuid, lettuser, lettmodifstamp, authorid, typistid, typistinits, letterdate, status, lettdescr, wordcount, concat(lastname, ', ', firstnames) as patlastfirst, authorlastfirst, recipname, LEFT(recipient,60) as recipient, patref, printstage, lettertype";
$tables = "letterdata LEFT JOIN patientdata on letterzid=patzid";
$where = "WHERE (typistid=$uid or authorid=$uid) AND archiveflag='0'"; // default
$orderby = "ORDER BY lettmodifstamp DESC";
$sql= "SELECT $fields FROM $tables $where $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
$showrows = ($numrows) ? "$numrows $displaytext. Click on headers to sort displayed data." : "There are no $displaytext" ;
echo "<p class=\"header\">$showrows</p>";
	if ($numrows) {
		$theaders='
			<th>options</th>
			<th>author</th>
			<th>typist</th>
			<th>HospNo</th>
			<th>patient</th>
			<th>date</th>
			<th>description</th>
			<th>words</th>
			<th>recipient</th>';
	echo '<table class="tablesorter"><thead><tr>'.$theaders.'</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$status = $row['status'];
		$printstage = $row['printstage'];
		$lettertype = $row['lettertype'];
		$viewURL='letters/viewletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["letter_id"];
		$previewlink = '<a href="' . $viewURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">preview</a>';
		$editlink = '<a href="letters/editletter.php?zid=' . $row["letterzid"] . '&amp;letter_id=' . $row["letter_id"] . '">edit</a>';
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["letterzid"] . '">' . $row["patlastfirst"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["letterzid"] . '">' . $row["letthospno"] . '</a>';
		echo '<tr class="' . $status . '">
			<td>' . $editlink .'&nbsp;&nbsp;'.$previewlink . '</td>
			<td>' . $row["authorlastfirst"] . '</td>
			<td>' . $row["typistinits"] . '</td>
		<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td>' . dmy($row["letterdate"]) . '</td>
		<td>' . $row["lettdescr"] . '</td>
		<td>' . $row["wordcount"] . '</td>
		<td>' . $row["recipname"] . '</td>
		</tr>';
		}
	echo '</tbody></table>';
	}
// get footer
include '../parts/footer.php';
?>