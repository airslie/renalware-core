<?php
//--Fri Oct 26 17:15:00 SGT 2012--
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
showInfo("$numrows $listitems found","$listnotes");
echo '<table id="datatable" class="display">
<thead><tr>'.$theaders.'</tr></thead>
	<tbody>';
while($row = $result->fetch_assoc())
	{
	$zid=$row["patzid"];
	echo "<tr>";
	//options links
	echo '<td>';
	foreach ($optionlinks as $link => $label) {
		echo '<a href="'.$link.'&amp;zid='.$zid.'" target="new">'.$label.'</a>&nbsp;&nbsp;';
	}
	echo '</td>'; //end options
	foreach ($row as $key => $value) {
		if (!in_array($key,$omitfields)) {
			$tdval = (strtolower(substr($key,-4)=="date")) ? dmyyyy($value) : $value ;
			echo '<td>'.$tdval.'</td>';
		}
	}
	echo '</tr>';
	}
echo '</tbody>
</table>';
?>
<script>
$('#datatable').dataTable( {
	"bPaginate": true,
	"bLengthChange": false,
	"bJQueryUI": false,
	//"sPaginationType": "full_numbers",
	"bFilter": true,
	"aaSorting": [[ 1, "asc" ]],
	"iDisplayLength": 100,
	//"aLengthMenu": [[10,20,40, 50, 100, -1], [10,20,40, 50, 100, "All"]],
	"bSort": true,
	"bInfo": true,
	"bAutoWidth": false,
	"bStateSave": true
} );
</script>
