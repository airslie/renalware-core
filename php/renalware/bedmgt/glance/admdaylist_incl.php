<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//Tue Apr 10 18:07:46 CEST 2007 $comments
$where="WHERE tcidate='$searchday'";
$orderby="ORDER BY lastname,firstnames";
$fields="
pid,
pzid,
hospno1,
tcidate,
IF(tcidate, DATE_FORMAT(tcidate, '%a %d %b %y'),'') AS tcidate_ddmy,
consultant,
priority,
proced,
surgslot,
infxnstatus,
CONCAT(lastname, ', ', firstnames) as patient,
modalcode,
mgtintent,
tel1,
LEFT(schednotes, 25) as commentstrunc,
schednotes as comments,
p.modifstamp,
status,
DATEDIFF(CURDATE(),listeddate)+1 as DOL
";
$tables="proceddata p LEFT JOIN renalware.patientdata ON pzid=patzid";
$sql="SELECT $fields FROM $tables $where $orderby";
$result = $mysqli->query($sql);
$numfound=$result->num_rows;
if (!$numfound)
	{
	echo "<p class=\"results\">There are no admissions scheduled for this day!</p>";
	}
else
	{
	echo "<p class=\"results\">$numfound admissions found.";
	echo '</p><table class="list">
	<tr>
	<th>priority</th>
	<th>HospNo</th>
	<th>Patient</th>
	<th>DOL</th>
	<th>Procedure</th>
	<th>Consultant</th>
	<th>Infxn status</th>
	<th>Mgt Intent/Slot</th>
	<th>Tel No</th>
	<th>Modality</th>
	<th>Comments (hover to view)</th>
	<th>options</th>
	</tr>';
//set prevdate
	while($row = $result->fetch_assoc())
		{
		//set colors
		$pid=$row["pid"];
		$zid=$row["pzid"];
		//flag priority TD
		$priority=$row["priority"]; //default
		$priorityclass=$priority;
		$patlink = '<a href="../pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . $row["patient"] . '</a>';
		$adminlink = '<a href="../pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		$comments='<a title="' . $row["comments"] . '">' . $row["commentstrunc"] . '</a>';
		include( 'incl/procedoptions_incl.php' );
			echo '<tr>
			<td class="' . $priorityclass . '">' . $priority . '</td>
			<td>' . $adminlink . '</td>
			<td>' . $patlink . '</td>
			<td>' . $row["DOL"] . '</td>
			<td><b>' . $row["proced"] . '</b></td>
			<td>' . $row["consultant"] . '</td>
			<td>' . $row["infxnstatus"] . '</td>
			<td>' . $row["mgtintent"] . '/' . $row["surgslot"] . '</td>
			<td>' . $row["tel1"] . '</td>
			<td>' . $row["modalcode"] . '</td>
			<td>' . $comments . '</td>
			<td>' . $schedoptions . '&nbsp;&nbsp;' . $patviewlink . '</td>
			</tr>';	
		}
	echo '</table>';
	}

?>