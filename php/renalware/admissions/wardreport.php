<?php
include '../req/confcheckfxns.php';
$pagetitle="$siteshort Current Inpatients on " . date("D d/m/Y");
//get header
include '../parts/head.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
?>
<?php
$fields = "admhospno1, admmodal, DATE_FORMAT(admdate, '%d/%m/%y (%a)') AS admdate_ddmy, admward, ward, admtype, birthdate, sex, lastname, firstnames, age, currward,modalsite";
$orderby = "ORDER BY currward, lastname, firstnames";
$sql= "SELECT $fields FROM admissiondata JOIN patientdata ON (patzid=admzid) LEFT JOIN wardlist ON admward=wardcode WHERE admittedflag=1 $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
	$currward="";
	echo '<table class="printlist" style="width: 19cm; table-layout: auto;">';
	while ($row = $result->fetch_assoc()) {
		if ( $row["currward"] != $currward)
		{
			echo '<thead><tr><td colspan="8"><h3>' . strtoupper($row["currward"]) . ' '.$numrows. ' Patients</h3></td></tr>';
			echo '<tr>
				<th>KCH No</th>
				<th>patient</th>
				<th>age sex</th>
				<th>DOB</th>
				<th>modality</th>
				<th>adm date</th>
				<th>bed</th>
				<th>notes</th>
				</tr></thead>';
			$currward=$row["currward"];
		}
		$patlink = strtoupper($row["lastname"]) . ', ' . $row["firstnames"];
		echo '<tr>
		<td class="f">' . $row["admhospno1"] . '</td>
		<td>' . $patlink . '</td>
		<td>' . $row["age"] . ' ' . $row["sex"] . '</td>
		<td>' . dmy($row["birthdate"]) . '</td>
		<td>' . $row["admmodal"] . ' ' . $row["modalsite"] . '</td>
		<td>' . $row["admdate_ddmy"] . '</td>
		<td style="width: 30px;">&nbsp;</td>
		<td style="width: 150px;">&nbsp;</td>
		</tr>';
		}
	echo '</table>';
?>
</body>
</html>