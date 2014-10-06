<?php
//----Mon 16 May 2011----
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
	<thead><tr><?php echo $theaders ?></tr></thead>
	<tbody>
	<?php
	while($row = $result->fetch_assoc())
		{
		$zid=$row["patzid"];
		echo "<tr>";
		//options links
		echo '<td>';
		foreach ($optionlinks as $link => $label) {
			echo '<a href="'.$link.'&amp;zid='.$zid.'" target="new">'.$label.'</a> ';
		}
		echo '</td>'; //end options
		foreach ($row as $key => $value) {
			if (!in_array($key,$omitfields)) {
				$tdval = (strtolower(substr($key,-4)=="date")) ? dmyyyy($value) : $value ;
				echo '<td>'.$tdval.'</td>';
				//echo '<td>'.$value.'</td>';
			}
		}
		echo '</tr>';
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
		"bAutoWidth": true,
		"bStateSave": true
	} );
</script>
<?php endif ?>