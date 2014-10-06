<?php
include '../req/confcheckfxns.php';
$pagetitle= 'TYPED letters awaiting REVIEW: ' . $user;
include "$rwarepath/navs/topusernav.php";
?>
<div id="navbar">
    <p>
    <a class="ui-state-default" style="color: green;" href="letters/newletter.php?stage=findpat" title="create a new letter">New Letter</a>&nbsp;&nbsp;
    <a class="ui-state-default" style="color: green;" href="letters/newdischarge.php?stage=findpat" title="create a new letter">New Discharge Summary</a>&nbsp;&nbsp;   
    </p>
</div>
<?php
//get total
$limit = 200; //default
$displaytext = "recent letters authored or typed by $user awaiting review"; //default
$fields = "letter_id, letterzid, letthospno, lettuid, lettuser, lettmodifstamp, authorid, typistid, typistinits, letterdate, status, lettdescr, wordcount, concat(lastname, ', ', firstnames) as patlastfirst, authorlastfirst, recipname, recipient, patref, printstage, lettertype";
$tables = "letterdata LEFT JOIN patientdata on letterzid=patzid";
$where = "WHERE (typistid=$uid or authorid=$uid) AND archiveflag='0'"; // default
$orderby = "ORDER BY letter_id ASC";
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $limit";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
$showrows = ($numrows) ? "$numrows $displaytext (max $limit shown). Click on headers to sort displayed data." : "There are no $displaytext" ;
echo "<p class=\"header\">$showrows</p>";
	if ($numrows) {
		$theaders='<th>HospNo</th>
			<th>patient</th>
			<th>date</th>
			<th>description <i>words</i></th>
			<th>edit/view</th>
			<th>author</th>
			<th>typist</th>
			<th>recipient</th>';
	echo '<table class="tablesorter"><thead><tr>'.$theaders.'</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$status = $row['status'];
		$printstage = $row['printstage'];
		$lettertype = $row['lettertype'];
		$descr = $row["lettdescr"] . ' <i>' . $row["wordcount"] . '</i>';
		$viewURL='letters/viewletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["letter_id"];
		$printURL='letters/printletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["letter_id"];
		$viewedit = '<a href="' . $printURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">view/print ARCHIVED</a>';
		$preview = '<a href="' . $viewURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">preview</a>';
		$viewedit = '<a href="letters/editletter.php?zid=' . $row["letterzid"] . '&amp;letter_id=' . $row["letter_id"] . '">edit ' . $status . '</a> or ' . $preview;
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["letterzid"] . '">' . $row["patlastfirst"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["letterzid"] . '">' . $row["letthospno"] . '</a>';
		$recip = '<acronym title="' . $row["recipient"] . '">' . $row['recipname'] . '</a>';
		echo '<tr class="' . $status . '">
		<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td>' . dmy($row["letterdate"]) . '</td>
		<td>' . $descr . '</td>
		<td>' . $viewedit . '</td>
		<td>' . $row["authorlastfirst"] . '</td>
		<td>' . $row["typistinits"] . '</td>
		<td>' . $row["recipient"] . '</td>
		</tr>';
		}
	echo '</tbody></table>';
	}
// get footer
include '../parts/footer.php';
?>