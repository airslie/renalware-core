<i>Note: for additional data (e.g. TCI, Pre-OP dates, anaesth etc) view the Requests and Scheduled listings.</i><br><br>
<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
include( 'incl/formstart.php' );
?>
<fieldset>
Search by <b>Hosp No:</b><input type="text" name="hospno" value="" id="hospno" size="16">&nbsp;&nbsp;<b>Surgeon:</b> <?php
$selectname="surg_id";
$optionid='surg_id';
$optionname="CONCAT(surglast, ', ', surgfirst) as surgeon";
$orderby='surglast, surgfirst';
$optiontable='surgeons';
include( 'incl/makeselect.php' );
echo "&nbsp;&nbsp;<b>Procedure:</b> ";
$selectname="procedtype_id";
$optionid='procedtype_id';
$optionname="CONCAT(proced, ' (', upper(category), ')')";
$orderby='category, proced';
$optiontable='procedtypes';
$optionwhere='';
include( 'incl/makeselect.php' );
?><br>
<b>Surg Date:</b><input type="text" name="surgdatedmy" value="" id="surgdatedmy" size="12">&nbsp;&nbsp; or <b>Surg Date between:</b><input type="text" name="surgstartdatedmy" value="" id="surgstartdatedmy" size="12"> and <input type="text" name="surgenddatedmy" value="" id="surgenddatedmy" size="12">
<input type="submit" value="Continue &rarr;">
</fieldset>
</form>
<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//navstuff
$navkey="pid";
$navtable="proceddata";
$pp=0; //results/page 0=all
$url="index.php?vw=user&amp;scr=searchproceds$q"; //base URL
$navtext = "KRU procedures recorded)"; //default
$where=""; //default
$orderby="ORDER BY r.addstamp ASC";
$q="";
if ( $_GET['hospno'] )
	{
	$hospno=$_GET['hospno'];
	$q="&amp;hospno=$hospno&amp;";
	$where = "WHERE hospno='$hospno'";
	$navtext = "KRU procedures recorded for Hosp No $hospno";
	$pp=0;
	}
if ( $_GET['surg_id'] )
	{
	$surg_id=$_GET['surg_id'];
	$q="&amp;surg_id=$surg_id&amp;";
	$where = "WHERE surg_id='$surg_id'";
	$navtext = "KRU procedures recorded for Surgeon No $surg_id";
	$pp=0;
	}
if ( $_GET['procedtype_id'] )
	{
	$procedtype_id=$_GET['procedtype_id'];
	$q="&amp;procedtype_id=$procedtype_id&amp;";
	$where = "WHERE procedtype_id='$procedtype_id'";
	$navtext = "KRU procedures recorded for Proced No $procedtype_id";
	$pp=0;
	}
if ( $_GET['priority'] )
	{
	$priority=$_GET['priority'];
	$q="&amp;priority=$priority&amp;";
	$where = "WHERE priority='$priority'";
	$navtext = "KRU $priority procedures recorded";
	$pp=0;
	}
if ( $_GET['cat'] )
	{
	$cat=$_GET['cat'];
	$q="&amp;cat=$cat&amp;";
	$where = "WHERE category='$cat'";
	$navtext = "KRU $cat procedures archived";
	$pp=0;
	}
if ( $_GET['surgdatedmy'])
	{
	$surgdatedmy=$_GET['surgdatedmy'];
	$surgdate=fixDate($surgdatedmy);
	$q="&amp;";
	$where = "WHERE surgdate='$surgdate'";
	$navtext = "KRU procedures for surgery on $surgdatedmy";
	$orderby="ORDER BY listeddate";
	}
if ( $_GET['surgstart'] && $_GET['surgend'] )
	{
	$surgstart=$_GET['surgstart'];
	$surgend=$_GET['surgend'];
	$surgstartdate=fixDate($surgstart);
	$surgenddate=fixDate($surgend);
	$q="&amp;";
	$where = "WHERE surgdate BETWEEN '$surgstartdate' AND '$surgenddate'";
	$navtext = "KRU procedures for surgery between $surgstart and $surgend";
	$orderby="ORDER BY listeddate";
	}
//navstuff
include( 'incl/calcnavlinks.php' );
//endnavstuff
$fields="
pid,
hospno,
listeddate
consultant,
surgeon,
priority,
category,
status,
proced,
DATEDIFF(CURDATE(),listeddate)+1 as DOL,
DATE_FORMAT(surgdate, '%d/%m/%Y') AS surgdate,
CONCAT(lastname, ', ', firstnames) as patient,
sex, age,
birthdate,
modalcode,
r.modifstamp
";
$tables="proceddata r LEFT JOIN renalware.patientdata p ON pzid=patzid";
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
<th>hospNo</th>
<th>patient</th>
<th>sex (age)</th>
<th>DOB</th>
<th>modal</th>
<th>listed</th>
<th>consultant</th>
<th>surgeon</th>
<th>priority</th>
<th>category</th>
<th>procedure</th>
<th>DOL</th>
<th>surg date</th>
<th>status</th>
<th>options</th>
	</tr>';
	while($row = $result->fetch_assoc())
		{
		//set colors
		
		$pid=$row["pid"];
		//flag priority
		if ( $row["priority"]=="Urgent" )
		{
			$bg='#FFCC00';
		}
		if ( $row["priority"]=="Soon" )
		{
			$bg='#ffff33';
		}
		$searchoptions = "<a href=\"index.php?vw=proced&amp;scr=view&amp;pid=" . $pid . "\">view</a>";
		echo '<tr>
		<td>' . $row["hospno"] . '</td>
		<td>' . $row["patient"] . '</td>
		<td>' . $row["sex"] . ' ('.$row["age"].')</td>
		<td>' . dmy($row["birthdate"]) . '</td>
		<td>' . $row["modalcode"] . '</td>
		<td>' . dmy($row["listeddate"]) . '</td>
		<td>' . $row["consultant"] . '</td>
		<td>' . $row["surgeon"] . '</td>
		<td>' . $row["priority"] . '</td>
		<td>' . $row["category"] . '</td>
		<td><b>' . $row["proced"] . '</b></td>
		<td>' . $row["DOL"] . '</td>
		<td>' . $row["surgdate"] . '</td>
		<td>' . $row["status"] . '</td>
		<td>' . $searchoptions . '</td>
		</tr>';
		}
	echo '</table>';
	}

?>