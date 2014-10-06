<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . ' Modalities List';
//log the event
$eventtype="$page";
include "$rwarepath/run/logevent.php";
//get header
include '../parts/head.php';
//get main navbar
include '../navs/mainnav.php';
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//--------Page Content Here----------
?>
<?php
$sql= "SELECT modality, p.modalcode, count(patzid) as patcount FROM patientdata p JOIN modalcodeslist l ON p.modalcode=l.modalcode GROUP BY p.modalcode ORDER BY modalcode";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows active patient modalities. <i>Click on modality to view patients</i></p>";
?>
<table class="tablesorter"><thead>
<tr>
<th>modality</th>
<th colspan="2">count <i>(each "." is 50 patients)</th>
</tr></thead><tbody>
<?php
$max = '....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|....:....|';
while ($row = $result->fetch_assoc())
	{
	$points = floor($row["patcount"]/50);
	$chart = substr($max, 0, $points);
	$modalcode = $row["modalcode"];
	echo '<tr>
	<td><a href="lists/patientlist.php?modalcode=' . $row["modalcode"] . '">' . $row["modality"] . ' <i>list</i></td>
	<td>' . $row["patcount"] . '</td>
	<td align="left"><font color="red"><b>' . $chart . '</b></font></td>
	</tr>';
	}
?>
</tbody></table>
<?php
include '../parts/footer.php';
?>