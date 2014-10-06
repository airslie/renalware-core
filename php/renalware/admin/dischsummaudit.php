<?php
include '../req/confcheckfxns.php';
if ($get_auditdaterange)
	{
	list($fromdate,$thrudate)=explode(" - ",$get_auditdaterange);
		$periodname="from $fromdate through $thrudate";
		$startymd=fixDate($fromdate);
		$endymd=fixDate($thrudate);
		$runaudit=TRUE;
	}
$pagetitle= $siteshort . " Discharge Summary Audit $periodname";
include "$rwarepath/navs/topsimplenav.php";
include "$rwarepath/navs/usernav.php";
?>
<form action="admin/dischsummaudit.php" method="get">
<fieldset>Select period: <input type="text" name="auditdaterange" title="Select discharge dates..." size="30" class="daterange" id="auditdaterange" />&nbsp;&nbsp;<input type="submit" style="color: green;" value="Run Audit" />
</fieldset></form>
<?php
//only run when submitted
if ($runaudit)
{
$displaytext = "Discharge Summaries audited from $fromdate to $thrudate"; //default
$sql= "SELECT admission_id, admhospno1, CONCAT(p.lastname, ', ', p.firstnames) as patient, a.admdate, a.dischdate, typeddate, reviewdate, printdate, authorlastfirst as author, lettuser as typist, DATEDIFF(typeddate, a.dischdate) as createlag, DATEDIFF(reviewdate,typeddate) as reviewlag, DATEDIFF(printdate,a.dischdate) as totallag, status,admmodal, lettertype, a.dischdest FROM admissiondata a LEFT JOIN letterdata l ON admission_id=admissionid JOIN patientdata p ON admzid=patzid WHERE admittedflag=0 AND a.dischdate BETWEEN '$startymd' AND '$endymd' ORDER BY lastname, firstnames, a.dischdate";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
$showrows = ($numrows) ? "$numrows $displaytext. Click on headers to sort. IMPORTANT: assumes dictated date=typed date. " : "There are no $displaytext for this period!" ;
echo "<p class=\"header\">$showrows</p>";
	if ($numrows) {
	echo '<table class="tablesorter"><thead>
	<tr><th>HospNo</th>
	<th>patient</th>
	<th>admitted</th>
	<th>discharged</th>
	<th>destin</th>
	<th>modal</th>
	<th>status</th>
	<th>author</th>
	<th>typist</th>
	<th>typed</th>
	<th>reviewed</th>
	<th>printed</th>
	<th>disch to <br>dictated</th>
	<th>typed to <br>reviewed</th>
	<th>disch to <br>printed</th>
	<th>descr</th>
	</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$status = $row['status'];
		$trclass = ($row["dischdest"]=='Death') ? "death" : "" ;
		echo '<tr class="' . $trclass . '">
		<td>' . $row["admhospno1"] . '</td>
		<td>' . $row["patient"] . '</td>
		<td>' . dmy($row["admdate"]) . '</td>
		<td>' . dmy($row["dischdate"]) . '</td>
		<td>' . $row["dischdest"] . '</td>
		<td>' . $row["admmodal"] . '</td>
		<td><b>' . $row["status"] . '</b></td>
		<td>' . $row["author"] . '</td>
		<td>' . $row["typist"] . '</td>
		<td>' . dmy($row["typeddate"]) . '</td>
		<td>' . dmy($row["reviewdate"]) . '</td>
		<td>' . dmy($row["printdate"]) . '</td>
		<td><b>' . $row["createlag"] . '</b></td>
		<td><b>' . $row["reviewlag"] . '</b></td>
		<td><b>' . $row["totallag"] . '</b></td>
		<td><i>' . $row["lettertype"] . '</i></td>
		</tr>';
		}
	echo '</tbody></table>';
	}
}
// get footer
include '../parts/footer.php';
?>