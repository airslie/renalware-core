<?php
include '../req/confcheckfxns.php';
$pagetitle= "$siteshort Letter Descriptions";
include "$rwarepath/navs/topusernav.php";
$displaytext = "letter types analyzed for $siteshort"; //default
$orderby = "ORDER BY lettdescr"; //incl ORDER BY prn
$sql= "SELECT lettertype_id, lettdescr, count(letter_id) as typecount FROM letterdata GROUP BY lettertype_id";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
echo "<p class=\"header\">$numrows $displaytext</p>";
?>
<table border="0" cellspacing="4" cellpadding="2">
<tr>
	<th>type ID</th>
	<th>letter description</th>
	<th>count</th>
</tr>
<?php
while($row = $result->fetch_assoc()) {
	echo '<tr>
		<td>' . $row["lettertype_id"] . '</td>
		<td>' . $row["lettdescr"] . '</td>
		<td><b>' . $row["typecount"] . '</b></td>
	</tr>';
}
?>
</table>
<?php
include '../parts/footer.php';
?>