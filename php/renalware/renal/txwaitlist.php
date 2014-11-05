<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Transplant Waiting List";
include "$rwarepath/navs/topsimplenav.php";
?>
<p><a class="ui-state-default" style="color: green; background: white;" href="renal/txwaitlistreport.php" >Print version</a> (opens in new window).</p>
<table border="0"><tr><td>
<form action="renal/txwaitlist.php" method="get">
<fieldset style="width: 300px;"><select name="status">
	<?php
	//----Sun 31 Jul 2011----
	$optionlistname='waitliststatus';
	include '../optionlists/getoptionlist_incl.php';
	?>
</select><input type="submit" style="color: green;" value="Find by Status" /></fieldset>
</form></td>
<td><?php include('incl/locaterenalpat.php'); ?></td>
</tr></table>
<!--content here-->
<?php
$displaytext = "$siteshort Transplant Waiting List patients"; //default
$where = "WHERE txWaitListStatus='Active' OR txWaitListStatus='Suspended'";
if($_GET["status"])
	{
	$status = $_GET["status"];
	$where = "WHERE txWaitListStatus='$status'";
	$displaytext = "$siteshort <b>\"$status\"</b> Transplant Waiting List patients"; //default
	}
if($_GET["zid"])
	{
	$zid=$_GET['zid'];
	$where = "WHERE patzid=$zid";
	}
$orderby = "ORDER BY lastname, firstnames"; //incl ORDER BY prn
$fields = "patzid, hospno1,lastname, firstnames, sex,
age, modalcode,
endstagedate,
txWaitListEntryDate,
txWaitListModifDate,
txWaitListStatus,txAbsHighest,
txAbsHighestDate,
txAbsLatest,
txAbsLatestDate,
TxNHBconsent,
txBloodGroup,txNoGrafts,if(txAbsLatest>60, 'Sensitised', 'Unsensitised') as txSensStatus,txTransplType,txRejectionRisk";
$sql= "SELECT $fields from patientdata JOIN renaldata d ON patzid=renalzid $where $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext</p>";
	} else
	{
	echo "<p class=\"header\">$numrows $displaytext</p>";
	echo "
	<table class=\"tablesorter\"><thead>
	<tr>
	<th>$hosp1label</th>
	<th>patient</th>
	<th>sex</th>
	<th>age</th>
<th>modal</th>
<th>ESRF date</th>
<th>Status</th>
<th>Abs Highest <i>(date)</i></th>
<th>Abs Latest <i>(date)</i></th>
<th>Blood<br>Group</th>
<th>No <br>Grafts</th>
<th>SensStatus</th>
<th>TransplType</th>
<th>RejectnRisk</th>
<th>NHB Consent</th>
<th>Entry Date</th>
<th>Last Mod</th>
</tr></thead><tbody>";
	while ($row = $result->fetch_assoc()) {
		$bg = ($row["txWaitListStatus"]=='Suspended' ? '#ccc' : '#fff');
		$zid = $row["patzid"];
		$showage = ($row["modalcode"]=='death' ? '' : ' <i>' . $row["age"] . '</i>');
		$patient = strtoupper($row["lastname"]) . ', ' . $row["firstnames"];
		$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . $patient . '</a>';
		$txlink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=txstatus">' . $row["txWaitListStatus"] . '</a>';
		$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
		echo "<tr style=\"background: $bg\">
		<td>" . $adminlink . "</td>
		<td>" . $patlink . "</td>
		<td>" . $row["sex"] . "</td>
		<td>" . $showage . "</td>
		<td>" . $row["modalcode"] . "</td>
		<td>" . dmyyyy($row["endstagedate"]) . "</td>
		<td>" . $txlink . "</td>
		<td>" . $row["txAbsHighest"] . " <i>" . dmyyyy($row["txAbsHighestDate"]) . "</i></td>
		<td>" . $row["txAbsLatest"] . " <i>" . dmyyyy($row["txAbsLatestDate"]) . "</i></td>
		<td>" . $row["txBloodGroup"] . "</td>
		<td>" . $row["txNoGrafts"] . "</td>
		<td><b>" . $row["txSensStatus"] . "</b></td>
		<td>" . $row["txTransplType"] . "</td>
		<td>" . $row["txRejectionRisk"] . "</td>
		<td>" . $row["TxNHBconsent"] . "</td>
		<td>" . dmyyyy($row["txWaitListEntryDate"]) . "</td>
		<td>" . dmyyyy($row["txWaitListModifDate"]) . "</td>
		</tr>";
		}
	echo '</tbody></table>';
	}
 include '../parts/footer.php';
?>