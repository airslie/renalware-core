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
<p>Enter Surname (and optional firstname)<br>
<i>surnames/firstnames may be partial (e.g. "Robinsson" or "robinsson" or "robin"; "Harold" or "har" or "h"); both are case insensitive</i>
</p>
<label for="surname">Surname</label>&nbsp;<input type="text" id="surname" name="surname" size="20" /><br>
<label for="firstname">First name (optional)</label>&nbsp;<input type="text" id="firstname" name="firstname" size="20" />
</fieldset>
<input type="submit" style="color: green;" value="Search Renalware Patients" />
</form>
<?php endif ?>
<?php
if ($_POST['mode']=="searchpats")
	{
		$hospno1=FALSE;
		$hospno2=FALSE;
		$hospno3=FALSE;
		$hospno4=FALSE;
		$hospno5=FALSE;
		$surname=FALSE;
		foreach ($_POST as $key => $value) {
			if ($value) {
				${$key}=strtoupper($mysqli->real_escape_string($value));
			}
		}
		if ($surname) {
			$where="WHERE UPPER(lastname) LIKE '$surname%'";
			if ($firstname) {
				$where.=" AND UPPER(firstnames) LIKE '$firstname%'";
			}
		}
	$sql= "SELECT patzid, hospno1, hospno2, hospno3, hospno4,hospno5, lastname, firstnames, birthdate, modalcode FROM patientdata $where";
	$result = $mysqli->query($sql);
	$numrows = mysqli_num_rows ($result);
	if ($numrows=='0') 
		{
		echo "<p class=\"header\">Congratulations -- No matches were found! Please enter the new patient data</p>";
		include 'forms/addpatform.html';
		}
	else
		{
		echo "<p class=\"header\">This patient may to be registered -- $numrows matches for <u>$srchtxt</u> were found. Please review the list carefully!</p>";
			echo "<table class=\"list\"><tr>
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
			echo '<tr>
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
		echo '<p><a href="addpatient.php">Check another name or hospital number</a></span> or <b>add your patient below</b></p>';
		include 'forms/addpatform.html';
		}
	}
include('..parts/footer.php');
?>