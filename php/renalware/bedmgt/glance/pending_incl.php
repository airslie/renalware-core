<h3>Pending (Requested) Procedures</h3>
<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
$where="WHERE status='Req'";
$orderby="ORDER BY priority, DOL DESC";
$fields="
pid,
DATE_FORMAT(listeddate, '%d/%m/%y') AS listeddate_dmy,
IF(status='Arch',DATEDIFF(surgdate,listeddate)+1, DATEDIFF(NOW(),listeddate)+1) as DOL,
consultant,
surgeon,
priority,
category,
proced,
anaesth,
infxnstatus,
p.modifstamp,
pzid,
hospno1,
CONCAT(lastname, ', ', firstnames) as patient,
sex, age,
birthdate,
modalcode";
$tables="proceddata p LEFT JOIN renalware.patientdata ON pzid=patzid";
$sql="SELECT $fields FROM $tables $where $orderby";
$result = $mysqli->query($sql);
$numfound=$result->num_rows;
if (!$numfound)
	{
	echo "<p class=\"results\">There are no pending procedures recorded!</p>";
	}
else
	{
		echo "<p class=\"results\">$numfound pending procedures found.";
	echo '</p><table class="list">
	<tr>
<th>listed date</th>
<th>DOL</th>
<th>priority</th>
<th>category</th>
<th>hospNo</th>
<th>patient</th>
<th>sex (age)</th>
<th>DOB</th>
<th>modal</th>
<th>surgeon</th>
<th>procedure</th>
<th>infxn status</th>
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
		include( 'incl/procedoptions_incl.php' );
			echo '<tr>
			<td>' . $row["listeddate_dmy"] . '</td>
			<td>' . $row["DOL"] . '</td>
			<td class="' . $priorityclass . '">' . $priority . '</td>
			<td><b>' . $row["category"] . '</b></td>
			<td>' . $adminlink . '</td>
			<td>' . $patlink . '</td>
			<td>' . $row["sex"] . ' ('.$row["age"].')</td>
			<td>' . dmy($row["birthdate"]) . '</td>
			<td>' . $row["modalcode"] . '</td>
			<td>' . $row["surgeon"] . '</td>
			<td><b>' . $row["proced"] . '</b></td>
			<td>' . $row["infxnstatus"] . '</td>
			<td>' . $diaryoptions . '</td>
			</tr>';	
		}
	echo '</table>';
	}

?>