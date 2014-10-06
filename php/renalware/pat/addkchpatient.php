<?php
include '../req/confcheckfxns.php';
$pagetitle= "Add New $siteshort Patient";
include "$rwarepath/navs/topsimplenav.php";
?>
<?php if ($post_mode!="searchpats"): ?>
<p class="alert">ENSURE THE PATIENT IS NOT ALREADY IN THE DATABASE!</p>
<?php
if ($_SESSION['errormsg']) {
	showError($_SESSION['errormsg']);
	unset($_SESSION['errormsg']);
}
?>
<form action="pat/addpatient.php" method="post">
<fieldset>
<input type="hidden" name="mode" value="searchpats" id="mode" />
<legend>Step (1) Search existing patient database</legend>
<b>Enter KCH No *EXACTLY*</b><br>
<label for="surname">KCH No</label>&nbsp;<input type="text" id="kchno" name="kchno" size="8" />
</fieldset>
<input type="submit" style="color: green;" value="Search Renalware Patients" />
</form>
<?php endif ?>
<?php
if ($_POST['mode']=="searchpats")
	{
		$kchnoraw=$mysqli->real_escape_string($_POST['kchno']);
		$kchno=strtoupper($kchnoraw);
	$sql= "SELECT patzid, hospno1,hospno2,hospno3,hospno4,hospno5, lastname, firstnames, birthdate, modalcode FROM patientdata WHERE UPPER(hospno1)='$kchno'";
	$result = $mysqli->query($sql);
	$numrows = mysqli_num_rows ($result);
	if ($numrows=='0') 
		{
		echo "<p class=\"header\">Congratulations -- No matches were found! Please enter the new patient data</p>";
		include 'forms/addkchpatform.php';
		}
	else
		{
		echo "<p class=\"header\">This patient is already in Renalware -- $numrows matches for <u>$kchno</u> were found.</p>";
		echo "<table class=\"list\">
		<tr>
		<th>$hosp1label</th>
		<th>$hosp2label</th>
		<th>$hosp3label</th>
		<th>$hosp4label</th>
		<th>$hosp5label</th>
		<th>Patient</th>
		<th>Modality</th>
		<th>DOB</th>
		</tr>"; 
		while ($row = $result->fetch_assoc())
			{
			$zid=$row["patzid"];
			$patlink = '<a href="pat/patient.php?vw=clinsumm&amp;zid=' . $zid . '">' . strtoupper($row["lastname"]) . ', ' . $row["firstnames"] . '</a>';
			$modalslink = '<a href="pat/patient.php?vw=modals&amp;zid=' . $zid . '">' . $row["modalcode"] . '</a>';
			$adminlink = '<a href="pat/patient.php?vw=admin&amp;zid=' . $zid . '">' . $row["hospno1"] . '</a>';
			echo 
			'<tr>
			<td>'.$adminlink.'</td>
			<td>'.$row["hospno2"].'</td>
			<td>'.$row["hospno3"].'</td>
			<td>'.$row["hospno4"].'</td>
			<td>'.$row["hospno5"].'</td>
			<td>'.$patlink.'</td>
			<td>'.$modalslink.'</td>
			<td>'.dmyyyy($row["birthdate"]).'</td>
			</tr>';
			}
		echo '</table>';
		}
	}
include('..parts/footer.php');
?>