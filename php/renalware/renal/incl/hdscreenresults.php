<?php
//----Mon 23 Sep 2013----HGB fix
//Tue May 12 08:06:29 BST 2009
$fields = "resultsdate, HB, RETA, PLT, FER, URE, CRE, NA, POT, BIC, CCA, PHOS, PTHI, ALB, BIL, ALP, GGT, HBA, CHOL, URR, UREP";
$sql= "SELECT $fields FROM hl7data.patresults WHERE PID='$hospno1' ORDER BY resultsdate DESC LIMIT 20";
$result = $mysqli->query($sql);
//echo "<br>TEST: $sql <br>";
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows most recent results displayed.</p>";
echo "<table class=\"list\">
<tr><th>date</th>
<th><b>HGB</b></th>
<th>RET</th>
<th><b>PLT</b></th>
<th>FER</th>
<th><b>URE</b></th>
<th><b>CRE</b></th>
<th>NA</th>
<th>POT</th>
<th>BIC</th>
<th><b>CCA</b></th>
<th>PHOS</th>
<th><b>PTHI</b></th>
<th>ALB</th>
<th>BIL</th>
<th>ALP</th>
<th>GGT</th>
<th><b>HBA</b></th>
<th>CHOL</th>
<th>URR</th>
<th>UREP</th>
</tr>";
while ($row = $result->fetch_assoc()) {
	echo "<tr>
	<td><b>" . dmy($row["resultsdate"]) . "</b></td>
	<td class=\"hb\">" . 10*$row["HB"] . "</td>
	<td>" . $row["RETA"] . "</td>
	<td><b>" . $row["PLT"] . "</b></td>
	<td>" . $row["FER"] . "</td>
	<td class=\"bc\">" . $row["URE"] . "</b></td>
	<td class=\"bc\">" . $row["CRE"] . "</b></td>
	<td>" . $row["NA"] . "</td>
	<td>" . $row["POT"] . "</td>
	<td>" . $row["BIC"] . "</td>
	<td><b>" . $row["CCA"] . "</b></td>
	<td>" . $row["PHOS"] . "</td>
	<td><b>" . $row["PTHI"] . "</b></td>
	<td>" . $row["ALB"] . "</td>
	<td>" . $row["BIL"] . "</td>
	<td>" . $row["ALP"] . "</td>
	<td>" . $row["GGT"] . "</td>
	<td><b>" . $row["HBA"] . "</b></td>
	<td>" . $row["CHOL"] . "</td>
	<td>" . $row["URR"] . "</td>
	<td>" . $row["UREP"] . "</td>
	</tr>";
}
echo "</table>";
