<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Clinical Study Patient List";
include "$rwarepath/navs/topsimplenav.php";
?>
<form action="lists/clinstudypatlist.php" method="get"><fieldset><select name="study_id"><option value="">Select Clinical Study...</option>
<?php
$sql= "select study_id, studyname, (SELECT count(clinstudyzid) FROM clinstudypatdata d WHERE study_id=studyid) as patcount FROM clinstudylist l ORDER BY studyname";
$result = $mysqli->query($sql);
while ($row = $result->fetch_assoc())
	{
	echo '<option value="' . $row['study_id'] . '">' . $row['studyname'] . ' (' . $row['patcount'] . ')</option>';
	}
?></select><input type="submit" style="color: green;" value="Find Clinical Study patients" /></fieldset></form>
<p><a class="ui-state-default" style="color: green;" href="lists/clinstudypatlist.php">Show all</a>&nbsp;&nbsp;
<a class="ui-state-default" style="color: #333;" href="lists/clinstudieslist.php">View Studies &amp; Add Patients</a>
</p><?php
if ( $_GET['termid'] )
{
	$termid=$_GET['termid'];
	$sql= "UPDATE clinstudypatdata SET termdate=NOW() WHERE clinstudypat_id=$termid LIMIT 1";
	$result = $mysqli->query($sql);
	echo "<p class=\"alertsmall\">The clinical study subject has vanished into the ether!</p>";
}
$displaytext = "$siteshort clinical study patient(s)"; //default
$orderby = "ORDER BY lastname, firstnames"; //incl ORDER BY prn
$fields = "clinstudypat_id, patzid, hospno1, nhsno, lastname, firstnames, sex, birthdate,age, modalcode, studyid, DATE_FORMAT(patadddate, '%d/%m/%Y') AS patadddate_dmy, studyname, studyleader";
$tables = "clinstudypatdata cpats JOIN clinstudylist ON studyid=study_id JOIN patientdata ON patzid=clinstudyzid";
$where = ""; // default
if($_GET["study_id"])
	{
	$where = "WHERE studyid='$get_study_id'"; // default
	}
$sql= "SELECT $fields FROM $tables $where $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no such active study patients!</p>";
	} else
	{
	echo "<p class=\"header\">$numrows $displaytext. Click on headers to sort.</p>";
	echo "<table class=\"tablesorter\"><thead>
	<tr>
	<th>options</th>
	<th>$hosp1label</th>
	<th>patient</th>
	<th>sex</th>
	<th>DOB</th>
	<th>age</th>
	<th>curr modal</th>
	<th>Study</th>
	<th>Study Leader</th>
	<th>Date Added</th>
	</tr></thead><tbody>";
	while ($row = $result->fetch_assoc()) {
		$trclass = ($row["modalcode"]=="death") ? "death" : "" ;
		$zid = $row["patzid"];
		$dob=dmyyyy($row["birthdate"]);
		$adddate=dmyyyy($row["patadddate"]);
		$showage = ($row["modalcode"]=='death') ? '' : $row["age"];
		$termlink = '<a href="lists/clinstudypatlist.php?study_id=' . $get_study_id . '&amp;termid='.$row["clinstudypat_id"].'">delete pat</a>';
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		echo "<tr class=\"$trclass\">
		<td>$termlink</td>
		<td>$adminlink</td>
		<td>$patlink</td>
		<td>" . $row["sex"] . "</td>
		<td>" . $dob . "</td>
		<td>" . $row["age"] . "</td>
		<td>" . $row['modalcode'] ."</td>
		<td>" . $row["studyname"] . '</td>
		<td>' . $row["studyleader"] . '</td>
		<td>' . $adddate . '</td></tr>';
		}
	echo '</tbody></table>';
	}
 include '../parts/footer.php';
?>