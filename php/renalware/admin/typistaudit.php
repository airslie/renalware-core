<?php
include '../req/confcheckfxns.php';
//get dates to insert into form
	$startdmy=$_POST['startdmy'];
	$enddmy=$_POST['enddmy'];
	$startymd=fixDate($startdmy);
	$endymd=fixDate($enddmy);
$pagetitle= $siteshort . " Typists Audit";
include "$rwarepath/navs/topsimplenav.php";
include "$rwarepath/navs/usernav.php";
?>
<p><small><i>NEW: insert only the start date for a single day's audit</i></small><br>
</p><form action="admin/typistaudit.php" method="post">
<fieldset><b>Period starting</b> (d/m/y): <input type="text" name="startdmy" size="10" value="<?php echo $startdmy; ?>" /> &nbsp;&nbsp; <b>ending (OPTIONAL)</b> (d/m/y): <input type="text" name="enddmy" size="10" value="<?php echo $enddmy; ?>" /><input type="submit" style="color: green;" value="Run Audit" />
</fieldset></form>
<?php
//only run when submitted
if ( $_POST['startdmy'] )
{
	//set WHERE depending on if both dates entered:
	if ( $_POST['startdmy'] && $_POST['enddmy'] )
	{
		$where="WHERE lettuid is not NULL AND DATE(lettaddstamp) BETWEEN '$startymd' AND '$endymd'";
		$displaytext = "Typists audited from $startdmy to $enddmy"; //default
	}
	else
	{
		$where="WHERE lettuid is not NULL AND DATE(lettaddstamp) = '$startymd'";
		$displaytext = "Typists audited for the date $startdmy"; //default

	}

//get total first...  WTH :)
$sql= "SELECT count(letter_id) as total_typed FROM letterdata $where";
echo "<hr>$sql<hr>";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$totaltyped=$row["total_typed"];
$display = 200; //default
$sql= "SELECT lettuid, CONCAT(userlast, ', ', userfirst) as typist, count(letter_id) as no_typed FROM letterdata JOIN userdata ON lettuid=uid $where GROUP BY lettuid ORDER BY userlast, userfirst";
//echo "<hr>$sql<hr>";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
if ($numrows=='0')
	{
	echo "<p class=\"headergray\">There are no $displaytext for this period!</p>";
	}
else
	{
		if ( $adminflag OR $user==$supertypist )
		{
		echo "<p class=\"header\">$numrows $displaytext. There were $totaltyped letters created in the period.</p>";
		echo "<table class=\"tablesorter\">
		<thead><tr><th>Typist</th>
		<th>No Typed</th>
		<th>% Typed</th>
		</tr></thead><tbody>";
		while ($row = $result->fetch_assoc()) {
			$typistcount=$row["no_typed"];
			$pcttyped=round(100*$typistcount/$totaltyped,1);
			echo '<tr>
			<td>' . $row["typist"] . '</td>
			<td>' . $row["no_typed"] . '</td>
			<td>' . $pcttyped . '%</td>
			</tr>';
			}
		echo "</tbody><tfoot><tr class=\"#hilite\"><td><b><big>TOTAL</big></b></td><td><b><big>$totaltyped</big></b></td><td>&nbsp;</td></tr></tfoot>";
		echo '</table>';
		}
		else
		{
		echo 'Sorry you do not have access to this information.';
		}

	}
}
// get footer
include '../parts/footer.php';
?>