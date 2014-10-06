<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//navstuff
//Tue Apr  3 14:30:02 CEST 2007 reduced No of columns
$navkey="pid";
$navtable="proceddata";
$pp=0; //results/page 0=all
$url="index.php?vw=arch&amp;scr=archlist$q"; //base URL
$navtext = "KRU archived procedures recorded"; //default
$where="WHERE status='Arch'"; //default
$orderby="ORDER BY priority ASC";
$q="";
if ( $_GET['pzid'] )
	{
	$pzid=$_GET['pzid'];
	$q="&amp;status=Arch&amp;pzid=$pzid&amp;";
	$where .= " AND pzid=$pzid";
	//get pat name
	$sql="SELECT concat(firstnames, ' ', UPPER(lastname)) as patient, hospno1 FROM renalware.patientdata WHERE patzid=$pzid";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$patient=$row["patient"];
	$hospno=$row["hospno1"];
	$navtext = "KRU procedures archived for $patient (No $hospno)";
	$pp=0; //for show all
	}
if ( $_GET['hospno'] )
	{
	$hospno=$_GET['hospno'];
	$q="&amp;status=Arch&amp;hospno=$hospno&amp;";
	$where .= " AND hospno='$hospno'";
	$navtext = "KRU procedures archived for Hosp No $hospno";
	$pp=0;
	}
if ( $_GET['priority'] )
	{
	$priority=$_GET['priority'];
	$q="&amp;status=Arch&amp;priority=$priority&amp;";
	$where .= " AND priority='$priority'";
	$navtext = "KRU $priority procedures archived";
	$pp=0;
	}
if ( $_GET['cat'] )
	{
	$cat=$_GET['cat'];
	$q="&amp;status=Arch&amp;cat=$cat&amp;";
	$where .= " AND category='$cat'";
	$navtext = "KRU $cat procedures archived";
	$pp=0;
	}
if ( $_GET['sortby']=='DOL' )
	{
	$q="&amp;status=Arch&amp;";
	$navtext = "KRU procedures archived ranked by DOL";
	$orderby="ORDER BY listeddate ASC";
	}
//navstuff
include( 'incl/calcnavlinks.php' );
//endnavstuff
$fields="
pid,
pzid,
hospno1,
consultant,
surgeon,
category,
proced,
DATEDIFF(surgdate,listeddate)+1 as DOL,
DATE_FORMAT(surgdate, '%d/%m/%Y') AS surgdate,
opoutcome,
CONCAT(lastname, ', ', firstnames) as patient,
sex, age,
birthdate,
modal,
priority";
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
	<th>hospNo</th>
	<th>patient</th>
	<th>sex (age)</th>
	<th>DOB</th>
	<th>modal</th>
	<th>consultant</th>
	<th>surg date (DOL)</th>
	<th>surgeon</th>
	<th>category</th>
	<th>procedure (click to view)</th>
	<th>outcome</th>
	</tr></thead>';
	while($row = $result->fetch_assoc())
		{
		$pid=$row["pid"];
		$zid=$row["pzid"];
		$viewproced = "<a href=\"index.php?vw=proced&amp;scr=view&amp;pid=" . $pid . "\">" . $row["proced"] . "</a>";
		$patviewlink="<a href=\"index.php?vw=pat&amp;scr=patview&amp;zid=$zid\">patview</a>";
		$procedoptions = '<a href="index.php?vw=proced&amp;scr=update&amp;zid=' . $zid . '&amp;pid=' . $pid . '">update/salvage</a>';
		$priority=$row["priority"];
		//NB tr background now set in CSS
		echo '<tr>
		<td>' . $procedoptions . '&nbsp;&nbsp;'.$patviewlink .'</td>
		<td>' . $row["hospno1"] . '</td>
		<td>' . $row["patient"] . '</td>
		<td>' . $row["sex"] . ' ('.$row["age"].')</td>
		<td>' . dmy($row["birthdate"]) . '</td>
		<td>' . $row["modal"] . '</td>
		<td>' . $row["consultant"] . '</td>
		<td>' . $row["surgdate"] . ' (' . $row["DOL"] . ')</td>
		<td>' . $row["surgeon"] . '</td>
		<td>' . $row["category"] . '</td>
		<td><b>' . $viewproced . '</b></td>
		<td><i>' . $row["opoutcome"] . '</i></td>
		</tr>';
		}
	echo '</table>';
	}
