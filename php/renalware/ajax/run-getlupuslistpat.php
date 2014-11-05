<?php
//--Fri Oct 26 16:46:46 SGT 2012--
include '../req/confcheckfxns.php';
// Retrieve data from Query String
$hospnofix = $mysqli->real_escape_string($_GET["hospno"]);
$thishospno = strtolower($hospnofix); //nb hospno may be entered in lc as well
$where = "WHERE LOWER(hospno1) = '$thishospno' AND lupuszid IS NULL";
$showwhere="where Hospital number matches <b>$hospnofix</b>";
$fields="patzid,hospno1,lastname,firstnames,sex,birthdate,age,modalcode";
$headers="ZID,KCH No,lastname,firstname(s),sex,DOB,age,modalcode";
$fieldsarray=explode(",",$fields);
$headersarray=explode(",",$headers);
$db = "renalware";
$sql = "SELECT $fields FROM $db.patientdata LEFT JOIN $db.lupusdata ON patzid=lupuszid $where ORDER BY lastname, firstnames";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($numrows) {
$resultsflag=TRUE;
echo "<h3>Step 2: Confirm Desired Renalware Patient</h3>";
echo '<table class="tablesorter"><thead><tr>';
foreach ($headersarray as $key => $value) {
	echo "<th>$value</th>";
}
echo "<th>options</th><th>view (in new window)</th></tr></thead>";
while($row = $result->fetch_assoc())
	{
	echo "<tr>";
	foreach ($fieldsarray as $key => $value) {
		echo "<td>".$row["$value"]."</td>";
	}
	echo '<td class="links"><a href="ls/lupuslist.php?newzid='.$row["patzid"].'">add to Lupus Patients</a></td>
    <td class="links"><a href="pat/patient.php?vw=clinsumm&amp;zid='.$row["patzid"].'" >view clin summ</a> (new window)</td></tr>';
}
echo "</table>";
} else {
	$resultsflag=FALSE;
	//echo "Sorry, no lastnames matching <tt>$lastname</tt> were found. <br><b>[$sql]</b>";
	echo "<p class=\"alertsmall\">Sorry, no matches for patients with a Hosp No matching <tt>$hospnofix</tt> in Renalware were found.</p>";	
}
