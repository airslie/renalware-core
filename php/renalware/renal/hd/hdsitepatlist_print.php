<?php
require '../../config_incl.php';
include "$rwarepath/incl/check.php";
include "$rwarepath/fxns/fxns.php";
include "$rwarepath/fxns/formfxns.php";
$site = $_GET["hdsite"];
$pagetitle= $siteshort . " HD Patient List for " . strtoupper($site) . " on " . date("D d/m/Y");
//get header
include "$rwarepath/parts/head.php";
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//--------Page Content Here----------
//get total
$display = 500; //default
	$where = "WHERE modalcode LIKE 'HD%' AND currsite='$site'";
	$displaytext = "HD patients at <b>$site</b>";
    $orderby = "ORDER BY lastname, firstnames"; //default
    $displaytime = date("D j M Y  G:i:s");
    $fields = "patzid, hospno1, lastname, firstnames, sex, birthdate,age, modalcode, accessCurrent, currsite, currsched, currslot";
    $tables = "renalware.patientdata JOIN renaldata ON patzid=renalzid JOIN hdpatdata ON patzid=hdpatzid";
    $sql= "SELECT $fields FROM $tables $where $orderby LIMIT $display";
    $result = $mysqli->query($sql);
    $numrows = $result->num_rows;
	echo "<p>$numrows $displaytext</p>";
	echo '
	<table border=0 cellspacing=2 cellpadding=4>
	<tr>
	<th class="print">' . $hosp1label . '</th>
	<th class="print">patient</th>
	<th class="print">sex <i>(age)</i></th>
	<th class="print">DOB</th>
	<th class="print">Curr Modal</th>
	<th class="print">Site/Schedule</th>
	<th class="print">Curr Access</th>
	</tr>';
	$bg = '#fff';
	while ($row = $result->fetch_assoc()) {
		$zid = $row["patzid"];
		$showage = ($row["modalcode"]=='death' ? '' : ' <i>(' . $row["age"] . ')</i>');
		$patlink = strtoupper($row["lastname"]) . ', ' . $row["firstnames"];
		$modal = $row["modalcode"];
		$accesslink = $row["accessCurrent"];
		$adminlink = $row["hospno1"];
		echo "<tr bgcolor=\"$bg\">
		<td class=\"botline\">$adminlink</td>
		<td class=\"botline\"><b>$patlink</b></td>
		<td class=\"botline\">" . $row["sex"] . ' ' . $row["age"] . "</td>
		<td class=\"botline\">" . $row["dob"] . "</td>
		<td class=\"botline\">$modal</td>
		<td class=\"botline\">" . $row["currsched"] . '-' . $row["currslot"] . "</td>
		<td class=\"botline\">$accesslink</td></tr>";
		}
	echo '</table>';
 ?>
</body>
</html>