<?php
$fields="";
//$theaders="<th>options</th>";
$theaders="";
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
	<thead><tr><?php echo $theaders ?><th>Description/Options</th></tr></thead>
	<tbody>
<?php
while($row = $result->fetch_assoc())
	{
	$zid=$row["consultzid"];
	$consult_id=$row["consult_id"];
	$activeflag=$row["activeflag"];
	echo "<tr>";
	foreach ($row as $key => $value) {
		if (!in_array($key,$omitfields)) {
			$tdval = (strtolower(substr($key,-4)=="date")) ? dmyyyy($value) : $value ;
			echo '<td>'.$tdval.'</td>';
		}
	}
	//special for descr
	echo '<td style="width: 450px;">'.$row["consultdescr"] . '<br>';
    //options
    echo '<a href="pat/patient.php?vw=clinsumm&amp;zid='.$zid.'" >ClinSumm</a>&nbsp;&nbsp;
        <a href="pat/patient.php?vw=editconsult&amp;zid='.$zid.'&amp;consult_id='.$consult_id.'">Update</a>&nbsp;&nbsp;
    <a href="pat/patient.php?vw=addtcilistform&amp;zid='.$zid.'&amp;consult_id='.$consult_id.'">add TCI</a>&nbsp;&nbsp;';
    if ($activeflag=='Y') {
        echo '<a href="run/run_endconsult.php?zid='.$zid.'&amp;consult_id='.$consult_id.'">mark DONE</a>';
    }
    echo '</td>
	</tr>';
	}
	?>
	</tbody>
</table>
<script>
		$('#datatable').dataTable( {
			"bPaginate": <?php echo $paginate ?>,
			"bLengthChange": false,
			"bJQueryUI": false,
			//"sPaginationType": "full_numbers",
			"bFilter": true,
			"aaSorting": [[ 0, "asc" ]],
			"bSort": true,
			"bInfo": true,
			"bAutoWidth": false,
			"bStateSave": false
		} );
</script>
<?php endif ?>