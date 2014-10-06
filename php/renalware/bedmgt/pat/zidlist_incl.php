<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
$fields="
pid,
tcidate,
IF(tcidate, DATE_FORMAT(tcidate, '%a %d %b %y'),'') AS tcidate_ddmy,
IF(preopdate, DATE_FORMAT(preopdate, '%a %d %b %y'),'') AS preopdate_ddmy,
tcitime,
preoptime,
surgdate,
listeddate,
IF(status='Arch',DATEDIFF(surgdate,listeddate)+1, DATEDIFF(NOW(),listeddate)+1) as DOL,
surgslot,
consultant,
surgeon,
priority,
category,
proced,
mgtintent,
surgslot,
anaesth,
infxnstatus,
p.modifstamp,
status
";
$tables="proceddata p";
$sql="SELECT $fields FROM $tables $where $orderby";
$result = $mysqli->query($sql);
$numfound=$result->num_rows;
if (!$numfound)
	{
	echo "<p class=\"results\">There are no such procedures recorded for this patient!</p>";
	}
else
	{
	echo "<p class=\"results\">$numfound Procedures found";
	echo '</p><table class="list">
	<tr>
<th>listed date (DOL)</th>
<th>priority</th>
<th>category</th>
<th>surgeon</th>
<th>procedure</th>
<th>Mgt Intent</th>
<th>TCI date/time</th>
<th>Preop date/time</th>
<th>surg date/slot</th>
<th>infxn status</th>
<th>options</th>
	</tr>';
//set prevdate
	while($row = $result->fetch_assoc())
		{
		//set colors
		
		//flag priority TD
		$priority=$row["priority"]; //default
		$priorityclass=$priority;
		$pid=$row["pid"];
		include( 'incl/procedoptions_incl.php' );
			echo '<tr>
			<td>' . dmy($row["listeddate"]) . ' <i>(' . $row["DOL"] . ')</i></td>
			<td class="' . $priorityclass . '">' . $priority . '</td>
			<td><b>' . $row["category"] . '</b></td>
			<td>' . $row["surgeon"] . '</td>
			<td><b>' . $row["proced"] . '</b></td>
			<td><b>' . $row["mgtintent"] . '</b></td>
			<td>' . $row["tcidate_ddmy"] . '/' . $row["tcitime"] . '</td>
			<td>' . $row["preopdate_ddmy"] . '/' . $row["preoptime"] . '</td>
			<td>' . dmy($row["surgdate"]) . '/' . $row["surgslot"] . '</td>
			<td>' . $row["infxnstatus"] . '</td>
			<td>' . $schedoptions . '</td>
			</tr>';	
		}
	echo '</table>';
	}

?>