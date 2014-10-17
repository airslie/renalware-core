<p><a href="pat/patient.php?vw=admissions&amp;zid=<?php echo $zid ?>">View Renal Unit Admissions</a></p>
<p class="alertsmall">NOTE: We regret that some PIMS feed data generated around 20-22 April 2009 are missing.</p>
<h3>PIMS Pre-Admissions/Appointments</h3>
<?php
//-------SET FORM VARS--------
$thisvw="hl7visits";
//include realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';
$displaytext = "PIMS Pre-Admissions for $firstnames $lastname"; //default
$fieldslist=array(
	'admitdatetime'=>'Appointment date',
	'ward'=>'wardcode',
	'wardname'=>'location',
	'servicecode'=>'service',
	'referrer'=>'referrer',
	'consultcode'=>'consultcode',
	'consultname'=>'consultant',
	'DATEDIFF(admitdate,CURDATE())'=>'days until appt',
	'mshdatetime'=>'Booked/Entered',
	);
$thisportalname="Patient Pre-Admissions";
$fields="";
$omitfields=array();
$th ="";
$orderby = "ORDER BY admitdate" ;
foreach ($fieldslist as $key => $value) {
	$fields.=", $key";
	if (!in_array($key,$omitfields)) { //hide unwanted headers
	$th.="<th>$value</th>";
	}
}
//remove leading commas
$fields=substr($fields,1);
$table = "hl7data.eventsdata LEFT JOIN hl7data.wardcodes ON ward=wardcode";
$where = "WHERE kchno='$hospno1' AND eventcode='A05' AND admitdate>=CURDATE()";
$sql = "SELECT $fields FROM $table $where $orderby $showportallimit";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
//IF there are records
if ($numrows=='0')
	{
	echo "<p class=\"header\">There are no $thisportalname found!</p>";
} else {
	echo "<p class=\"header\">$numrows $thisportalname found $sortedby</p>";
	echo "<table class=\"tablesorter\"><thead><tr>$th</tr></thead><tbody>";
	while($row = $result->fetch_assoc())
		{
		echo "<tr>";
	//------------DO NOT MODIFY BELOW!---------
	//render data rows
		foreach ($row as $key => $value) {
			$tdval=$row["$key"];
			$tdclass="";
			if (substr($key,-4)=="date") {
				$tdval = dmy($tdval) ;
			}
			if (!in_array($key,$omitfields)) {
				echo '<td>'.$tdval.'</td>';
			}
		}
		echo '</tr>';
		}
	echo '</table>';
	}
?>
<hr />
<h3>PIMS Visits History</h3>
<?php
//-------SET FORM VARS--------
$thisvw="hl7visits";
//include realpath($_SERVER['DOCUMENT_ROOT']).'/renalwareconn.php';
$displaytext = "PIMS Visits/Admissions for $firstnames $lastname"; //default
$fieldslist=array(
	'admitdatetime'=>'Appointment date',
	'ward'=>'wardcode',
	'wardname'=>'location',
	'servicecode'=>'service',
	'referrer'=>'referrer',
	'consultcode'=>'consultcode',
	'consultname'=>'consultant',
	'mshdatetime'=>'Booked/Entered',
	);
$thisportalname="PIMS Visits/Admissions";
$fields="";
$omitfields=array();
$th ="";
$orderby = "ORDER BY admitdate DESC" ;
foreach ($fieldslist as $key => $value) {
	$fields.=", $key";
	if (!in_array($key,$omitfields)) { //hide unwanted headers
	$th.="<th>$value</th>";
	}
}
//remove leading commas
$fields=substr($fields,1);
$table = "hl7data.eventsdata LEFT JOIN hl7data.wardcodes ON ward=wardcode";
$where = "WHERE kchno='$hospno1' AND eventcode='A01'";
$sql = "SELECT $fields FROM $table $where $orderby $showportallimit";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
//IF there are records
if ($numrows=='0')
	{
	echo "<p class=\"header\">There are no $thisportalname found!</p>";
} else {
	echo "<p class=\"header\">$numrows $thisportalname found $sortedby</p>";
	// table header w/ autosorts :)
	echo "<table class=\"tablesorter\"><thead><tr>$th</tr></thead><tbody>";
	while($row = $result->fetch_assoc())
		{
		echo "<tr>";
	//------------DO NOT MODIFY BELOW!---------
	//render data rows
		foreach ($row as $key => $value) {
			$tdval=$row["$key"];
			$tdclass="";
			if (substr($key,-4)=="date") {
				$tdval = dmy($tdval) ;
			}
			if (!in_array($key,$omitfields)) {
				echo '<td>'.$tdval.'</td>';
			}
		}
		echo '</tr>';
		}
	echo '</tbody></table>';
	}
?>