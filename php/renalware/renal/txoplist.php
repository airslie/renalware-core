<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Transplant Operations List";
include "$rwarepath/navs/topsimplenav.php";
?>
<?php
include('incl/locaterenalpat.php');
//get total
$displaytext = "$siteshort Transplant Operations"; //default
$where = "";  // default
if($_GET["zid"])
	{
	$zid=$_GET['zid'];
	$where = "WHERE txopzid=$zid";
	}
//include xnav calc
include('../navs/xnavstartasc.php');
$displaytime = date("D j M Y  G:i:s");
$orderby = "ORDER BY lastname, firstnames";
$fields="txopzid,
hospno1,
lastname,
firstnames,
sex,
birthdate,
age,
DATE_FORMAT(FROM_DAYS(TO_DAYS(txopdate)-TO_DAYS(birthdate)), '%y') AS age_at_op,
modalcode,
txop_id,
txopdate,
txopno,
txoptype,
donortype,
txsite,
graftfxn,
failureflag,
failuredate,
stentremovaldate
";
$sql= "SELECT $fields FROM txops LEFT JOIN patientdata ON txopzid=patzid $where $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
echo "<p class=\"header\">$numtotal $displaytext ($numrows displayed).</p>";
echo "<table class=\"tablesorter\"><thead>
<tr>
<th>$hosp1label</th>
<th>patient</th>
<th>sex</th>
<th>DOB <i>(age)</i></th>
<th>curr modal</th>
<th>Tx date</th>
<th>Tx No</th>
<th>type</th>
<th>age at op</th>
<th>donor type</th>
<th>site</th>
<th>function</th>
<th>failure date</th>
<th>stent removal date</th>
<th>options</th>
</tr></thead><tbody>";
while($row = $result->fetch_assoc())
	{
	$bg = (!$row["stentremovaldate"]) ? '#ff9' : '#fff' ;
	$bg = ($row["failureflag"]=='1') ? '#ccc' : '#fff' ;
	$zid = $row["txopzid"];
	$showage = $row["modalcode"]=='death' ? '' : ' <i>(' . $row["age"] . ')</i>';
	$patient = strtoupper($row["lastname"]) . ', ' . $row["firstnames"];
	$patlink = '<a href="renal/renal.php?zid=' . $zid . '">' . $patient . '</a>';
	$txscreenlink = '<a href="renal/renal.php?zid=' . $zid . '&amp;scr=txscreenview">Tx Screen</a>';
	$update = '<a href="renal/forms/txops.php?mode=update&amp;zid='.$zid.'&amp;txop_id='.$row["txop_id"].'">update</a>';
	$viewprint = '<a href="renal/forms/txops.php?mode=view&amp;zid='.$zid.'&amp;txop_id='.$row["txop_id"].'">view/print</a>';
	$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
	echo "<tr bgcolor=\"$bg\">
	<td>" . $adminlink . "</td>
	<td>" . $patlink . "</td>
	<td>" . $row["sex"] . "</td>
	<td>" . dmyyyy($row["birthdate"]) . "$showage</td>
	<td>" . $row["modalcode"] . "</td>
	<td>" . dmyyyy($row["txopdate"]) . "</td>
	<td>" . $row["txopno"] . "</td>
	<td>" . $row["txoptype"] . "</td>
	<td>" . $row["age_at_op"] . "</td>
	<td>" . $row["donortype"] . "</td>
	<td>" . $row["site"] . "</td>
	<td>" . $row["graftfxn"] . "</td>
	<td>" . dmyyyy($row["failuredate"]) . "</td>
	<td>" . dmyyyy($row["stentremovaldate"]) . "</td>
	<td>" . $update. '&nbsp;&nbsp;&nbsp;' . $viewprint . '&nbsp;&nbsp;&nbsp;' . $txscreenlink . "</td>
	</tr>";
}
echo '</tbody></table>';
?>
<?php
include '../parts/footer.php';
?>