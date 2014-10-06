<?php
require '../config_incl.php';
include('../incl/check.php');
$pagetitle= "Add new $siteshort Drug";
include "$rwarepath/navs/topsimplenav.php";
//--------Page Content Here----------
include "$rwarepath/navs/usernav.php";
if ($_POST['mode']=="adddrug") {
	$drugname = $mysqli->real_escape_string($_POST["drugname"]);
	$esdflag = $_POST["esdflag"];
	$immunosuppflag = $_POST["immunosuppflag"];
	//add to meds
	$insertfields = "drugname, esdflag, immunosuppflag, user, addstamp";
	$values="'$drugname', $esdflag, $immunosuppflag, '$user', NOW()"; 
	$table = "druglist";
	$sql= "INSERT INTO $table ($insertfields) VALUES ($values)";
	$result = $mysqli->query($sql);
	//log the event
	$eventtype="NEW DRUGNAME added: $drugname";
	$eventtext=$mysqli->real_escape_string($sql);
	include "$rwarepath/run/logevent.php";
	//end logging
	//set pat modifstamp
	echo "<p class=\"alertsmall\">NEW DRUGNAME ADDED: $drugname</p>";
}
?>
<p class="alert">ENSURE THE DRUG IS NOT ALREADY IN THE DATABASE!</p>
<p><i>Please enter the drug text to search -- either a keyword (e.g. "Calcium") or "string" [portion of name, e.g. "poetin"] below to see if your drug has already been added.<br>
	<b>Note: the search is NOT case-sensitive</b></i>
</p>
<form action="admin/addnewdrugname.php" method="post">
<fieldset>
<input type="hidden" name="mode" value="searchlist" id="mode" />
<legend>Step (1) Search existing druglist</legend>
<ul class="form">
<li><label>Drug text</label>&nbsp;&nbsp;<input type="text" name="drugstring"  size="20" /></li>
</ul>
<input type="submit" style="color: green;" value="Search Drug List" />
</fieldset>
</form>
<?php
if ($_POST['mode']=="searchlist")
	{
	$drugstring = strtolower($mysqli->real_escape_string($_POST["drugstring"]));
	$sql= "SELECT drugname FROM druglist WHERE lower(drugname) LIKE '%$drugstring%'";
	$result = $mysqli->query($sql);
	$numrows = $result->num_rows;
	if ($numrows=='0') 
		{
		echo "<p class=\"header\">Congratulations -- No <b>$drugstring</b> matches were found!</p>";
		}
	else
		{
		echo "<p class=\"header\">$numrows &lsquo;$drugstring&rsquo; matches were found.</p>";
		echo "<table class=\"tablesorter\"><tr>
		<th>Existing drugs</th>
		</tr>"; 
		while ($row = $result->fetch_assoc())
			{
			$drugname=$row["drugname"];
			echo "<tr>
			<td>$drugname</td>
			</tr>";
			}
		echo '</table>';
		}
	include 'addnewdrugnameform.html';
	}

include '../parts/footer.php';
?>