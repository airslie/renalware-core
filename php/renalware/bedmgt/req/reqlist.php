<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//navstuff
$navkey="pid";
$navtable="proceddata";
$pp=0; //results/page 0=all
$url="index.php?vw=req&amp;scr=reqlist$q"; //base URL
$navtext = "KRU <b>PENDING</b> procedure requests recorded"; //default
$where="WHERE status IN ('Req','Susp')"; //default
$orderby="ORDER BY listeddate ASC";
$q="";
if ( $_GET['pzid'] )
	{
	$pzid=$_GET['pzid'];
	$q="&amp;status=Req&amp;pzid=$pzid&amp;";
	$where .= " AND pzid=$pzid";
	//get pat name
	$sql="SELECT concat(firstnames, ' ', UPPER(lastname)) as patient, hospno1 FROM renalware.patientdata WHERE patzid=$pzid";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$patient=$row["patient"];
	$hospno=$row["hospno1"];
	$navtext = "KRU procedures requested for $patient (No $hospno)";
	$pp=0; //for show all
	}
if ( $_GET['hospno'] )
	{
	$hospno=$_GET['hospno'];
	$q="&amp;status=Req&amp;hospno=$hospno&amp;";
	$where .= " AND hospno='$hospno'";
	$navtext = "KRU procedures requested for Hosp No $hospno";
	$pp=0;
	}
if ( $_GET['priority'] )
	{
	$priority=$_GET['priority'];
	$q="&amp;status=Req&amp;priority=$priority&amp;";
	$where .= " AND priority='$priority'";
	$navtext = "KRU $priority procedures requested";
	$pp=0;
	}
if ( $_GET['cat'] )
	{
	$cat=$_GET['cat'];
	$q="&amp;status=Req&amp;cat=$cat&amp;";
	$where .= " AND category='$cat'";
	$navtext = "KRU $cat procedures requested";
	$pp=0;
	}
if ( $_GET['sortby']=='DOL' )
	{
	$q="&amp;status=Req&amp;";
	$navtext = "KRU procedures requested ranked by DOL";
	$orderby="ORDER BY listeddate ASC";
	}

$fields="
pzid,
pid,
hospno,
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
$sql="SELECT $fields FROM $tables $where $orderby";
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
	echo "$numfound $navtext. Click on headers to sort (default=DOL)";
	echo '</p><table class="tablesorter"><thead>
	<tr>
	<th>options</th>
	<th>priority</th>
<th>hospNo</th>
<th>patient</th>
<th>sex</th>
<th>age</th>
<th>DOB</th>
<th>modal</th>
<th>listed</th>
<th>DOL</th>
<th>consultant</th>
<th>surgeon</th>
<th>category</th>
<th>procedure</th>
<th>short<br>notice?</th>
<th>anaesth?</th>
<th>infxn status</th>
<th>status</th>
	</tr></thead><tbody>';
	while($row = $result->fetch_assoc())
		{
		$pid=$row["pid"];
		$zid=$row["pzid"];
		$patlink = '<a href="../pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . $row["patient"] . '</a>';
		$adminlink = '<a href="../pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno"] . '</a>';
		include( 'incl/procedoptions_incl.php' );
		//NB tr background now set in CSS
		$priority=$row["priority"];
		echo '<tr>
		<td>' . $procedoptions . '</td>
		<td class="' . $priority . '">' . $row["priority"] . '</td>
		<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td>' . $row["sex"] . '</td>
		<td>'.$row["age"].'</td>
		<td>' . dmy($row["birthdate"]) . '</td>
		<td>' . $row["modal"] . '</td>
		<td>' . dmy($row["listeddate"]) . '</td>
		<td>' . $row["DOL"] . '</td>
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
	echo '</tbody></table>';
	}

?>