<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//navstuff
$navkey="pid";
$navtable="proceddata";
$pp=0; //results/page 0=all
$url="index.php?vw=req&amp;scr=reqlist$q"; //base URL
$navtext = "KRU pending <b>SHORT NOTICE</b> (REQ, SCHED, or SUSP) patients recorded"; //default
$where="WHERE status IN ('Req','Susp','Sched') AND shortnotice='OK'"; //default
$orderby="ORDER BY patient ASC";
$q="";
//navstuff
include( 'incl/calcnavlinks.php' );
//endnavstuff
$fields="
pzid,
pid,
hospno1,
listeddate,
consultant,
surgeon,
priority,
status,
category,
proced,
DATEDIFF(CURDATE(),listeddate)+1 as DOL,
shortnotice,
anaesth,
infxnstatus,
CONCAT(lastname, ', ', firstnames) as patient,
sex, age,
birthdate,
modal,
r.modifstamp
";
$tables="proceddata r LEFT JOIN renalware.patientdata ON pzid=patzid";
$sql="SELECT $fields FROM $tables $where $orderby LIMIT $sr, $pp";
$result = $mysqli->query($sql);
$numfound=$result->num_rows;
if (!$numfound)
	{
	echo "<p class=\"results\">There are no $navtext!</p>";
	}
else
	{
	echo "<p class=\"results\">";
	// include links stuff
	include('incl/makenavlinks.php');
		echo '</p><table class="list"><thead>
		<tr>
		<th>options</th>
		<th>priority</th>
		<th>hospNo</th>
		<th>patient</th>
		<th>sex (age)</th>
		<th>DOB</th>
		<th>modal</th>
		<th>listed <i>(DOL)</i></th>
		<th>consultant</th>
		<th>surgeon</th>
		<th>category</th>
		<th>procedure</th>
		<th>short<br>notice?</th>
		<th>anaesth?</th>
		<th>infxn status</th>
		<th>status</th>
		</tr></thead>';
	while($row = $result->fetch_assoc())
		{
		$pid=$row["pid"];
		$zid=$row["pzid"];
		$patlink = '<a href="../pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . $row["patient"] . '</a>';
		$adminlink = '<a href="../pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		include( 'incl/procedoptions_incl.php' );
		//NB tr background now set in CSS
		$priority=$row["priority"];
		$priority=$row["priority"];
		echo '<tr>
		<td>' . $procedoptions . '</td>
		<td class="' . $priority . '">' . $row["priority"] . '</td>
		<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td>' . $row["sex"] . ' ('.$row["age"].')</td>
		<td>' . dmy($row["birthdate"]) . '</td>
		<td>' . $row["modal"] . '</td>
		<td>' . dmy($row["listeddate"]) . ' <i>(' . $row["DOL"] . ')</i></td>
		<td>' . $row["consultant"] . '</td>
		<td>' . $row["surgeon"] . '</td>
		<td>' . $row["category"] . '</td>
		<td><b>' . $row["proced"] . '</b></td>
		<td>' . $row["shortnotice"] . '</td>
		<td>' . $row["anaesth"] . '</td>
		<td>' . $row["infxnstatus"] . '</td>
		<td>' . $row["status"] . '</td>
		</tr>';
		}
	echo '</table>';
	}

?>