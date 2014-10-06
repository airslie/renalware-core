<?php
//----Mon 25 Feb 2013----esa class fix
include '../req/confcheckfxns.php';
//get patientdata
$zid = $_GET['zid'];
include "$rwarepath/data/patientdata.php";
include "$rwarepath/data/probs_meds.php";
$printstamp= Date("D d M Y H:i");
$pagetitle= 'Patient Medications: ' . strtoupper($lastname) . ', ' . $firstnames . ' (' . $hospno1 . ', ' . $modalcode . ") on $printstamp";
//get header
include '../parts/head.php';
//get main navbar
echo '<div id="pagetitlediv"><h1>'.$pagetitle.'</h1></div>';
//--------Page Content Here----------
?>
<h3>Allergies</h3>
<b><font color="#FF0000"><?php echo $allergies; ?></font></b>
<br>
<?php 
$sql= "SELECT medsdata_id, drugname, dose, route, freq, drugnotes, DATE_FORMAT(adddate, '%e-%b-%Y') as startdate, medmodal, esdflag, modifstamp FROM medsdata WHERE medzid=$zid AND termflag=0 ORDER BY medsdata_id";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<h3>Current Medications ($numrows)</h3>";
?>
<table class="printlist">
<tr>
<th>name</th>
<th>dose</th>
<th>route</th>
<th>freq</th>
<th>notes</th>
<th>added</th>
</tr>
<?php
while ($row = $result->fetch_assoc())
	{
	echo '<tr>
	<td><b>' . $row['drugname'] . '</b></td>
	<td>' . $row['dose'] . '</td>
	<td>' . $row['route'] . '</td>
	<td>' . $row['freq'] . '</td>
	<td><i>' . $row['drugnotes'] . '</i></td>
	<td class="start">' . $row['startdate'] . '</font></td>
	</tr>';
	}
?>
</table>
<?php 
$sql= "SELECT medsdata_id, drugname, dose, route, freq, drugnotes, DATE_FORMAT(adddate, '%e-%b-%Y') as startdate, DATE_FORMAT(termdate, '%e-%b-%Y') as enddate, medmodal, esdflag, modifstamp, adduser, termuser FROM medsdata WHERE medzid=$zid ORDER BY medsdata_id DESC";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
	echo "<h3>Medications History ($numrows)</h3>";
?>
<table class="printlist">
<tr>
<td>drug</th>
<td>dose route freq</th>
<td>notes</th>
<td>added (by)</th>
<td>termdate (by)</th>
<td>modality</th>
<td>modifstamp</th>
</tr>
<?php
	while ($row = $result->fetch_assoc())
		{
		if ($row['esdflag']==1)
			{
			$trclass = 'esa'; //flag ESAs
			}
		if ($row['enddate']!="")
			{
			$trclass = 'lolite'; //flag terminated
			}
		echo '<tr class="' . $trclass . '">
		<td><b>' . $row['drugname'] . '</b></td>
		<td>' . $row['dose'] . ' ' . $row['route'] . ' ' . $row['freq'] . '</td>
		<td><i>' . $row['drugnotes'] . '</i></td>
		<td class="start">' . $row['startdate'] . '</font> '  . $row['adduser'] . '</td>
		<td class="term">' . $row['enddate'] . '</font> '  . $row['termuser'] . '</td>
		<td>' . $row['medmodal'] . '</td>
		<td>' . $row['modifstamp'] . '</td>
		</tr>';
		}
?>
</table>
<br><br>
<p><small><font color="#333">Printed by Renalware SQL by <?php echo $user; ?> at <?php echo $siteshort; ?> on <?php echo $printstamp; ?></font></small>
</p>
</body>
</html>