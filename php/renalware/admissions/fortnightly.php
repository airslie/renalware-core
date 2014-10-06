<?php
include '../req/confcheckfxns.php';
$pagetitle="$siteshort Admissions for Fortnight Ending " . date("D d/m/Y");
//get header
include '../parts/head.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
$twoweeksago= date("Y-m-d", mktime(0, 0, 0, date("m")  , date("d")-14, date("Y")));
$fields = "admhospno1, admmodal, DATE_FORMAT(admdate, '%d/%m/%y') AS admdate_ddmy, DATE_FORMAT(dischdate, '%d/%m/%y') AS dischdate_ddmy, admward, ward, consultant, admtype, reason, datediff(dischdate, admdate) AS LOS, DATE_FORMAT(birthdate, '%d/%m/%y') AS birthdate_dmy, sex, lastname, firstnames, age";
$orderby = "ORDER BY admmodal, lastname, firstnames";
$sql= "SELECT $fields FROM admissiondata LEFT JOIN patientdata ON (patzid=admzid) LEFT JOIN wardlist ON admward=wardcode WHERE admdate >= '$twoweeksago' $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "Period starting $twoweeksago -- $numrows admissions recorded.<br>";
	// table header
	echo '<table class="printlist">';
		echo '<tr>
			<th>adm date</th>
			<th>disch date</th>
			<th>' . $hosp1label . '</th>
			<th>patient</th>
			<th>age sex</th>
			<th>DOB</th>
			<th>admmodal</th>
			<th>ward</th>
			<th>consultant</th>
			<th>reason</th>
			<th>LOS (d)</th>
			</tr>';
	while ($row = $result->fetch_assoc()) {
		$patlink = strtoupper($row["lastname"]) . ', ' . $row["firstnames"];
		echo '<tr>
		<td>' . $row["admdate_ddmy"] . '</td>
		<td>' . $row["dischdate_ddmy"] . '</td>
		<td>' . $row["admhospno1"] . '</td>
		<td><b>' . $patlink . '</b></td>
		<td>' . $row["age"] . ' ' . $row["sex"] . '</td>
		<td>' . $row["birthdate_dmy"] . '</td>
		<td>' . $row["admmodal"] . '</td>
		<td>' . $row["ward"] . '</td>
		<td>' . $row["consultant"] . '</td>
		<td>' . $row["reason"] . '</td>
		<td align="right">' . $row["LOS"] . '</td>
		</tr>';
		}
	echo '</table>';
?>
</body>
</html>