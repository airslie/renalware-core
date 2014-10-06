<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Transplant Waiting List for " . date("D d/m/Y");
//get header
include '../parts/head.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
?>
<!--content here-->
<?php
$displaytext = "$siteshort Transplant Waiting List patients"; //default
$where = "WHERE txWaitListStatus ='Active' OR txWaitListStatus='Suspended'";
$orderby = "ORDER BY txWaitListStatus, lastname, firstnames"; //incl ORDER BY prn
$fields = "patzid, hospno1,lastname, firstnames, sex, birthdate,
age, modalcode,
endstagedate,
txWaitListEntryDate,
txWaitListModifDate,
txWaitListStatus,txAbsHighest,
txAbsHighestDate,
txAbsLatest,
txAbsLatestDate,
txBloodGroup,txNoGrafts,if(txAbsLatest>60, 'Sensitised', 'Unsensitised') as txSensStatus,txTransplType";
$sql= "SELECT $fields from patientdata JOIN renaldata d ON patzid=renalzid $where $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
	echo "<p class=\"header\">$numrows $displaytext</p>";
	//set defaults
	$status="";
	$sens="";
	echo '<table class="list">';
	while ($row = $result->fetch_assoc()) {
		if ( $row["txWaitListStatus"] != $status)
			{
			echo '<tr><td colspan="13"><h3>' . strtoupper($row["txWaitListStatus"]) . '</h3></td></tr>';
			if ( $row["txSensStatus"] != $sens)
				{
				echo '<tr><td colspan="13"><h4>' . $row["txSensStatus"] . '</h4></td></tr>';
				}
			echo '
			<tr>
			<th class="print">' . $hosp1label . '</th>
			<th class="print">patient</th>
			<th class="print">sex</th>
			<th class="print">DOB <i>(age)</i></th>
			<th class="print">Curr Modal</th>
			<th class="print">ESRF date</th>
			<th class="print">Abs Highest <i>date</i></th>
			<th class="print">Abs Latest <i>date</i></th>
			<th class="print">Bl Group</th>
			<th class="print">No Grafts</th>
			<th class="print">Tx Type</th>
			<th class="print">Entry Date</th>
			<th class="print">Last Modif</th>
			</tr>';
			$status=$row["txWaitListStatus"];
			$sens=$row["txSensStatus"];
			}
			
		$zid = $row["patzid"];
		$showage = ($row["modalcode"]=='death' ? '' : ' <i>(' . $row["age"] . ')</i>');
		$patient = strtoupper($row["lastname"]) . ', ' . $row["firstnames"];
		echo '<tr>
		<td class="botline">' . $row["hospno1"] . '</td>
		<td class="botline">' . $patient . '</td>
		<td class="botline">' . $row["sex"] . '</td>
		<td class="botline">' . dmyyyy($row["birthdate"]) . $showage . '</i></td>
		<td class="botline">' . $row["modalcode"] . '</td>
		<td class="botline">' . dmyyyy($row["endstagedate"]) . '</td>
		<td class="botline">' . $row["txAbsHighest"] . " <i>(" . dmyyyy($row["txAbsHighestDate"]) . ')</i></td>
		<td class="botline">' . $row["txAbsLatest"] . " <i>(" . dmyyyy($row["txAbsLatestDate"]) . ')</i></td>
		<td class="botline">' . $row["txBloodGroup"] . '</td>
		<td class="botline">' . $row["txNoGrafts"] . '</td>
		<td class="botline">' . $row["txTransplType"] . '</td>
		<td class="botline">' . dmyyyy($row["txWaitListEntryDate"]) . '</td>
		<td class="botline">' . dmyyyy($row["txWaitListModifDate"]) . '</td>
		</tr>';
	}
	echo '</table>';
?>
</body>
</html>