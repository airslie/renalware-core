<form action="renal/renal.php" method="get">
<input type="hidden" name="vw" value="<?php echo $_GET['vw'] ?>" />
<select name="zid">
<?php
	//make lower case
	$findname=strtolower($mysqli->real_escape_string($_POST['renalpat']));
	//find out if firstname entered
	if(strstr($findname,","))
		{
		$lastfirst = explode(",",$findname);
		$ln = $lastfirst[0];
		$fn = $lastfirst[1];
		$sql= "SELECT patzid, lastname, firstnames, hospno1, birthdate FROM patientdata WHERE lower(lastname) LIKE '$ln' AND lower(firstnames) LIKE '$fn%'";
		}
	else //no comma
		{
		$sql= "SELECT patzid, lastname, firstnames, hospno1, birthdate FROM patientdata WHERE lower(lastname) LIKE '$findname%'";
		}
$result = $mysqli->query($sql);
	$numrows = $result->num_rows;	
	if ($numrows==0) {
		echo "Sorry no such patient was found. Please try again.<br>";
		include('findrenalpat.php');
		exit;
		}
	else
		{
		while ($row = $result->fetch_assoc())
			{
			$zid=$row['patzid'];
			echo '<option value="' . $zid . '">' . $row['lastname'] . ', ' . $row['firstnames'] . ' (' . $row['hospno1'] . ', DOB:' . $row['dob'] . ')</option>';
			}
		echo '</select><input type="submit" style="color: green;" value="Go to patient ' . $_GET['vw'] . 'screen" /></form>';
		}
?>