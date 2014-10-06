<?php
//----Thu 14 Feb 2013----handle 365d period
//Thu Mar  1 15:36:27 CET 2007 cols dumbed down per excel specs :(
//Tue Apr  3 15:07:53 CEST 2007 comments on new line(s)
//---------------Tue Jan 12 16:59:20 CET 2010---------------new $get_period SQL
//navstuff
$navkey="pid";
$navtable="diarydates d LEFT JOIN proceddata p ON diarydate=tcidate";
$pp=0; //results/page 0=all
$url="index.php?vw=admdiary&amp;scr=admdiarylist$q"; //base URL
$navtext = "KRU scheduled procedures recorded for this period"; //default
$where="WHERE status='Sched'"; //default
$orderby="ORDER BY diarydate,mgtintent,priority";
$q="";
if ( $_GET['pzid'] )
	{
	$pzid=$_GET['pzid'];
	$q="&amp;status=Sched&amp;pzid=$pzid&amp;";
	$where .= " AND pzid=$pzid";
	//get pat name
	$sql="SELECT concat(firstnames, ' ', UPPER(lastname)) as patient, hospno1 FROM renalware.patientdata WHERE patzid=$pzid";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$patient=$row["patient"];
	$hospno=$row["hospno1"];
	$navtext = "KRU procedures scheduled for $patient (No $hospno)";
	$pp=0; //for show all
	}
if ( $_GET['hospno'] )
	{
	$hospno=$_GET['hospno'];
	$q="&amp;status=Sched&amp;hospno=$hospno&amp;";
	$where .= " AND hospno='$hospno'";
	$navtext = "KRU procedures scheduled for Hosp No $hospno";
	$pp=0;
	}
if ( $_GET['priority'] )
	{
	$priority=$_GET['priority'];
	$q="&amp;status=Sched&amp;priority=$priority&amp;";
	$where .= " AND priority='$priority'";
	$navtext = "KRU $priority procedures scheduled";
	$pp=0;
	}
if ( $_GET['cat'] )
	{
	$cat=$_GET['cat'];
	$q="&amp;status=Sched&amp;cat=$cat&amp;";
	$where .= " AND category='$cat'";
	$navtext = "KRU $cat procedures scheduled";
	$pp=0;
	}
if ( $_GET['sortby']=='DOL' )
	{
	$q="&amp;status=Sched&amp;";
	$navtext = "KRU procedures scheduled ranked by DOL";
	$orderby="ORDER BY listeddate ASC";
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
pid,
pzid,
hospno1,
tcidate,
IF(tcidate, DATE_FORMAT(tcidate, '%a %d %b %y'),'') AS tcidate_ddmy,
consultant,
surgeon,
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
$tables="diarydates d LEFT JOIN proceddata p ON diarydate=tcidate LEFT JOIN renalware.patientdata ON pzid=patzid";
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
	echo '</p><table class="list">
	<tr>
	<th>priority/status</th>
	<th>HospNo</th>
	<th>Patient</th>
	<th>DOL</th>
	<th>Procedure</th>
	<th>Consult/Surg</th>
	<th>Infxn status</th>
	<th>Tel No</th>
	<th>Comments (hover to view)</th>
	<th>Options</th>
	</tr>';
//set prevs
$prevdate="";
$prevmgtintent="";
while($row = $result->fetch_assoc())
	{
	$thisdate=$row["diarydate"];
	//set diary date prn
	if ( $thisdate != $prevdate )
	{
	echo '<tr><td class="diarydate" colspan="12"><span class="diaryday">' . $row["diarydate_ddmy"] . '</span> &nbsp;<a class="small" href="index.php?vw=glance&amp;scr=dayview&ymd=' . $thisdate . '">view day</a>';
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
	//flag priority TD
	$priority=$row["priority"]; //default
	$status=$row["status"]; //default
	$priorityclass=$priority;
	$patlink = '<a href="../pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . $row["patient"] . '</a>';
	$adminlink = '<a href="../pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
	$comments='<a title="' . $row["comments"] . '">' . $row["commentstrunc"] . '</a>';
	include( 'incl/procedoptions_incl.php' );
	if ( $row["pid"] )
	{
		echo '<tr>
		<td class="' . $priority . '">' . $priority .'/'.$status . '</td>
		<td>' . $adminlink . '</td>
		<td>' . $patlink . ' (' . $row["modalcode"] . ')</td>
		<td>' . $row["DOL"] . '</td>
		<td><b>' . $row["proced"] . '</b></td>
		<td>' . $row["consultant"] .'/'.$row["surgeon"] . '</td>
		<td>' . $row["infxnstatus"] . '</td>
		<td>' . $row["tel1"] . '</td>
		<td>' . $comments . '</td>
		<td>' . $schedoptions . '&nbsp;&nbsp;' . $patviewlink . '</td>
		</tr>';
	}
	$prevdate=$thisdate;
	$prevmgtintent=$thismgtintent;
	}
echo '</table>';
}
