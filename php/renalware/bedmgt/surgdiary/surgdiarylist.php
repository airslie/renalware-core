<?php
//----Fri 01 Feb 2013----365 days option
//---------------Tue Jan 12 16:59:20 CET 2010---------------new $get_period SQL
//navstuff
$navkey="diarydate_id";
$navtable="diarydates";
$pp=31; //results/page 0=all
$url="index.php?vw=surgdiary&amp;scr=surgdiarylist$q"; //base URL
$navtext = "KRU diary entries available"; //default
$where=""; //default
$orderby="ORDER BY diarydate,mgtintent,priority";
$q="";
if ( $_GET['zid'] )
	{
	$zid=(int)$_GET['zid'];
	$q="&amp;zid=$zid&amp;";
	$where = "WHERE slot1zid=$zid OR slot2zid=$zid OR slot3zid=$zid OR slotEzid=$zid";
	//get pat name
	$sql="SELECT concat(firstnames, ' ', UPPER(lastname)) as patient, hospno1 FROM renalware.patientdata WHERE patzid=$zid";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$patient=$row["patient"];
	$hospno=$row["hospno1"];
	$navtext = "KRU diary slots scheduled for $patient (No $hospno)";
	$pp=0; //for show all
	}
if ( $_GET['hospno'] )
	{
	$hospno=$_GET['hospno'];
	$q="&amp;hospno=$hospno&amp;";
	//get pat name and zid
	$sql="SELECT concat(firstnames, ' ', UPPER(lastname)) as patient, patzid FROM renalware.patientdata WHERE hospno1='$hospno'";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$patient=$row["patient"];
	$zid=$row["patzid"];
	$where = "WHERE slot1zid=$zid OR slot2zid=$zid OR slot3zid=$zid OR slotEzid=$zid";
	$navtext = "KRU diary slots scheduled for $patient (No $hospno)";
	$pp=0; //for show all
	}
//datesearches
//range
if ( $_GET['diarystart'] && $_GET['diaryend'] )
	{
	$diarystart=$_GET['diarystart'];
	$diaryend=$_GET['diaryend'];
	$diarystartdate=fixDate($diarystart);
	$diaryenddate=fixDate($diaryend);
	$where = "WHERE diarydate BETWEEN '$diarystartdate' AND '$diaryenddate'";
	$navtext = "KRU diary days between $diarystart and $diaryend";
	$orderby="ORDER BY diarydate";
	$pp=0; //for show all
	}
if ($get_period) //may be passed via e.g. opstoday.php
	{
	$q="&amp;period=$get_period&amp;";
	switch ($get_period) {
		case "today":
			$where = "WHERE diarydate='$todayymd'";
			break;
		case "tomorrow":
			$where = "WHERE diarydate='$tomorrymd'";
			break;
		case "thisweek":
			$where = "WHERE WEEK(diarydate)=WEEK(CURDATE()) AND YEAR(diarydate)=$thisyear";
			break;
		case "nextweek":
			$where = "WHERE WEEK(diarydate)=WEEK(CURDATE())+1 AND YEAR(diarydate)=$thisyear";
			break;
		case "thismonth":
			$where = "WHERE MONTH(diarydate)=$thismonthno AND YEAR(diarydate)=$thisyear";
			break;
		case "nextmonth":
			$where = "WHERE MONTH(diarydate)=$nextmonthno AND YEAR(diarydate)=$nextmonthyear";
			break;
		case "next90days":
			$where = "WHERE DATEDIFF(diarydate,CURDATE())<=90 AND diarydate>=NOW()";
			break;
		case "next365days":
			$where = "WHERE DATEDIFF(diarydate,CURDATE())<366 AND diarydate>=NOW()";
			break;
		case "nextfortnight":
			$where = "WHERE DATEDIFF(diarydate,CURDATE())<=14";
			break;
		}
	$pp=1000; //show all in any case
	}
//navstuff
include( 'incl/calcnavlinks.php' );
//endnavstuff
$fields="
diarydate, daynotes,
DATE_FORMAT(diarydate, '%a %d %b %Y') AS diarydate_ddmy,
availslots,
pid,
pzid,
hospno1,
IF(preopdate, DATE_FORMAT(preopdate, '%a %d %b %y'),'') AS preopdate_ddmy,
consultant,
surgeon,
priority,
proced,
mgtintent,
surgslot,
CONCAT(lastname, ', ', firstnames) as patient,
birthdate,
modalcode,
LEFT(schednotes, 25) as commentstrunc,
schednotes as comments,
p.modifstamp,
status,
DATEDIFF(CURDATE(),listeddate)+1 as DOL";
$tables="diarydates d LEFT JOIN proceddata p ON diarydate=surgdate LEFT JOIN renalware.patientdata ON pzid=patzid";
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
	<th>priority/status</th>
	<th>hospNo</th>
	<th>patient</th>
	<th>DOB</th>
	<th>surgeon</th>
	<th>DOL</th>
	<th>procedure</th>
	<th>Modality</th>
	<th>Pre-Assess Date</th>
	<th>Comments (hover to view)</th>
	<th>Options</th>
	</tr></thead>';
//set prevs
$prevdate="";
$prevmgtintent="";
	while($row = $result->fetch_assoc())
		{
		$thisdate=$row["diarydate"];
		$showavail=""; //reset
		$avail=$row["availslots"];
		if ( $avail )
		{
		$showavail="(avail: $avail)";
		}
		//set diary date prn
		if ( $thisdate != $prevdate )
		{
		echo '<tr><td class="diarydate" colspan="11"><span class="diaryday">' . $row["diarydate_ddmy"] . '</span> &nbsp;<a class="small" href="index.php?vw=glance&amp;scr=dayview&ymd=' . $thisdate . '">view/edit day</a> ' . $showavail . '</small>';
		if ( $row["daynotes"] )
			{
			$daynotes=nl2br($row["daynotes"]);
			echo '<div class="daynotes">' . $daynotes . '</div>';
			}
		echo '</td></tr>';
		}
		$thismgtintent=$row["mgtintent"];
		if ( $thismgtintent != $prevmgtintent )
		{
		echo '<tr><td class="mgtintent" colspan="12"><h4>' . $mgtintents[$thismgtintent] . '</h4></td></tr>';
		}
		//set colors
		$pid=$row["pid"];
		$zid=$row["pzid"];
		//flag priority
		$priority=$row["priority"]; //default
		$status=$row["status"]; //default
		$patlink = '<a href="../pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . $row["patient"] . '</a>';
		$adminlink = '<a href="../pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		$comments='<a title="' . $row["comments"] . '">' . $row["commentstrunc"] . '</a>';
		include( 'incl/procedoptions_incl.php' );
		if ($row["pid"] )
		{
		echo '<tr>
		<td class="' . $priority . '">' . $priority .'/'.$status . '</td>
		<td>' . $adminlink . '</td>
		<td>' . $patlink . '</td>
		<td>' . dmy($row["birthdate"]) . '</td>
		<td>' . $row["consultant"] .'/'.$row["surgeon"] . '</td>
		<td>' . $row["DOL"] . '</td>
		<td><b>' . $row["proced"] . '</b></td>
		<td>' . $row["modalcode"] . '</td>
		<td>' . $row["preopdate_ddmy"] . '</td>
		<td>' . $comments . '</td>
		<td>' . $schedoptions . '&nbsp;&nbsp;' . $patviewlink . '</td>
		</tr>';
		}
		$prevdate=$thisdate;
		$prevmgtintent=$thismgtintent;
		}
	echo '</table>';
	}
