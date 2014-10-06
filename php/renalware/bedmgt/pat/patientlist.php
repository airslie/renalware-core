<?php
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
echo '<div class="searchbox">';
include( 'incl/formstart.php' );
?>
<fieldset>
	<legend>Search Patient Procedures</legend>
	Hosp No:<input type="text" name="hospno" value="" id="hospno" size="16">&nbsp;&nbsp;Pat Surname:<input type="text" name="lastname" value="" id="lastname" size="16">&nbsp;&nbsp;Surgeon: <?php
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
</fieldset></form></div>
<?php
//navstuff
$navkey="pid";
$navtable="proceddata";
$url="index.php?vw=pat&amp;scr=renalpatlist$q"; //base URL
$navtext = "KRU patient procedures recorded"; //default
$where=""; //default
$orderby="ORDER BY priority ASC";

if ( $_GET['surg_id'] )
	{
	$surg_id=$_GET['surg_id'];
	$where = "WHERE surg_id=$surg_id";
	//get pat name
	$sql="SELECT CONCAT(surgfirst, ' ', surglast) as surgeon FROM surgeons WHERE surg_id=$surg_id";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$surgeon=$row["surgeon"];
	$navtext = "KRU procedures performed by <b>$surgeon</b>";
	$pp=0; //for show all
	}
if ( $_GET['pid'] )
	{
	//$pid=$_GET['pid'];
	$where = "WHERE pid=$pid";
	//get pat name
	$sql="SELECT UPPER(proced) FROM proclist WHERE pid=$pid";
	$result = $mysqli->query($sql);
	$row = $result->fetch_assoc();
	$proced=$row["surgeon"];
	$navtext = "KRU <b>$proced</b>" . 's performed';
	}
if ( $_GET['hospno'] )
	{
	$hospno=$_GET['hospno'];
	$where = "WHERE hospno='$hospno'";
	$navtext = "KRU procedures performed for patient Hosp No <b>$hospno</b>";
	}
if ( $_GET['lastname'] )
	{
	$lastname=html_entity_decode($_GET['lastname']);
	$lastname=strtoupper($lastname);
	$where = "WHERE UPPER(lastname) LIKE '$lastname%'";
	$navtext = "KRU procedures performed for patient(s) with lastname like <b>$lastname</b>";
	}
$fields="
pzid,
pid,
hospno,
listeddate
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
modalcode
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
	echo "<p class=\"results\">$numfound $navtext.</p>";
	// include links stuff
	echo '<table class="list">
	<tr>
	<th>priority</th>
<th>hospNo</th>
<th>patient</th>
<th>sex (age)</th>
<th>DOB</th>
<th>modality</th>
<th>listed</th>
<th>category</th>
<th>procedure</th>
<th>DOL</th>
<th>surg date</th>
<th>options</th>
	</tr>';
	while($row = $result->fetch_assoc())
		{
		$pid=$row["pid"];
		$pzid=$row["pzid"];
		$priority=$row["priority"];
		$procedview = "<a href=\"index.php?vw=proced&amp;scr=view&amp;pid=" . $pid . "\">view procedure</a>";
		$patview="<a href=\"index.php?vw=pat&amp;scr=patview&amp;zid=$pzid\">patview</a>";
		echo '<tr>
			<td class="' . $priority . '">' . $row["priority"] . '</td>
		<td>' . $row["hospno"] . '</td>
		<td>' . $row["patient"] . '</td>
		<td>' . $row["sex"] . ' ('.$row["age"].')</td>
		<td>' . dmy($row["birthdate"]) . '</td>
		<td>' . $row["modalcode"] . '</td>
		<td>' . dmy($row["listeddate"]) . '</td>
		<td>' . $row["category"] . '</td>
		<td><b>' . $row["proced"] . '</b></td>
		<td>' . $row["DOL"] . '</td>
		<td>' . $row["surgdate"] . '</td>
		<td>' . $procedview . '&nbsp;&nbsp;' .$patview . '</td>
		</tr>';
		}
	echo '</table>';
	}

?>