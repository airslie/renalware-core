<?php
//----Sat 03 Jul 2010----
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Low Clearance Patient List";
//get header
include '../parts/head.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
?>
<p><a class="ui-state-default" style="color: green; background: white;" href="renal/screens.php?s=lowclear_patients" >View LCC Screens by patient</a> (Opens in new window)</p>
<?php
//get total
$display = 500; //default
$displaytext = "$siteshort Low Clearance patients"; //default
$where = "WHERE modalcode = 'lowclear'";  // default
$orderby = "ORDER BY lastname, firstnames"; //default
$fields = "patzid, hospno1, lastname, firstnames, sex, birthdate, age, modalcode, modalsite, lowDialPlan, lowPredictedESRFdate";
$tables = "renalware.patientdata JOIN renaldata ON patzid=renalzid";
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
    <th>Dial Plan</th>
    <th>Pred ESRF Date</th>
    </tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$zid = $row["patzid"];
		$showage = ($row["modalcode"]=='death' ? '' : ' <i>(' . $row["age"] . ')</i>');
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$modalslink = '<a href="pat/patient.php?vw=modals&amp;zid=' . $zid . '">' . $row["modalcode"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		$scrlink = '<a class="gr" href="renal/renal.php?scr=lowclear&amp;zid=' . $zid . '">LowClear info</a>';
		echo "<tr>
		<td>$scrlink</td>
		<td>$adminlink</td>
		<td>$patlink</td>
		<td>" . $row["age"] . '</td>
		<td>' . $row["sex"]. "</td>
		<td>" . dmy($row["birthdate"])  . "</td>
		<td>$modalslink</td>
		<td>".$row["lowDialPlan"]."</td>
		<td>".$row["lowPredESRFdate"]."</td>
		</tr>";
		}
	echo '</tbody></table>';
	}
 include '../parts/footer.php';
?>