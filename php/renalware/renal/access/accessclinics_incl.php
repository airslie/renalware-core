<?php
//if form submitted
$addtable='accessclinics';
$addtablename='Access Clinics';
$addlabel='Add new access clinic';
echo "<h3>$addtablename</h3>";
if ( $_POST['add']=="$addtable" )
	{
	include( $addtable . '_add.php' );
	}

$descr = "access clinics";
$fields = "addstamp,
accessclindate,
surgeon,
decision,
ixrequests,
anaesth,
priority
";
//assume want most recent on top so DESC
$sql= "SELECT $fields FROM $addtable WHERE accessclinzid=$zid ORDER BY accessclindate DESC";
$result = $mysqli->query($sql);
//for debugging
$numrows = $result->num_rows;
if ($numrows) {
	echo "<p class=\"header\">There are currently $numrows $descr recorded.</p>";
	echo '<table class="list">
	    <tr>
	    <th>added</th>
	    <th>clinic date</th>
	    <th>surgeon/assessor</th>
	    <th>decision</th>
	    <th>Ix requests</th>
	    <th>LA/GA</th>
	    <th>Priority</th>
	    </tr>
	    ';
	while ($row = $result->fetch_assoc())
		{
		echo '<tr>';
		echo "
		<td>" . $row["addstamp"] . "</td>
		<td>" . dmy($row["accessclindate"]) . "</td>
		<td>" . $row["surgeon"] . "</td>
		<td>" . $row["decision"] . "</td>
		<td>" . $row["ixrequests"] . "</td>
		<td>" . $row["anaesth"] . "</td>
		<td>" . $row["priority"] . "</td>
		</tr>\n";
		}
	echo '</table>';
} else {
	echo "<p class=\"headergray\">No $descr recorded.</p>";
}
?>