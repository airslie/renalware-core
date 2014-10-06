<?php
	$name_entered=$mysqli->real_escape_string($_GET['patname']);
	//make lower case
	$findname=strtolower($name_entered);
	//find out if firstname entered
	if(strstr($findname,","))
		{
		$lastfirst = explode(",",$findname);
		$ln = $lastfirst[0];
		$fn = trim($lastfirst[1]); //trim to strip ", "
		$where = "WHERE lower(lastname) LIKE '$ln' AND lower(firstnames) LIKE '$fn%'";
		}
	else //no comma
		{
		$where = "WHERE lower(lastname) LIKE '$findname%'";
		}
		$sql= "SELECT patzid, lastname, firstnames, hospno1, modalcode, birthdate FROM patientdata $where";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
?>
<form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="get">
<?php
if ( $numrows=='0' ) {
	echo '<b>Sorry, no matches found!</b> Please revise your search below.<br>';
	}
else {
	echo '<select name="patzid">';
	while ($row = $result->fetch_assoc()) {
			$zid=$row['patzid'];
			echo '<option value="' . $zid . '">' . $row['lastname'] . ', ' . $row['firstnames'] . '&nbsp; &nbsp;' . $row['hospno1'] . ' ' . $row['modalcode'] . ' DOB ' . $row['dob'] . '</option>';
	}
		echo '</select><input type="submit" style="color: green;" value="Find this patient!" />';
}
?>
</form>