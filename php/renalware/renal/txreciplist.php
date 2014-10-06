<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Current Transplant Patients List";
include "$rwarepath/navs/topsimplenav.php";
?>
<br>
<h3>"Tx First" Patients</h3>
<?php
//get total
$displaytext = "$siteshort Current First Year Transplant Recipients"; //default
$where = "WHERE modalcode ='Tx_first'";  // default
$orderby = "ORDER BY lastname, firstnames";
$sql= "select txopzid, sex, age, lastname, firstnames, hospno1, birthdate, modalcode, count(txop_id) as txcount FROM txops JOIN patientdata ON txopzid=patzid $where GROUP BY txopzid $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<p class=\"header\">$numrows $displaytext</p>";
// include links stuff
echo "<table class=\"list\">
<tr>
<th>$hosp1label</th>
<th>patient</th>
<th>sex</th>
<th>DOB <i>(age)</i></th>
<th>curr modal</th>
<th>Tx Ops</th>
<th>options</th>
</tr>";
while($row = $result->fetch_assoc())
	{
	$bg = ($row["modalcode"]=='death') ? '#ccc' : '#fff' ;
	$zid = $row["txopzid"];
	$showage = $row["modalcode"]=='death' ? '' : ' <i>(' . $row["age"] . ')</i>';
	$patient = strtoupper($row["lastname"]) . ', ' . $row["firstnames"];
	$patlink = '<a href="renal/renal.php?zid=' . $zid . '">' . $patient . '</a>';
	$txstatus = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=txstatus">Transplant Status</a>';
	$txscreen = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=txscreenview">Transplant Screen</a>';
	$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
	echo "<tr bgcolor=\"$bg\">
	<td>" . $adminlink . "</td>
	<td>" . $patlink . "</td>
	<td>" . $row["sex"] . "</td>
	<td>" . dmyyyy($row["birthdate"]) . "$showage</td>
	<td>" . $row["modalcode"] . "</td>
	<td>" . $row["txcount"] . "</td>
	<td>" . $txstatus . '&nbsp;&nbsp;&nbsp;'.$txscreen."</td>
	</tr>";
}
echo '</table>';
?>
<br>
<h3>"Tx Subs" Patients</h3>
<?php
//get total
$displaytext = "$siteshort Current Subsequent Year Transplant Recipients"; //default
$where = "WHERE modalcode ='Tx_subs'";  // default
$orderby = "ORDER BY lastname, firstnames";
$sql= "select txopzid, sex, age, lastname, firstnames, hospno1, birthdate, modalcode, count(txop_id) as txcount FROM txops JOIN patientdata ON txopzid=patzid $where GROUP BY txopzid $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<p class=\"header\">$numrows $displaytext</p>";
// include links stuff
echo "<table class=\"list\">
<tr>
<th>$hosp1label</th>
<th>patient</th>
<th>sex</th>
<th>DOB <i>(age)</i></th>
<th>curr modal</th>
<th>Tx Ops</th>
<th>options</th>
</tr>";
while($row = $result->fetch_assoc())
	{
	$bg = ($row["modalcode"]=='death') ? '#ccc' : '#fff' ;
	$zid = $row["txopzid"];
	$showage = $row["modalcode"]=='death' ? '' : ' <i>(' . $row["age"] . ')</i>';
	$patient = strtoupper($row["lastname"]) . ', ' . $row["firstnames"];
	$patlink = '<a href="renal/renal.php?zid=' . $zid . '">' . $patient . '</a>';
	$txstatus = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=txstatus">Transplant Status</a>';
	$txscreen = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=txscreenview">Transplant Screen</a>';
	$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
	echo "<tr bgcolor=\"$bg\">
	<td>" . $adminlink . "</td>
	<td>" . $patlink . "</td>
	<td>" . $row["sex"] . "</td>
	<td>" . dmyyyy($row["birthdate"]) . "$showage</td>
	<td>" . $row["modalcode"] . "</td>
	<td>" . $row["txcount"] . "</td>
	<td>" . $txstatus . '&nbsp;&nbsp;&nbsp;'.$txscreen."</td>
	</tr>";
}
echo '</table>';
?>
<?php
include '../parts/footer.php';
?>