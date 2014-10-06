<?php
//--Sun Dec  1 17:34:25 CET 2013--
$fields="";
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
	bs_Alert("warning",$sql);
}
if ($numrows) {
	bs_Para("success","<b>$numrows $listitems found</b> $listnotes");
} else {
	bs_Para("danger","No matching $listitems located!");
}
?>
<?php if ($numrows): ?>
<table class="table table-bordered datatable">
	<thead><tr><?php echo $theaders ?></tr></thead>
	<tbody>
	<?php
	while($row = $result->fetch_assoc())
		{
		$zid=$row["patzid"];
		echo "<tr>";
		foreach ($row as $key => $value) {
			if (!in_array($key,$omitfields)) {
				//$tdval = (strtolower(substr($key,-4)=="date")) ? dmyyyy($value) : $value ;
				echo '<td>'.$value.'</td>';
			}
		}
		echo '</tr>';
		}
	?>
	</tbody>
</table>
<?php endif ?>