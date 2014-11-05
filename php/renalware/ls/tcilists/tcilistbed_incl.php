<?php
$fields="";
$theaders="<th>options</th>";
foreach ($fieldslist as $key => $value) {
	$fields.=", $key";
	if (!in_array($key,$omitfields)) {
	$theaders.='<th>'.$value. "</th>\r";
	}
}
//remove leading commas
$fields=substr($fields,1);
$orderby="ORDER BY tcilistrank ASC";
$sql = "SELECT $fields FROM $table $where $orderby";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
if ($showsql) {
	echo "<p class=\"alertsmall\">$sql</p>";
}
if ($numrows) {
	showInfo("$numrows $listitems found","$listnotes");
} else {
	showAlert("No matching $listitems located!");
}
?>
<?php if ($numrows): ?>
<table id="datatable" class="display">
	<thead><tr><?php echo $theaders ?><th>Notes</th></tr></thead>
	<tbody>
<?php
while($row = $result->fetch_assoc())
	{
	$zid=$row["tcilistzid"];
	$tciproced_id=$row["tciproced_id"];
	$tcilist_id=$row["tcilist_id"];
	$activeflag=$row["activeflag"];
	echo "<tr>";
	//special for bedmgt
	if (!$tciproced_id) {
		echo '<td><a href="bedmgt/index.php?vw=proced&scr=requestsurgcase&amp;zid='.$zid.'&amp;tcilist_id='.$tcilist_id.'" >Request Op/Procedure</a></td>';
	} else {
		echo '<td><a href="bedmgt/index.php?vw=proced&scr=update&amp;zid='.$zid.'&amp;pid='.$tciproced_id.'" >view '.$row["status"].'</a></td>';
	}
	foreach ($row as $key => $value) {
		if (!in_array($key,$omitfields)) {
			$tdval = (strtolower(substr($key,-4)=="date")) ? dmyyyy($value) : $value ;
			echo '<td>'.$tdval.'</td>';
		}
	}
	//special for descr
	echo '<td style="width: 200px;">'.$row["tcinotes"].'</td>
	</tr>';
	}
	?>
	</tbody>
</table>
<script>
		$('#datatable').dataTable( {
			"bPaginate": true,
			"bLengthChange": true,
			"bJQueryUI": false,
			//"sPaginationType": "full_numbers",
			"bFilter": true,
			"aaSorting": [[ 1, "asc" ]],
			"iDisplayLength": 40,
			"aLengthMenu": [[10,20,40, 50, 100, -1], [10,20,40, 50, 100, "All"]],
			"bSort": true,
			"bInfo": true,
			"bAutoWidth": false,
			"bStateSave": true
		} );
</script>
<?php endif ?>