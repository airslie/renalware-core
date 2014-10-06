<p><a class="ui-state-default" style="color: green;" href="pat/patient.php?vw=pimsdata&amp;zid=<?php echo $zid ?>">View PIMS Visits/Appointments</a></p>
<?php
//-------SET FORM VARS--------
$thisvw="admissions";
$addtype="admission";
//-------HANDLE FORMS--------
$pagevw="pat/patient.php?zid=$zid&amp;vw=$thisvw";
	if ($get_run=='add') {
		include 'run/'.$addtype.'_add.php';
	}
//-------END HANDLE FORMS--------
	$displaytext = "admissions for $firstnames $lastname"; //default
	$fields = "admission_id, admzid, admhospno1, admmodal, admdate, admward, consultant, admtype, reason, dischdate, dischdest, admstatus, if(admdays >0, admdays, DATEDIFF(CURDATE(),admdate)+1) as LOS, dischsummstatus";
	$table = "renalware.admissiondata";
	$where = "WHERE admzid=$zid";
	$orderby = "ORDER BY admdate DESC";
	$sql = "SELECT $fields FROM $table $where $orderby";
	$result = $mysqli->query($sql);
	$numrows=$result->num_rows;
	$addmore= '<button type="button" class="ui-state-default" onclick="$(\'#adddataform\').toggle(\'slow\')">add new '.$addtype.'</button>';
	$shownum = ($numrows=='0') ? 'There are no' : $numrows ;
	echo "<p class=\"header\">$shownum $displaytext. &nbsp; $addmore</p>";
	include 'forms/add_'.$addtype.'form.html';
	if ($numrows) {
	echo "<table class=\"tablesorter\"><thead>
		<thead><tr>
		<th>adm date</th>
		<th>ward</th>
		<th>consultant</th>
		<th>type</th>
		<th>reason</th>
		<th>adm modal</th>
		<th>disch date</th>
		<th>destination</th>
		<th>status</th>
		<th>LOS</th>
		</tr></thead><tbody>";
		$totaldays = 0; //set null
		while($row = $result->fetch_assoc())
			{
			$dischsummstatus = $row["dischsummstatus"];
			$trclass = ($row["admstatus"]=="Admitted") ? 'hilite' : '' ;
			$ttalink = '<a href="' . $dischsummstatus . 'tta.php?admid=' . $row["admission_id"] .'">' . $dischsummstatus . ' TTA</a>';
			echo '<tr class="' . $trclass .'">
			<td>' . dmy($row["admdate"]) . '</td>
			<td>' . $row["admward"] . '</td>
			<td>' . $row["consultant"] . '</td>
			<td>' . $row["admtype"] . '</td>
			<td>' . $row["reason"] . '</td>
			<td>' . $row["admmodal"] . '</td>
			<td>' . dmy($row["dischdate"]) . '</td>
			<td>' . $row["dischdest"] . '</td>
			<td>' . $row["admstatus"] . '</td>
			<td>' . $row["LOS"] . '</td>
			</tr>';
			$totaldays += $row["LOS"];
			}
			$avgdays = floor($totaldays/$numrows);
		echo '</tbody></table>';
		echo "<p><b>Total inpatient days</b>: $totaldays <i>(Average stay: $avgdays days)</i></p>";
		}
?>