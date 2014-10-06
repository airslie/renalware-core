<?php
//get ops data
$orderby = "ORDER BY txopdate";
$fields="txop_id,
txopdate,
txopno,
txoptype,
patage,
donortype,
donorage,
recipCMVstatus,
donorCMVstatus,
txsite,
failureflag,
failuredate,
stentremovaldate
";
$sql= "SELECT $fields FROM txops WHERE txopzid=$zid $orderby";
$result = $mysqli->query($sql);
$numrows = $result->num_rows;
?>
<p class="header">Transplant Operations (<?php echo $numrows; ?> recorded) <small><a href="renal/forms/txops.php?mode=add&amp;zid=<?php echo $zid ?>">Add new transplant operation</a> &nbsp;&nbsp;&nbsp;<a onclick='$("#txbxdiv").toggle();'>Toggle Biopsy data</a>.</small></p>
<?php
if ( $numrows >0 )
{
	echo "<table class=\"list\">
	<tr>
	<th>Tx date</th>
	<th>Tx No</th>
	<th>type</th>
	<th>recip age at op</th>
	<th>donor type</th>
	<th>donor age</th>
	<th>donor CMV</th>
	<th>recip CMV</th>
	<th>site</th>
	<th>failure date</th>
	<th>stent removal date</th>
	<th>options</th>
	</tr>";
	while ($row = $result->fetch_assoc()) {
		$bg = ($row["failureflag"]==1) ? '#ddd' : '#fff' ;
		$update = '<a href="renal/forms/txops.php?mode=update&amp;zid='.$zid.'&amp;txop_id='.$row["txop_id"].'">update</a>';
		$viewprint = '<a href="renal/forms/txops.php?mode=view&amp;zid='.$zid.'&amp;txop_id='.$row["txop_id"].'">view/print</a>';
		$recipCMV = ($row["recipCMVstatus"]=="Positive") ? '<span class="hilite">'.$row["recipCMVstatus"].'</span' : $row["recipCMVstatus"] ;
		$donorCMV = ($row["donorCMVstatus"]=="Positive") ? '<span class="hilite">'.$row["donorCMVstatus"].'</span' : $row["donorCMVstatus"] ;
		echo '<tr bgcolor="'.$bg.'">
		<td>' . dmyyyy($row["txopdate"]) . '</td>
		<td>' . $row["txopno"] . '</td>
		<td>' . $row["txoptype"] . '</td>
		<td>' . $row["patage"] . '</td>
		<td>' . $row["donortype"] . '</td>
		<td>' . $row["donorage"] . '</td>
		<td>' . $donorCMV . '</td>
		<td>' . $recipCMV . '</td>
		<td>' . $row["txsite"] . '</td>
		<td>' . dmyyyy($row["failuredate"]) . '</td>
		<td>' . dmyyyy($row["stentremovaldate"]) . '</td>
		<td>' . $update .'&nbsp;&nbsp;'.$viewprint . '</td>
		</tr>';
	}
	echo '</table>';
}
?>
<div id="txbxdiv" style="display: none">
	<?php
	include 'txbxportal.php';
	?>
</div>