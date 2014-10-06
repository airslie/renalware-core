<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
echo '<div class="searchbox">';
include( 'incl/formstart.php' );
?>
Hosp No:<input type="text" name="hospno" value="" id="hospno" size="16">&nbsp;&nbsp;Surgeon: <?php
$selectname="surg_id";
$optionid='surg_id';
$optionname="CONCAT(surglast, ', ', surgfirst) as surgeon";
$orderby='surglast, surgfirst';
$optiontable='surgeons';
include( 'incl/makeselect.php' );
echo "&nbsp;&nbsp;Procedure: ";
$selectname="procedtype_id";
$optionid='procedtype_id';
$optionname="CONCAT(proced, ' (', upper(category), ')')";
$orderby='category, proced';
$optiontable='procedtypes';
$optionwhere='';
include( 'incl/makeselect.php' );
?>
<input type="submit" value="Continue &rarr;">
</form></div>
<?php
//navstuff
$navkey="pid";
$navtable="proceddata";
$pp=0; //results/page 0=all
$url="index.php?vw=archived&amp;scr=archlist$q"; //base URL
$navtext = "KRU archived procedures recorded"; //default
$where="WHERE status='Arch'"; //default
$orderby="ORDER BY priority ASC";
$q="";

if ( $_GET['surg_id'] )
	{
	$surg_id=$_GET['surg_id'];
	$q="&amp;status=Arch&amp;surg_id=$surg_id&amp;";
	$where .= " AND surg_id=$surg_id";
	//get pat name
	$sql="SELECT CONCAT(surgfirst, ' ', surglast) as surgeon FROM surgeons WHERE surg_id=$surg_id";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$surgeon=$row["surgeon"];
	$navtext = "KRU procedures performed by $surgeon";
	$pp=0; //for show all
	}
if ( $_GET['pid'] )
	{
	//$pid=$_GET['pid'];
	$q="&amp;status=Arch&amp;pid=$pid&amp;";
	$where .= " AND pid=$pid";
	//get pat name
	$sql="SELECT UPPER(proced) FROM proclist WHERE pid=$pid";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$proced=$row["surgeon"];
	$navtext = "KRU $proced" . 's performed';
	$pp=0; //for show all
	}
if ( $_GET['hospno'] )
	{
	$hospno=$_GET['hospno'];
	$q="&amp;status=Arch&amp;hospno=$hospno&amp;";
	$where .= " AND hospno='$hospno'";
	$navtext = "KRU procedures performed for patient Hosp No $hospno";
	$pp=0;
	}

//navstuff
include( 'incl/calcnavlinks.php' );
//endnavstuff
$fields="
pid,
hospno,
listeddate
IF(tcidate, DATE_FORMAT(tcidate, '%a %d %b %y'),'') AS tcidate_ddmy,
IF(preopdate, DATE_FORMAT(preopdate, '%a %d %b %y'),'') AS preopdate_ddmy,
consultant,
surgeon,
priority,
category,
proced,
DATEDIFF(CURDATE(),listeddate)+1 as DOL,
DATE_FORMAT(surgdate, '%d/%m/%Y') AS surgdate,
shortnotice,
anaesth,
CONCAT(lastname, ', ', firstnames) as patient,
sex, age,
birthdate,
modalcode,
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
	<th>hospNo</th>
	<th>patient</th>
	<th>sex (age)</th>
	<th>DOB</th>
	<th>modal</th>
	<th>listed</th>
	<th>TCI date</th>
	<th>Pre-Op Assess?</th>
	<th>consultant</th>
	<th>surgeon</th>
	<th>priority</th>
	<th>category</th>
	<th>procedure</th>
	<th>DOL</th>
	<th>surg date</th>
	<th>short notice?</th>
	<th>anaesth?</th>
	<th>infxn status</th>
	<th>options</th>
	</tr></thead>';
	while($row = $result->fetch_assoc())
		{
		$pid=$row["pid"];
		//flag priority
		$priority=$row["priority"];
		$archiveoptions = "<a href=\"index.php?vw=proced&amp;scr=view&amp;pid=" . $pid . "\">view archived</a>";
		echo '<tr>
		<td>' . $row["hospno"] . '</td>
		<td>' . $row["patient"] . '</td>
		<td>' . $row["sex"] . ' ('.$row["age"].')</td>
		<td>' . dmy($row["birthdate"]) . '</td>
		<td>' . $row["modalcode"] . '</td>
		<td>' . dmy($row["listeddate"]) . '</td>
		<td>' . $row["tcidate_ddmy"] . '</td>
		<td>' . $row["preopdate_ddmy"] . '</td>
		<td>' . $row["consultant"] . '</td>
		<td>' . $row["surgeon"] . '</td>
		<td class="'.$priority.'">' . $row["priority"] . '</td>
		<td>' . $row["category"] . '</td>
		<td><b>' . $row["proced"] . '</b></td>
		<td>' . $row["DOL"] . '</td>
		<td>' . $row["surgdate"] . '</td>
		<td>' . $row["shortnotice"] . '</td>
		<td>' . $row["anaesth"] . '</td>
		<td>' . $row["infxnstatus"] . '</td>
		<td>' . $archiveoptions . '</td>
		</tr>';
		}
	echo '</table>';
	}

?>