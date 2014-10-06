<?php
//----Wed 06 Aug 2014----fix for #45
//-------SET FORM VARS--------
$thisvw="ixworkups";
$addtype="ixworkupdata";
//-------HANDLE FORMS--------
//get listhtml options from table
$sql = "SELECT listhtml FROM optionlists WHERE listname='ixworkuptypes' LIMIT 1";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$listhtml= $row["listhtml"];

$pagevw="pat/patient.php?zid=$zid&amp;vw=$thisvw";
	if ($get_run=='add') {
		include 'run/ixworkupdata_add.php';
	}
//-------END HANDLE FORMS--------
	$displaytext = "investigation(s) recorded (yellow=most recent, at top)"; //default
	$fields = "ixworkupdata_id, ixworkupuser, ixworkupzid, ixworkupmodal, ixworkupdate, ixworkuptype, ixworkupresults, currflag";
	$table = "ixworkupdata";
	$where = "WHERE ixworkupzid=$zid";
	$orderby = "ORDER BY ixworkupdate DESC"; //def
	$sql = "SELECT $fields FROM $table $where $orderby";
	$result = $mysqli->query($sql);
	$numrows=$result->num_rows;
	$addmore= '<button type="button" class="ui-state-default" onclick="$(\'#adddataform\').toggle(\'slow\')">add new Ix/Workup</button>';
	$shownum = (!$numrows) ? 'There are no' : $numrows ;
	echo "<p class=\"header\">$shownum $displaytext. &nbsp; $addmore</p>";
	include 'forms/add_ixworkupdataform.php';
	if ($numrows) {
	echo '<table class="tablesorter"><thead>
		<tr>
		<th>date</th>
		<th>user</th>
		<th>modal</th>
		<th>type</th>
		<th>results (click to view fulltext)</th>
		</tr></thead><tbody>';
		while($row = $result->fetch_assoc())
			{
			$ixworkupURL='pat/viewixresult.php?zid=' . $row['ixworkupzid'] . '&amp;ixworkupdata_id=' . $row["ixworkupdata_id"];
			$viewixworkup = '<a href="' . $ixworkupURL . '"  target="_blank" onclick="window.open(\'' . $ixworkupURL . '\',\'ixworkupdata\',\'scrollbars=yes,width=500,height=600,resize=yes\'); return(false);">' . $row["ixworkupresults"] . '...</a>';
			$trclass = ($row["currflag"]=='1') ? "hilite" : "" ;
			echo '<tr class="' . $trclass . '">
			<td>' . dmy($row["ixworkupdate"]) . '</td>
			<td>' . $row["ixworkupuser"] . '</td>
			<td>' . $row["ixworkupmodal"] . '</td>
			<td><b>' . $row["ixworkuptype"] . '</b></td>
			<td>' . $viewixworkup . '</td>
			</tr>';
			}
		echo '</tbody></table>';
		}
