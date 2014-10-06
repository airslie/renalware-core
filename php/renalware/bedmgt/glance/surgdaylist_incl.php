<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//Thu Mar  1 15:44:50 CET 2007 cols changed per specs
//Tue Apr 10 18:21:08 CEST 2007 $comments
$where="WHERE surgdate='$searchday'";
$orderby="ORDER BY lastname,firstnames";
$fields="
pid,
pzid,
hospno1,
IF(preopdate, DATE_FORMAT(preopdate, '%a %d %b %y'),'') AS preopdate_ddmy,
surgeon,
priority,
proced,
mgtintent,
surgslot,
CONCAT(lastname, ', ', firstnames) as patient,
birthdate,
age,
modalcode,
LEFT(schednotes, 25) as commentstrunc,
schednotes as comments,
p.modifstamp,
status,
clinMRSAstatus,
DATEDIFF(CURDATE(),listeddate)+1 as DOL
";
$tables="proceddata p LEFT JOIN renalware.patientdata ON pzid=patzid LEFT JOIN renalware.renaldata ON pzid=renalzid";
$sql="SELECT $fields FROM $tables $where $orderby";
$result = $mysqli->query($sql);
$numfound=$result->num_rows;
if (!$numfound)
	{
	echo "<p class=\"results\">There are no procedures scheduled for this day!</p>";
	}
else
	{
		echo "<p class=\"results\">$numfound procedures found.";
	echo '</p><table class="list">
	<tr>
	<th>priority</th>
	<th>hospNo</th>
	<th>patient</th>
	<th>DOB (age)</th>
	<th>MRSA</th>
	<th>DOL</th>
	<th>procedure</th>
	<th>Mgt Intent/Slot</th>
	<th>Modality</th>
	<th>Pre-Assess Date</th>
	<th>Comments (hover to view)</th>
	<th>options</th>
	</tr>';
	while($row = $result->fetch_assoc())
		{
		$pid=$row["pid"];
		$zid=$row["pzid"];
		//flag priority
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
		<td>' . dmy($row["birthdate"]) . ' ('.$row["age"] .')</td>
		<td>' . $row["clinMRSAstatus"] . '</td>
		<td>' . $row["DOL"] . '</td>
		<td><b>' . $row["proced"] . '</b></td>
		<td>' . $row["mgtintent"] . '/' . $row["surgslot"] . '</td>
		<td>' . $row["modalcode"] . '</td>
		<td>' . $row["preopdate_ddmy"] . '</td>
		<td>' . $comments . '</td>
		<td>' . $schedoptions . '&nbsp;&nbsp;' . $patviewlink . '</td>
		</tr>';	
		}
	echo '</table>';
	}

?>