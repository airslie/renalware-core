<?php
include '../req/confcheckfxns.php';
$pagetitle= $sitelong . ' System Table Status';
include "$rwarepath/navs/topusernav.php";
?>
<table><tr>
<td valign="top">
<p class="header">RENALWARE TABLES</p>
<table>
<tr>
	<th>Table</th>
	<th>Engine</th>
	<th>Rows</th>
	<th>Data</th>
	<th>Updated</th>
</tr>
<?php
$mysqli->select_db("renalware");
$sql="show table status;";
$result = $mysqli->query($sql);
$size = 0;
while($row = $result->fetch_assoc()) {
	$size += $row["Data_length"];
	$name= $row["Name"];
	$rows=$row['Rows'];
	$engine=$row['Engine'];
	$updated=$row['Update_time'];
   $datalength=round(($row["Data_length"]/1024)/1024, 2);
	echo "<tr bgcolor=\"$bg\">
	<td><b>$name</b></td>
	<td>$engine</td>
	<td>$rows</td>
	<td>$datalength</td>
	<td>$updated</td></tr>";
}
$totalsize = round(($size/1024)/1024, 2);
echo "</table>";
echo "Total Renalware data size: <b>$totalsize</b>";
?>
</td>
<td valign="top">
<p class="header">KINGSPATH TABLES</p>
<table>
<tr>
	<th>Table</th>
	<th>Engine</th>
	<th>Rows</th>
	<th>Data</th>
	<th>Updated</th>
</tr>
<?php
$mysqli->select_db("hl7data");
$sql="show table status";
$result = $mysqli->query($sql);
$size = 0;
while($row = $result->fetch_assoc()) {
	$size += $row["Data_length"];
	$name= $row["Name"];
	$rows=$row['Rows'];
	$engine=$row['Engine'];
	$updated=$row['Update_time'];
   	$datalength=round(($row["Data_length"]/1024)/1024, 2);
	echo "<tr>
	<td><b>$name</b></td>
	<td>$engine</td>
	<td>$rows</td>
	<td>$datalength</td>
	<td>$updated</td></tr>";
	}
$totalsize = round(($size/1024)/1024, 2);
echo "</table>";
echo "Total hl7data data size: <b>$totalsize</b>";
?>
<p class="header">RENALLOGS TABLES</p>
<table>
<tr>
	<th>Table</th>
	<th>Engine</th>
	<th>Rows</th>
	<th>Data</th>
	<th>Updated</th>
</tr>
<?php
$mysqli->select_db("renalware");
$sql="show table status";
$result = $mysqli->query($sql);
$size = 0;
while($row = $result->fetch_assoc()) {
	$size += $row["Data_length"];
	$name= $row["Name"];
	$rows=$row['Rows'];
	$engine=$row['Engine'];
	$updated=$row['Update_time'];
   	$datalength=round(($row["Data_length"]/1024)/1024, 2);
	echo "<tr>
	<td><b>$name</b></td>
	<td>$engine</td>
	<td>$rows</td>
	<td>$datalength</td>
	<td>$updated</td></tr>";
	}
$totalsize = round(($size/1024)/1024, 2);
echo "</table>";
echo "Total Renallogs data size: <b>$totalsize</b>";
?>

</td></tr></table>
<?php
include '../parts/footer.php';
?>