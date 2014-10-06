<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Print Queue";
include "$rwarepath/navs/topusernav.php";
//get total
$display = 200; //default
$displaytext = "Letters ready for printing"; //default
$sql= "SELECT letter_id FROM letterdata WHERE printstage=1";  // default
$result = $mysqli->query($sql);
$num_records = $result->num_rows;
$orderby = "ORDER BY lettmodifstamp ASC"; //default
$displaytime = date("D j M Y  G:i:s");
$fields = "letter_id, letterzid, letthospno, lettuid, lettuser, lettmodifstamp, authorid, typistid, typistinits, letterdate, status, lettdescr, wordcount, concat(lastname, ', ', firstnames) as patlastfirst, authorlastfirst, recipname, recipient, patref, printstage, lettertype, typeddate, reviewdate,e.log_id as emailflag, c.log_id as cdaflag";
$tables = "letterdata JOIN patientdata on letterzid=patzid LEFT JOIN gpemaillogs e ON letter_id=e.logletter_id LEFT JOIN gpCDAlogs c ON letter_id=c.logletter_id";
$where = "WHERE printstage=1"; // default
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT 200";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	}
else
	{
	makeAlert("IMPORTANT: GP emailing",'Please note that letters marked Emailed or Docman have been sent to the GP electronically and thus 1 fewer copy needs printing.');
	echo "<p class=\"header\">$numrows $displaytext. Click on headers to sort.</p>";
	echo "<table class=\"tablesorter\"><thead>
	<tr><th>$hosp1label</th>
	<th>patient</th>
	<th>date</th>
	<th>description <i>words</i></th>
	<th>edit/view</th>
	<th>author</th>
	<th>typist</th>
	<th>recipient</th>
	<th>TYPED</th>
	<th>REVIEWED</th>
	<th>Emailed?</th>
	<th>Docman?</th>
	</tr></thead><tbody>";
	while ($row = $result->fetch_assoc()) {
		$trclass = ($row["cdaflag"] or $row["emailflag"]) ? 'GPEMAILED' : 'UNPRINTED' ;
        $showemailflag = ($row["emailflag"]) ? 'Y' : '' ;
        $showcdaflag = ($row["cdaflag"]) ? 'Y' : '' ;
		$status = $row['status'];
		$lettertype = $row['lettertype'];
		$descr = $row["lettdescr"] . ' <i>' . $row["wordcount"] . '</i>';
		$printURL='letters/printletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["letter_id"];
		$viewURL='letters/viewletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["letter_id"];
		$preview = '<a href="' . $viewURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">preview</a>';
		$viewedit = '<a href="' . $printURL . '"  target="_blank" onclick="window.open(\'' . $printURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">print FINAL</a> or ' . $preview;
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["letterzid"] . '">' . $row["patlastfirst"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["letterzid"] . '">' . $row["letthospno"] . '</a>';
		$recip = '<acronym title="' . $row["recipient"] . '">' . $row['recipname'] . '</a>';
		echo '<tr class="'.$trclass.'">
		<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td>' . dmy($row["letterdate"]) . '</td>
		<td>' . $descr . '</td>
		<td>' . $viewedit . '</td>
		<td>' . $row["authorlastfirst"] . '</td>
		<td>' . $row["typistinits"] . '</td>
		<td>' . $recip . '</td>
		<td>' . dmy($row["typeddate"]) . '</td>
		<td>' . dmy($row["reviewdate"]) . '</td>
		<td>' . $showemailflag . '</td>
		<td>' . $showcdaflag . '</td>
		</tr>';
		}
	echo '</tbody></table>';
	}
// get footer
include '../parts/footer.php';
?>