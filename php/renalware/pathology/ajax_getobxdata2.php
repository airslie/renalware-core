<?php
//----Thu 06 Dec 2012----
$obxtable="final_obx";
$maxno=32;
realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';
$thisobxcode = $_GET["obxcode"];
$thispid = $_GET["obxpid"];
$sql = "SELECT obxname FROM hl7data.pathol_obxcodes WHERE code='$thisobxcode'";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$obxname=$row["obxname"];
$fields = "obxdt,obxresult";
$tables = "hl7data.pathol_obxdata";
$where = "WHERE obxcode='$thisobxcode' AND obxpid='$thispid'";
$sql = "SELECT $fields FROM hl7data.$obxtable $where ORDER BY obx_id DESC LIMIT $maxno";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<p class=\"pathheader\">$numrows $thisobxcode <b>$obxname</b> results (max $maxno)</p>";
echo "<table class=\"tablesorter\">
<tr><th>date time</th>
<th>$thisobxcode</th>
</tr>";
while($row = $result->fetch_assoc()) {
	echo "<tr>
	<td>" . $row["obxdt"] . "</td>
	<td>" . $row["obxresult"] . "</td>
	</tr>";
	}
echo "</table>";
