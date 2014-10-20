<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " PD Patient List";
//get header
include '../parts/head.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
?>
<p><a class="ui-state-default" style="color: green; background: white;" href="renal/screens.php?s=pd_patients" >View PD Screens by patient</a> (Opens in new window)</p>
<?php
//get total
$display = 500; //default
$displaytext = "$siteshort PD patients"; //default
$where = "WHERE modalcode LIKE '%PD%'";  // default
$orderby = "ORDER BY lastname, firstnames"; //default
$displaytime = date("D j M Y  G:i:s");
$fields = "patzid, hospno1, lastname, firstnames, sex, birthdate, age, modalcode, modalsite, endstagedate, txWaitListStatus, accessCurrent";
$tables = "renalware.patientdata JOIN renaldata ON patzid=renalzid LEFT JOIN pdpatdata ON patzid=pdpatzid";
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $display";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	} else
	{
	echo "<p class=\"header\">$numrows $displaytext ($numrows displayed). Click on headers to sort.</p>";
	echo '<table class="tablesorter"><thead>
	<tr>
	<th>options</th>
	<th>Hosp No</th>
	<th>patient</th>
	<th>age</th>
	<th>sex</th>
	<th>DOB</th>
    <th>Modal--Site</th>
    <th>ESRF date</th>
    <th>TxWaitList</th>
    <th>Access</th>
    </tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$zid = $row["patzid"];
		$showage = ($row["modalcode"]=='death' ? '' : ' <i>(' . $row["age"] . ')</i>');
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$modalslink = '<a href="pat/patient.php?vw=modals&amp;zid=' . $zid . '">' . $row["modalcode"] . '</a>';
		$esrflink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=esrf">' . dmy($row["endstagedate"]) . '</a>';
		$txlink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=txstatus">' . $row["txWaitListStatus"] . '</a>';
		$accesslink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=access">' . $row["accessCurrent"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		$pdlink = '<a class="gr" href="renal/renal.php?scr=pd&amp;zid=' . $zid . '">PD info</a>';
		echo "<tr>
		<td>$pdlink</td>
		<td>$adminlink</td>
		<td>$patlink</td>
		<td>" . $row["age"] . '</td><td>' . $row["sex"]. "</td>
		<td>" . dmy($row["birthdate"])  . "</td>
		<td>$modalslink</td>
		<td>$esrflink</td>
		<td>$txlink</td>
		<td>$accesslink</td></tr>";
		}
	echo '</tbody></table>';
	}
 include '../parts/footer.php';
?>