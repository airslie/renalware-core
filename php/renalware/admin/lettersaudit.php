<?php
include '../req/confcheckfxns.php';
$pagetitle= $siteshort . " Letters Audit";
include "$rwarepath/navs/topsimplenav.php";
include "$rwarepath/navs/usernav.php";
//get total
$display = 200; //default
$displaytext = "Letters displayed for audit"; //default
$sql= "SELECT letter_id FROM letterdata WHERE reviewdate is not NULL";  // default
$result = $mysqli->query($sql);
$num_records = $result->num_rows;
$orderby = "ORDER BY lettmodifstamp ASC"; //default
if ( isset($_GET['sort']) )
{
	$sort=$_GET['sort'];
	$orderby = "ORDER BY $sort ASC";	
	if ( $sort=='patient' )
		{
		$orderby = "ORDER BY patlastfirst";
		}
	if ( $sort=='typist' )
		{
		$orderby = "ORDER BY userlast, userfirst";
		}
}
$displaytime = date("D j M Y  G:i:s");
$fields = "
letter_id,
letterzid,
letthospno,
lettuid,
lettuser,
lettmodifstamp,
authorid,
typistid,
typistinits,
letterdate,
status,
lettdescr,
wordcount,
patlastfirst,
authorlastfirst,
lettertype,
typeddate,
reviewdate,
DATEDIFF(reviewdate, typeddate) as reviewlag,
concat(userlast, ', ', userfirst) as typist";
$tables = "letterdata LEFT JOIN userdata ON lettuid=uid";
$where = "WHERE reviewdate is not NULL"; // default
$sql= "SELECT $fields FROM $tables $where $orderby LIMIT $display";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
$showrows = ($numrows) ? "$numrows $displaytext. Click on headers to sort. IMPORTANT: assumes dictated date=typed date." : "There are no $displaytext" ;
echo "<p class=\"header\">$showrows</p>";
	if ($numrows) {
	echo '<table class="tablesorter"><thead>
	<tr><th>HospNo</th>
	<th>patient</th>
	<th>date</th>
	<th>description</th>
	<th>Status</th>
	<th>author</th>
	<th>typist</th>
	<th>TYPED date</th>
	<th>REVIEWED date</th>
	<th>"lag"</th>
	</tr></thead><tbody>';
	while ($row = $result->fetch_assoc()) {
		$status = $row['status'];
		$lettertype = $row['lettertype'];
		$descr = '<acronym title="' . $row["abstract"] . '">' . $row["lettdescr"] . '</a>';
		echo '<tr>
		<td>' . $row["letthospno"] . '</td>
		<td>' . $row["patlastfirst"] . '</td>
		<td>' . dmy($row["letterdate"]) . '</td>
		<td>' . $row["lettdescr"] . '</td>
		<td><font color="#ff0000">' . $row["status"] . '</font></td>
		<td>' . $row["authorlastfirst"] . '</td>
		<td>' . $row["typist"] . '</td>
		<td>' . dmy($row["typeddate"]) . '</td>
		<td>' . dmy($row["reviewdate"]) . '</td>
		<td><b>' . $row["reviewlag"] . '</b></td>
		</tr>';
		}
	echo '</tbody></table>';
	}
// get footer
include '../parts/footer.php';
?>