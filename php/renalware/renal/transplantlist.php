<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Transplant Patient List";
include "$rwarepath/navs/topsimplenav.php";
?>
<a class="ui-state-default" style="color: green;"  href="renal/txwaitlist.php" target="new">Print Transplant Waiting List</a><br>
<?php
//get total
$display = 500; //default
$displaytext = "$siteshort Transplant patients"; //default
$where = "WHERE modalcode LIKE 'Tx%'";  // default
$orderby = "ORDER BY lastname, firstnames"; //default
$fields = "patzid, hospno1, lastname, firstnames, sex, birthdate,age, modalcode, modalsite, endstagedate, txWaitListStatus, accessCurrent";
$tables = "renalware.patientdata JOIN renaldata ON patzid=renalzid";
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $display";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	} else
	{
	echo "<p class=\"header\">$numrows $displaytext ($numrows displayed).</p>";
	echo "<table class=\"tablesorter\"><thead>
	<tr>
	<th>$hosp1label</th>
	<th>patient</th>
	<th>sex</th>
	<th>DOB <i>(age)</i></th>
    <th>Modal--Site</th>
    <th>ESRF date</th>
    <th>TxWaitList</th>
    <th>Access</th>
    </tr></thead><tbody>";
	while ($row = $result->fetch_assoc()) {
		$zid = $row["patzid"];
		$showage = ($row["modalcode"]=='death' ? '' : ' <i>(' . $row["age"] . ')</i>');
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
		$modalslink = '<a href="pat/patient.php?vw=modals&amp;zid=' . $zid . '">' . $row["modalcode"] . ' '. $row["modalsite"] . '</a>';
		$esrflink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=esrf">' . dmy($row["endstagedate"]) . '</a>';
		$txlink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=txstatus">' . $row["txWaitListStatus"] . '</a>';
		$accesslink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=access">' . $row["accessCurrent"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		echo "<tr>
		<td>$adminlink</td>
		<td>$patlink</td>
		<td>" . $row["sex"] . "</td>
		<td>" . dmy($row["birthdate"]) . ' ' . $row["age"] . "</td>
		<td>$modalslink</td>
		<td>$esrflink</td>
		<td>$txlink</td>
		<td>$esdlink</td>
		<td>$accesslink</td></tr>";
		}
	echo '</tbody></table>';
	}
 include '../parts/footer.php';
?>