<?php
//----Wed 06 Mar 2013----datatbls version
//get total
$displaytext = "TYPED and DRAFT letters authored or typed by $user"; //default
$where = "WHERE (typistid=$uid or authorid=$uid) AND archiveflag=0"; // default
$showall="";
$fields = "letter_id, letterzid, letthospno, letterdate, status, lettdescr, authorlastfirst, concat(lastname, ', ', firstnames) as patlastfirst, printstage, wordcount";
$tables = "letterdata LEFT JOIN patientdata on letterzid=patzid";
$orderby = "ORDER BY status DESC, letterdate DESC";
$sql= "SELECT $fields FROM $tables $where $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if (!$numrows)
	{
	echo "<p class=\"headergray\">There are no TYPED or DRAFT letters authored or typed by $user!</p>";
	}
else
	{
	echo "<p class=\"header\">$numrows $displaytext. Click on headers to sort columns.</p>";
	echo '<table id="userletters" class="display">
    <thead>
	<tr>
	<th>date</th>
	<th>HospNo</th>
	<th>patient</th>
	<th>Status</th>
	<th>description [wordcount]</th>
	<th>author</th>
	<th>edit/view</th>
	</tr>
    </thead>
    <tbody>';
	while ($row = $result->fetch_assoc()) {
		$status = $row['status'];
		$printstage = $row['printstage'];
		$lettertype = $row['lettertype'];
		$letterdate=dmy4($row["letterdate"]);
		$descr = $row["lettdescr"] . ' [' . $row["wordcount"] . ']';
		$viewURL='letters/viewletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["letter_id"];
		$printURL='letters/printletter.php?zid=' . $row['letterzid'] . '&amp;letter_id=' . $row["letter_id"];
		$viewedit = '<a href="' . $printURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">view/print ARCHIVED</a>';
		$preview = '<a href="' . $viewURL . '"  target="_blank" onclick="window.open(\'' . $viewURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">preview</a>';
		$trstatus=$status;
		if ($printstage)
		{
			$trstatus="UNPRINTED"; //mark unprinted
			$viewedit = '<a href="' . $printURL . '"  target="_blank" onclick="window.open(\'' . $printURL . '\',\'Letter\',\'toolbar=yes,scrollbars=yes,width=900,height=900,resize=yes\'); return(false);">print FINAL</a> for post or ' . $preview;	
		}
		switch ($status) {
			case 'TYPED':
				$viewedit = '<a href="letters/editletter.php?zid=' . $row["letterzid"] . '&amp;letter_id=' . $row["letter_id"] . '">edit/review TYPED</a>';
				break;
			case 'DRAFT':
				$viewedit = '<a href="letters/editletter.php?zid=' . $row["letterzid"] . '&amp;letter_id=' . $row["letter_id"] . '">edit DRAFT</a> or ' . $preview;
				break;
            }
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $row["letterzid"] . '">' . $row["patlastfirst"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $row["letterzid"] . '">' . $row["letthospno"] . '</a>';
		switch ($trstatus) {
			case 'DRAFT':
				$bg='#ffff00';
				break;
			case 'TYPED':
				$bg='#CCFF00';
				break;
			case 'UNPRINTED':
				$bg='#ffcc00';
				break;
			default:
				$bg='#fff';
				break;
		}
		echo '<tr style="background: ' . $bg . '">
		<td>' . $letterdate . '</td>
		<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td>' . $status . '</td>
		<td>' . $descr . '</td>
		<td>' . $row["authorlastfirst"] . '</td>
		<td>' . $viewedit . '</td>
		</tr>';
		}
	echo '</tbody></table><br>';
	}
?>
<script>
$('#userletters').dataTable( {
	"bPaginate": false,
	"bLengthChange": false,
	"bJQueryUI": false,
	//"sPaginationType": "full_numbers",
	"bFilter": false,
	"aaSorting": [[ 0, "asc" ]],
	"iDisplayLength": 100,
	"bSort": true,
	"bInfo": false,
	"bAutoWidth": false,
	"bStateSave": false
} );
</script>
